//
//  WebService.swift
//

import Foundation
import Moya
import RxSwift
import Alamofire
import Result



typealias Error = Swift.Error

/// Closure that decides if and what request should be performed.
public typealias RequestResultClosure = (Result<URLRequest, MoyaError>) -> Void


class RxNetworkProvider<Target> where Target: Moya.TargetType {

    fileprivate let provider: MoyaProvider<Target>
    
// MARK: - Instance initialization
    
    public init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = RxNetworkProvider.WebServiceEndpointMapping,
                //requestClosure: @escaping MoyaProvider<Target>.RequestClosure = defaultNonAuthorizedRequestMapping,
                stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(),
                plugins: [PluginType] = [],
                oAuthRefreshableAuthorization: Bool = true) {
        
        let oAuth = oAuthRefreshableAuthorization
        let requestClosure = oAuth ? RxNetworkProvider<Target>.authorizedRequestMapping : RxNetworkProvider<Target>.nonAuthorizedRequestMapping
        var requestPlugins: [PluginType] = []
        
        #if DEBUG
        Settings.networkCallsLogEnabled ? requestPlugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))) : ()
        #endif
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: requestPlugins)
    }
    
    public final class func nonAuthorizedRequestMapping(for endpoint: Moya.Endpoint, closure: @escaping Moya.MoyaProvider<Target>.RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    public final class func authorizedRequestMapping(for endpoint: Moya.Endpoint, closure: @escaping Moya.MoyaProvider<Target>.RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            do {
                closure(.success(urlRequest))
            }
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    /// Designated request-making method.
    public func request(_ target: Target) -> Observable<Moya.Response> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { observer in
            let cancellableToken = self.provider.request(target) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
    
    // MARK: - Class methods

    class func WebServiceEndpointMapping(_ target: Target) -> Endpoint {
        var stringURL: String!
        if target.path.hasPrefix("https") {
            stringURL = target.path
        } else {
            if target.path.count > 0 {
                stringURL = target.baseURL.appendingPathComponent(target.path).absoluteString.removingPercentEncoding
            } else {
                stringURL = target.baseURL.absoluteString
            }
        }

        return Endpoint(url: stringURL, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }

    class func WebServiceAlamofireManager() -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = Constants.API.requestTimeOut

        let sharedCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        URLCache.shared = sharedCache

        let manager = Alamofire.Session(configuration: configuration)
        //manager.startRequestsImmediately = false

        return manager
    }

    func requestArray<T: MappableObject>(_ target: Target, type: T.Type, keyPath: String = "") -> Observable<[T]>{
        return request(target)
            .observeOn(MainScheduler.asyncInstance)
            .filter(statusCodes: Constants.API.validStatusCodeRange)
            .mapArray(type, keyPath: keyPath)
            .catchError{ error -> Observable<[T]> in
                let extractedError = RxNetworkProvider.extractError(error: error)
                RxNetworkProvider.logError(extractedError, methodName: target.path)
                return Observable.error(extractedError)
            }.observeOn(MainScheduler.instance)
    }

    func requestObject<T: MappableObject>(_ target: Target, type: T.Type, keyPath: String = "") -> Observable<T> {
        return request(target)
            .observeOn(MainScheduler.asyncInstance)
            .filter(statusCodes: Constants.API.validStatusCodeRange)
            .mapObject(type, keyPath: keyPath)
            .catchError{ error -> Observable<T> in
                let extractedError = RxNetworkProvider.extractError(error: error)
                RxNetworkProvider.logError(extractedError, methodName: target.path)
                return Observable.error(extractedError)
            }.observeOn(MainScheduler.instance)
    }
    
    func requestData(_ target: Target) -> Observable<Moya.Response> {
        return request(target)
            .observeOn(MainScheduler.asyncInstance)
            .filter(statusCodes: Constants.API.validStatusCodeRange)
            .catchError{ error in
                let extractedError = RxNetworkProvider.extractError(error: error)
                RxNetworkProvider.logError(extractedError, methodName: target.path)
                return Observable.error(extractedError)
            }.observeOn(MainScheduler.instance)
    }

    // MARK: Private methods

    class private func logError(_ error: Error, methodName: String) {

    }

    class private func extractError(error: Error) -> Error {
        guard let moyaError = error as? MoyaError else {
            return error
        }

        switch moyaError {
        case .statusCode(let reponse),
             .jsonMapping(let reponse):
            do {
                let error = try reponse.mapObjectExtractData() as ServerError
                return MoyaError.underlying(error, reponse)
            } catch _ {
                return error
            }
        default:
            return moyaError
        }
    }
}

/// Extension for processing raw NSData generated by network access.
extension ObservableType where Element == Response {
    
    /// Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filter(statusCodes: ClosedRange<Int>) -> Observable<Element> {
        return flatMap { response -> Observable<Element> in
            return Observable.just(try response.filter(statusCodes: statusCodes))
        }
    }
    
    public func filter(statusCode: Int) -> Observable<Element> {
        return flatMap { response -> Observable<Element> in
            return Observable.just(try response.filter(statusCode: statusCode))
        }
    }
}
