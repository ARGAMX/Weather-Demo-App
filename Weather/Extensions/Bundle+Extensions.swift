//
//  Bundle+Extensions.swift
//

import UIKit

extension Bundle {
    static var appVersion: String {
        var dev = ""
        let release = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        #if DEBUG
            dev = " alpha"
        #endif
        let version = ("\(release ?? "undefined")" + " " + "(\(build ?? "undefined"))" + dev)
        return version
    }
    
    static var releaseNumber: String {
        return Bundle.main.releaseVersionNumber ?? ""
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
