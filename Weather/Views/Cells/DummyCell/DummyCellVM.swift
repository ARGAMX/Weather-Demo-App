//
//  DummyCellVM.swift
//

import UIKit
import IGListKit


class DummyCellVM {
    private var unique = UUID().uuidString
    
    var backgroundColor: UIColor
    var isShadowBackground: Bool
    
    
    init(backgroundColor: UIColor = .clear, isShadowBackground: Bool = false) {
        self.backgroundColor = backgroundColor
        self.isShadowBackground = isShadowBackground
    }
         
}

extension DummyCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? DummyCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension DummyCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<DummyCell, DummyCellVM>()
    }
}
