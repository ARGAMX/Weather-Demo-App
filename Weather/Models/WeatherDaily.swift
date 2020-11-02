//
//  WeatherDaily.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//


class WeatherDaily: MappableObject {
    dynamic var dt: Double = 0
    dynamic var humidity: Int = 0
    dynamic var dew_point: Int = 0
    dynamic var wind_speed: Int = 0
    dynamic var wind_deg: Int = 0
    dynamic var pressure: Int = 0
    dynamic var clouds: Int = 0
    dynamic var pop: Int = 0
    dynamic var uvi: Int = 0
    
    dynamic var temp: Temperature?
    dynamic var feels_like: Temperature?
        
    dynamic var type: WeatherType?
    dynamic var typeArray: [WeatherType]? {
        didSet {
            type = typeArray?.first
        }
    }
    
    override class func properiesMappingNames() -> [String: String] {
        return ["weather": "typeArray"]
    }
    
    override class func ignoredProperties() -> [String] {
        return ["typeArray"]
    }

}

extension WeatherDaily: ForecastWeatherable {
    var tempDay: String? {
        if let tempa = temp?.day {
            let tempStr = String(Int(round(tempa)))
            return tempa > 0 ? "+" + tempStr : tempStr
        }
        return nil
    }
    
    var tempNight: String? {
        if let tempa = temp?.night {
            let tempStr = String(Int(round(tempa)))
            return tempa > 0 ? "+" + tempStr : tempStr
        }
        return nil
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
    
    var iconUrl: String? {
        if let icon = type?.icon {
            return Constants.API.webUrl + Constants.API.iconsAPIPath + icon + Constants.API.iconExtension
        }
        return nil
    }
}
