//
//  Forecast.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import RealmSwift


class Forecast: MappableObject {
    dynamic var townID: Int = 0
    dynamic var lat: Double = 0
    dynamic var lon: Double = 0
    dynamic var daily: List<WeatherDaily> = List<WeatherDaily>()
    dynamic var dailyArray: [WeatherDaily]? {
        didSet {
            daily.removeAll()
            daily.append(objectsIn: dailyArray!)
        }
    }
    
    override static func primaryKey() -> String? {
        return "townID"
    }
    
    override class func properiesMappingNames() -> [String: String] {
        return ["daily": "dailyArray"]
    }
    
    override class func ignoredProperties() -> [String] {
        return ["dailyArray"]
    }
}
