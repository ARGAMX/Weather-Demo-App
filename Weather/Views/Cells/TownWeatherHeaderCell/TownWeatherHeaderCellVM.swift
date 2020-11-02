//
//  TownWeatherHeaderCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import IGListKit

protocol TownWeatherHeaderCellVMDelegate: class {
    func townWeatherHeaderCellVMPressed(_ viewModel: TownWeatherHeaderCellVM)
}

protocol DateableTown: class {
    var name: String { get }
    var date: Date { get }
}

class TownWeatherHeaderCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: TownWeatherHeaderCellVMDelegate?
    private var dateableTown: DateableTown
    
    var townName: String? {
        return dateableTown.name
    }
    
    var date: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        return formatter.string(from: dateableTown.date)
    }
    
    init(delegate: TownWeatherHeaderCellVMDelegate?, dateableTown: DateableTown) {
        self.delegate = delegate
        self.dateableTown = dateableTown
    }
        
    func didSelectItem(at index: Int) {
        delegate?.townWeatherHeaderCellVMPressed(self)
    }
}

extension TownWeatherHeaderCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? TownWeatherHeaderCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension TownWeatherHeaderCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<TownWeatherHeaderCell, TownWeatherHeaderCellVM>()
    }
}
