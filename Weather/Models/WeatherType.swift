//
//  WeatherType.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//


class WeatherType: MappableObject {
    dynamic var id: Int = 0
    dynamic var main: String = ""
    dynamic var desc: String = ""
    dynamic var icon: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func properiesMappingNames() -> [String: String] {
        return ["description": "desc"]
    }
}
