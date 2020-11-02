//
//  SpacerCellVM.swift
//

import Foundation
import IGListKit
import RxSwift

class SpacerCellVM {
    
    var id: String = UUID().uuidString
    
    var backgroundColor: UIColor
    var height: CGFloat
    
    init(height: CGFloat = 10.0, backgroundColor: UIColor = .clear) {
        self.backgroundColor = backgroundColor
        self.height = height
    }
    
}

extension SpacerCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SpacerCellVM else { return false }
        return id == object.id
    }
}

extension SpacerCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<SpacerCell, SpacerCellVM>()
    }
}
