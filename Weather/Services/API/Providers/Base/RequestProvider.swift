//
//  RequestProvider.swift
//

import UIKit

@objcMembers
class RequestProvider {
        
    static var headers: [String: String] {
        var dict: [String: String] = [:]
        
        dict["os"] = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
        dict["platform"] = UIDevice.current.systemName
        dict["build"] = Bundle.main.buildVersionNumber
        dict["version"] = Bundle.main.releaseVersionNumber

        return dict
    }
    
}
