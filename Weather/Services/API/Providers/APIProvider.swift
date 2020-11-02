//
//  WeatherAPIProvider.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import Foundation
import Moya


let WeatherAPIProvider = RxNetworkProvider<WeatherAPI>(
    oAuthRefreshableAuthorization: false
)


enum WeatherAPI {
    case getCurrentWeather(_ townsIds: [Int])
    case getForecastWeather(lat: Double, lon: Double)
    case isTownExist(townName: String)
}

extension WeatherAPI: TargetType {
    
	var path: String {
		switch self {
        case .getCurrentWeather:
            return "/group"
        case .getForecastWeather:
            return "/onecall"
        case .isTownExist:
            return "/weather"
        }
	}
	
	var parameters: [String: Any] {
		var params = [String: Any]()
        params["appid"] = Constants.API.Key
        params["units"] = "metric"
		
		switch self {
        case .getCurrentWeather(let townsIds):
            params["id"] = townsIds.map( { String($0) } ).joined(separator:",")
            return params
        case .getForecastWeather(let lat, let lon):
            params["lat"] = lat
            params["lon"] = lon
            params["exclude"] = "minutely,hourly"
            return params
        case .isTownExist(let townName):
            params["q"] = townName
            return params
        }
	}
    
    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
}
