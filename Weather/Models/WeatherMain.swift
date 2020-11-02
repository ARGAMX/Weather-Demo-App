//
//  WeatherMain.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//


class WeatherMain: MappableObject {
    dynamic var temp: Float = 0.0
    dynamic var feels_like: Float = 0.0
    dynamic var temp_min: Float = 0.0
    dynamic var temp_max: Float = 0.0
    dynamic var pressure: Int = 0
    dynamic var humidity: Int = 0
}
