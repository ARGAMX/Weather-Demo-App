//
//  TypeSwitcherCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import IGListKit
import RxSwift


protocol TypeSwitcherCellVMDelegate: class {
    func typeSwitcherCellTypeChanged(type: Int)
}


class TypeSwitcherCellVM: CellViewModel {
    private var id: String = "TypeSwitcherCellVM"
    weak var delegate: TypeSwitcherCellVMDelegate?
    lazy var type: Int = 0
    
    // MARK: - Init
        
    init(delegate: TypeSwitcherCellVMDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Interface methods
    
    func setType(_ type: Int) {
        self.type = type
        delegate?.typeSwitcherCellTypeChanged(type: type)
    }

}


extension TypeSwitcherCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TypeSwitcherCellVM else {
            return false
        }
        
        return object.id == id
    }
}

extension TypeSwitcherCellVM {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<TypeSwitcherCell, TypeSwitcherCellVM>()
    }
}
