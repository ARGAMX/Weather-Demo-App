//
//  ForecastCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import IGListKit


protocol ForecastCellVMDelegate: class {
    func forecastCellVMPressed(_ viewModel: ForecastCellVM, index: Int)
}

protocol ForecastWeatherable: class {
    var tempDay: String? { get }
    var tempNight: String? { get }
    var iconUrl: String? { get }
    var date: Date { get }
}

class ForecastCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: ForecastCellVMDelegate?
    private var forecastWeatherable: ForecastWeatherable
    private var index: Int
        
    var weekDay: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: forecastWeatherable.date)
    }
    
    var date: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: forecastWeatherable.date)
    }
    
    var tempDay: String? {
        if let tempDay = forecastWeatherable.tempDay {
            return tempDay + Constants.tempSign
        }
        return nil
    }
    
    var tempNight: String? {
        if let tempNight = forecastWeatherable.tempNight {
            return tempNight + Constants.tempSign
        }
        return nil
    }
    
    var iconUrl: URL? {
        if let iconUrl = forecastWeatherable.iconUrl {
            return URL(string: iconUrl)
        }
        return nil
    }
    
    init(delegate: ForecastCellVMDelegate?, forecastWeatherable: ForecastWeatherable, index: Int) {
        self.delegate = delegate
        self.forecastWeatherable = forecastWeatherable
        self.index = index
    }
    
    func didSelectItem(at index: Int) {
        delegate?.forecastCellVMPressed(self, index: self.index)
    }
}

extension ForecastCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ForecastCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension ForecastCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<ForecastCell, ForecastCellVM>()
    }
}
