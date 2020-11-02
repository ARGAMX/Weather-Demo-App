//
//  Settings.swift
//

import Foundation

struct Settings {
    #if DEBUG
    static let networkCallsLogEnabled = true
    #else
    static let networkCallsLogEnabled = false
    #endif
}

#if DEBUG
let Log = false
let LogParseResponseError = false
#else
let Log = false
let LogParseResponseError = false
#endif
