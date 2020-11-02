//
//  TownListItemCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit
import IGListKit


protocol TownListItemCellVMDelegate: class {
    func townListItemCellVMPressed(_ viewModel: TownListItemCellVM, index: Int)
}

protocol TemperaturableTown: class {
    var name: String { get }
    var temperature: String { get }
    var country: String { get }
    var iconUrl: String? { get }
}

class TownListItemCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: TownListItemCellVMDelegate?
    private var temperaturableTown: TemperaturableTown
    private var index: Int
    
    var townName: String? {
        return temperaturableTown.name
    }
    
    var temperature: String? {
        return temperaturableTown.temperature + Constants.tempSign
    }
    
    var iconUrl: URL? {
        if let iconUrl = temperaturableTown.iconUrl {
            return URL(string: iconUrl)
        }
        return nil
    }
    
    var place: String? {
        return temperaturableTown.country
    }
    
    init(delegate: TownListItemCellVMDelegate?, temperaturableTown: TemperaturableTown, index: Int) {
        self.delegate = delegate
        self.temperaturableTown = temperaturableTown
        self.index = index
    }
        
    func didSelectItem(at index: Int) {
        delegate?.townListItemCellVMPressed(self, index: self.index)
    }
}

extension TownListItemCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? TownListItemCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension TownListItemCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<TownListItemCell, TownListItemCellVM>()
    }
}
