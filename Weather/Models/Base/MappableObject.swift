//
//  MappableObject.swift
//

import Foundation
import RealmSwift


@objcMembers
public class MappableObject: Object {
    
	// MARK: - Interface methods
	
	class func properiesMappingNames() -> [String: String] {
		return [:]
	}
	
	
	// MARK: - Override methods
	
	override public func value(forUndefinedKey key: String) -> Any {
		let value: Any? = super.value(forKey: propertyNameForKey(key))
		if value != nil {
			return value!
		}
		return super.value(forUndefinedKey: key)!
	}
	
	override public func setValue(_ valueOptional: Any?, forKey key: String) {
		let propertyName = propertyNameForKey(key)
		let mirror = Mirror(reflecting: self)
		
        var childOptional: Mirror.Child?
        var mirrorDive: Mirror? = mirror
        var depth: Int = 0
        let maxDepth: Int = 10
        
        while (mirrorDive?.children.first{ $0.label == propertyName } == nil) && (depth < maxDepth) {
            mirrorDive = mirrorDive?.superclassMirror
            depth += 1
        }
        
        childOptional = mirrorDive?.children.first{ $0.label == propertyName }
        
		guard let child = childOptional else {
            if (LogParseResponseError) {_$lw("Property with name \(propertyName) not found in \(self.classForCoder)")}
			return
		}
		
		guard let value = valueOptional, (valueOptional is NSNull) == false else {
			if Mirror(reflecting: child.value).displayStyle == .optional {
				super.setValue(nil, forKey: propertyName)
			}
			return
		}
		
		guard (value is [String] && value is [NSNumber]) == false else {
			super.setValue(value, forKey: propertyName)
			return
		}
		
		if let values = value as? [[String: Any]] {
			let subjectType = Swift.type(of:child.value)
			guard let mappableObjectType = MappableObject.classFromString("\(subjectType)") else {
                if (Log) {_$lw("Failed to create class - \(subjectType) for propery \(propertyName)")}
				return
			}
			let mappableObjects: [MappableObject] = values.map{ value in
                let mappableObject = mappableObjectType.init()
				mappableObject.setValuesForKeys(value)
				return mappableObject
			}
			do {
				try ObjC.catchException {
					super.setValue(mappableObjects, forKey: propertyName)
				}
			} catch {
                if (Log) {_$lw("Property with name \(propertyName) is \(type(of:child.value)), but receive \(type(of:value))")}
			}
			
			return
		}
		
		if let value = value as? [String: Any] {
            let mirror = Mirror(reflecting: child.value)
            let subjectType = mirror.subjectType
			
			guard let displayType = mirror.displayStyle else {
                if (Log) {_$lw("Property with name \(propertyName) - failed to get property type")}
				return
			}

			switch displayType {
			case .optional:
                guard let mappableObjectType = MappableObject.classFromString("\(subjectType)") else {
                    if (Log) {_$lw("Failed to create class - \(subjectType) for propery \(propertyName)")}
					return
				}
				
				let mappableObject = mappableObjectType.init()
				mappableObject.setValuesForKeys(value)
				do {
					try ObjC.catchException {
						super.setValue(mappableObject, forKey: propertyName)
					}
				} catch {
                    if (Log) {_$lw("Property with name \(propertyName) is \(type(of: child.value)), but receive \(type(of:value))")}
				}
			case .`class`:
                guard subjectType is MappableObject.Type else {
                    if (Log) {_$lw("Property with name \(propertyName) should be subclass of MappableObject")}
					return
				}
				(child.value as AnyObject).setValuesForKeys(value)
			default:
                    if (Log) {_$lw("Property with name \(propertyName) - value from server not supported")}
			}
			
			return
		}
		
		
		do {
			try ObjC.catchException {
				super.setValue(value, forKey: propertyName)
			}
		} catch {
            if (Log) {_$lw("Property with name \(propertyName) is \(type(of:child.value)), but receive \(type(of:value))")}
		}

	}
	
	
	override public func setValue(_ value: Any?, forUndefinedKey key: String) {
		_$fail(reason:"Property with name '\(key)' can not be set in \(self.classForCoder)")
		//		super.setValue(value, forUndefinedKey: key)
	}
	
	// MARK: - Private methods
	
	private func propertyNameForKey(_ key: String) -> String {
		guard let value = type(of: self).properiesMappingNames()[key] else {
			let first = String(key.prefix(1)).lowercased()
			let other = String(key.dropFirst())
			return first + other
		}
		return value
	}
	
	private class func classFromString(_ value: String) -> MappableObject.Type? {
		var className: String = value
		
		let extraWords = ["Optional", "Array", "List"]
		extraWords.forEach { extraWord in
			let range = extraWord.startIndex..<extraWord.endIndex
			if className.count > extraWord.count {
				className = className.replacingOccurrences(of: extraWord, with: "", options: .literal, range: range)
				className = className.replacingOccurrences(of: "<", with: "")
				className = className.replacingOccurrences(of: ">", with: "")
			}
		}
		
		guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            if (Log) {_$fail(reason: "Can not get namespace")}
			return nil
		}
		
		guard let classType = NSClassFromString("\(namespace).\(className)") else {
            if (Log) {_$lw("\(className) not found in Bundle")}
			return nil
		}
		
		guard let result = classType as? MappableObject.Type else {
            if (Log) {_$lw("\(className) should be inherit from MappableObject")}
			return nil
		}
		
		return result
	}
}
