//
//  RealmManager.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import Foundation

import RealmSwift
import Realm

class RealmManager {
	static let shared = RealmManager()
	
	lazy var defaultRealm: Realm = {
		var realm: Realm!
		do {
			realm = try Realm()
		} catch let error {
			_$le(error)
			_$fail(reason: "Failed to create default Realm")
		}
		return realm
	}()
	
	lazy var inMemoryRealm: Realm = {
		var realm: Realm!
		let realmName = "MyInMemoryRealm_\(CFAbsoluteTimeGetCurrent())"
		do {
			realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: realmName))
		} catch _ {
			_$fail(reason: "Failed to create in memory Realm")
		}
		
		return realm
	}()
	
	init() {
		RealmManager.clearTmpDirectory()
		
		var config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
		var schemaVersion: UInt64 = 1
		
		if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
			let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
			let finalNumber = NSString(format: "%08d%08d", UInt64(version.stringByRemovingNonNumericCharacters()) ?? 0,
			                           UInt64(build.stringByRemovingNonNumericCharacters()) ?? 0)
			schemaVersion += UInt64((finalNumber as String).stringByRemovingNonNumericCharacters()) ?? 0
		}
		
		config.schemaVersion = schemaVersion
		config.migrationBlock =  { migration, oldSchemaVersion in }
		config.fileURL = config.fileURL!.deletingLastPathComponent()
			.appendingPathComponent("Realm")
		Realm.Configuration.defaultConfiguration = config
		_ = inMemoryRealm
	}
	
	
	// MARK: Interface methods
	
	static func cleanUpCache() {
		let realmManager = RealmManager.shared
		//More safe to create another one realm
		clearTmpDirectory()
		let reamls = [realmManager.defaultRealm, realmManager.inMemoryRealm]
		reamls.forEach { realm in
			realm.beginWrite()
			realm.deleteAll()
			do {
				try realm.commitWrite()
			} catch _ {
				_$fail(reason: "Failed to cleanup Realm")
			}
		}
	}
	
	func inMemoryRealmForCurrentThread() -> Realm {
		var realm: Realm!
		do {
			realm = try Realm(configuration: self.inMemoryRealm.configuration)
		} catch _ {
			_$fail(reason: "Failed to create in memory Realm")
		}
		return realm
	}
	
	
	// MARK: Private methods
	
	static func clearTmpDirectory() {
		do {
			URLCache.shared.removeAllCachedResponses()
			let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
			try tmpDirectory.forEach { file in
				let path = String(format: "%@%@", NSTemporaryDirectory(), file)
				try FileManager.default.removeItem(atPath: path)
			}
		} catch {
			_$l(error)
		}
	}
}
