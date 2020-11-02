//
//  ServerError.swift
//

import UIKit
import Moya


let serverUnknownError = "Error retrieving data from server".localized()
let serverUnknownError2 = "Error requesting data from the server".localized()

class ServerError: MappableObject, Swift.Error {
    
    var cod: Int = 0
    var message: String = ""
    
    var errCode: Int {
        return cod
    }
    
    var errMsg: String {
        return message
    }
    
    convenience init(error: Error) {
        self.init()
        self.message = error.localizedDescription
    }
    
    var errCodeAndMsg: String {
        return "(" + String(errCode) + ")" + " " + errMsg
    }
}


extension MoyaError {
	var title: String {
		switch self {
        case .underlying(let error, _):
            let mError = error
			if let servError = mError as? ServerError {
				return servError.errMsg
			} else {
				if (mError as NSError).code == NSURLErrorNotConnectedToInternet {
					return serverUnknownError
				} else {
					return serverUnknownError
				}
			}
		default:
			return serverUnknownError
		}
	}
}

extension Error {
    func extractErrorText() -> String {
        var errorText = serverUnknownError
        if let moyaError = self as? MoyaError {
            if (moyaError.title.count > 0) {
                errorText = moyaError.title
            }
            else {
                if let error_description = (((self as? MoyaError)?.errorUserInfo["NSUnderlyingError"]) as? ServerError)?["message"] as? String {
                    errorText = error_description
                }
                else {
                    errorText = self.localizedDescription
                }
            }
        }
        else {
            let nsError = self as NSError
            errorText = nsError.description
        }
        
        return errorText
    }
    
    func extractErrorCode() -> Int {
        var errorCode = -1
        if let moyaError = self as? MoyaError, (moyaError.errorCode > 0) && (String(moyaError.errorCode).count > 2) {
            errorCode = moyaError.errorCode
        }
        else {
            if let error_code = (((self as? MoyaError)?.errorUserInfo["NSUnderlyingError"]) as? ServerError)?["cod"] as? Int {
                errorCode = error_code
            }
            else {
                let nsError = self as NSError
                if (String(nsError.code).count > 2) {
                    errorCode = nsError.code
                }
            }
        }
        
        return errorCode
    }
}
