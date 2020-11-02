//
//  TownWeather+Networking.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import Foundation
import RxSwift


extension TownWeather {

    static func getCurrentWeather(towns: [Town]) -> Observable<[TownWeather]> {
        let townsIds: [Int] = towns.map { town in town["id"] as! Int }
        return WeatherAPIProvider.requestArray(.getCurrentWeather(townsIds), type: TownWeather.self, keyPath: "list")
    }
    
    static func getForecastWeather(lat: Double, lon: Double) -> Observable<Forecast> {
        return WeatherAPIProvider.requestObject(.getForecastWeather(lat: lat, lon: lon), type: Forecast.self)
    }
    
    static func isTownExist(townName: String) -> Observable<TownWeather> {
        return WeatherAPIProvider.requestObject(.isTownExist(townName: townName), type: TownWeather.self)
    }
    
}
