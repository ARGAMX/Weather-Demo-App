//
//  BaseTarget.swift
//

import Foundation
import Moya


extension TargetType {
    
    var headers: [String : String]? {
        return RequestProvider.headers
    }
    
	var baseURL: URL {
        return URL(string: Constants.API.baseAPIUrl + Constants.API.baseAPIPath)!
	}
	
	var method: Moya.Method {
		return .post
	}
		
	var sampleData: Data {
		return Data()
	}
    
    var authorizationType: AuthorizationType? {
        return .none
    }
    
}

extension TargetType {

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var encodingJSON: ParameterEncoding {
        return JSONEncoding.default
    }
    
}
