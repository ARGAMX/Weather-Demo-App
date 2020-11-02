//
//  WebService+Additions.swift
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON


extension ObservableType where Element == Moya.Response {
	func mapObject<T: MappableObject>(_ type: T.Type, keyPath: String = "") -> Observable<T> {
		return flatMapLatest { response -> Observable<T> in
			return Observable.create { observer -> Disposable in
				do {
					let value = try response.mapObjectExtractData(keyPath) as T
					observer.onNext(value)
				} catch {
					observer.onError(error)
				}
				observer.onCompleted()
				return Disposables.create()
			}
		}
	}
	
	func mapArray<T: MappableObject>(_ type: T.Type, keyPath: String = "") -> Observable<[T]> {
		return flatMapLatest { response -> Observable<[T]> in
			return Observable.create { observer -> Disposable in
				do {
					let value = try response.mapArrayExtractData(keyPath) as [T]
					observer.onNext(value)
				} catch {
					observer.onError(error)
				}
				observer.onCompleted()
				return Disposables.create()
			}
		}
	}
}


extension Moya.Response {
	
	/// Maps data received from the signal into an object which implements the Mappable protocol.
	/// If the conversion fails, the signal errors.
	@nonobjc func mapObjectExtractData<T: MappableObject>(_ keyPath: String = "") throws -> T {
        let jsonInfo = try JSON(data: data)
		guard jsonInfo.exists() else {
			throw MoyaError.jsonMapping(self)
		}
		
		var dictianaryObject: [String: Any]?
		
		if keyPath.count == 0 {
			dictianaryObject = jsonInfo.dictionaryObject
		} else {
			dictianaryObject = (jsonInfo.dictionaryObject as NSDictionary?)?.value(forKeyPath: keyPath) as? [String: Any]
		}
		
		guard let dictionary = dictianaryObject else {
			throw MoyaError.jsonMapping(self)
		}
		
		let object = T()
		object.setValuesForKeys(dictionary)
		
		return object
	}
	
	/// Maps data received from the signal into an array of objects which implement the Mappable
	/// protocol.
	/// If the conversion fails, the signal errors.
	@nonobjc func mapArrayExtractData<T: MappableObject>(_ keyPath: String = "") throws -> [T] {
        let jsonInfo = try JSON(data: data)
		guard jsonInfo.exists() else {
			throw MoyaError.jsonMapping(self)
		}
		
		var arrayObject: [Any]?
		if keyPath.count == 0 {
			arrayObject = jsonInfo.arrayObject
		} else {
			arrayObject = (jsonInfo.dictionaryObject as NSDictionary?)?.value(forKeyPath: keyPath) as? [Any]
		}
		
		guard let array = arrayObject else {
			throw MoyaError.jsonMapping(self)
		}
		
		let objects = try array.map{ dictionary -> T in
			guard let dictionary = dictionary as? [String: Any] else {
				throw MoyaError.jsonMapping(self)
			}
			let object = T()
			object.setValuesForKeys(dictionary)
			return object
		}
		
		return objects
	}
}
