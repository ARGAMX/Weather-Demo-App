//
//  TownWeather.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import RealmSwift


class TownWeather: MappableObject {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var dt: Double = 0
    dynamic var coord: Coord?
    dynamic var visibility: Int = 0
    dynamic var type: WeatherType?
    dynamic var weather: WeatherMain!
    dynamic var windInfo: Wind!
    dynamic var geo: TownGeo!
    dynamic var typeArray: [WeatherType]? {
        didSet {
            type = typeArray?.first
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func properiesMappingNames() -> [String: String] {
        return ["wind": "windInfo", "weather": "typeArray", "main": "weather", "sys": "geo"]
    }
    
    override class func ignoredProperties() -> [String] {
        return ["typeArray"]
    }
    
}

extension TownWeather: TemperaturableTown {
    var temperature: String {
        let temp = weather.temp
        let tempStr = String(Int(temp))
        return temp > 0 ? "+" + tempStr : tempStr
    }
    var country: String {
        return geo.country
    }
    var iconUrl: String? {
        if let icon = type?.icon {
            return Constants.API.webUrl + Constants.API.iconsAPIPath + icon + Constants.API.iconExtension
        }
        return nil
    }
}

extension TownWeather: DateableTown {
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
}

extension TownWeather: WeatherableTown {
    var feelsLike: String {
        let temp = weather.feels_like
        let tempStr = String(Int(round(temp)))
        return temp > 0 ? "+" + tempStr : tempStr
    }
    var wind: String {
        return String(windInfo.speed)
    }
    var humidity: String {
        return String(weather.humidity)
    }
    var pressure: String {
        return String(weather.pressure)
    }
}
