//
//  WeatherCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import IGListKit

protocol WeatherCellVMDelegate: class {
    //func weatherCellVMSelected(_ viewModel: WeatherCellVM, townWeather: TownWeather)
}

protocol WeatherableTown: class {
    var name: String { get }
    var temperature: String { get }
    var feelsLike: String { get }
    var wind: String { get }
    var humidity: String { get }
    var pressure: String { get }
}

class WeatherCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: WeatherCellVMDelegate?
    private var weatherableTown: WeatherableTown
    
    var temperature: String? {
        return weatherableTown.temperature + Constants.tempSign
    }
    
    var feelsLike: String? {
        return Loc.feelsLike + " " + weatherableTown.feelsLike + Constants.tempSign
    }
    
    var wind: String? {
        return weatherableTown.wind + " m/s" // SW
    }
    
    var humidity: String? {
        return weatherableTown.humidity + "%"
    }
    
    var pressure: String? {
        return weatherableTown.pressure + " mmHg"
    }
    
    init(delegate: WeatherCellVMDelegate?, weatherableTown: WeatherableTown) {
        self.delegate = delegate
        self.weatherableTown = weatherableTown
    }
        
    func didSelectItem(at index: Int) {
        //delegate?.weatherCellVMSelected(self, townWeather: townWeather)
    }
}

extension WeatherCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? WeatherCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension WeatherCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<WeatherCell, WeatherCellVM>()
    }
}
