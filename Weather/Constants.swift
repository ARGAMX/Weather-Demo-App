//
//  Constants.swift
//

import Foundation


struct Constants {
    
    static let unknownTemp = "--"
    static let tempSign = "°"
    
	struct API {
        static let Key = "338014b1232d96e0ba10985695733c0b"
        static let webUrl: String = "https://openweathermap.org/"
        static let baseAPIUrl: String = "https://api.openweathermap.org/"
        static let baseAPIPath: String = "/data/2.5/"
        static let iconsAPIPath: String = "/img/wn/"
        static let iconExtension: String = "@4x.png"
		static let validStatusCodeRange = ClosedRange(uncheckedBounds: (lower: 200, upper: 300))
		static let requestTimeOut = 15.0
	}

}
