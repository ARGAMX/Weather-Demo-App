//
//  TextFieldCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import IGListKit
import RxSwift


protocol TextFieldCellVMDelegate: class {
    func textFieldCellVMTextDidChange(text: String?)
    func textFieldCellVMButtonDidPressed(text: String?)
    func textFieldCellVMTextFieldShouldInput(text: String, string: String, range: NSRange) -> Bool
}

extension TextFieldCellVMDelegate {
    func textFieldCellVMTextFieldShouldInput(text: String, string: String, range: NSRange) -> Bool {
        return true
    }
}


class TextFieldCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: TextFieldCellVMDelegate?

    var placeholderText: String?
    var textInputed: String?
    let cellId: String?
    var height: CGFloat
    let addButtonTitle: String = "Add"
        
    // MARK: - Init
        
    init(delegate: TextFieldCellVMDelegate?, placeholderText: String? = nil, cellId: String? = nil, height: CGFloat = 20.0) {
        self.delegate = delegate
        self.placeholderText = placeholderText
        self.cellId = cellId
        self.height = height
    }

    // MARK: - Interface methods
    
    func textChanged(text: String?) {
        textInputed = text
        delegate?.textFieldCellVMTextDidChange(text: text)
    }
    
    func buttonPressed(text: String?) {
        delegate?.textFieldCellVMButtonDidPressed(text: text)
    }
    
    func textFieldShouldInput(text: String, string: String, range: NSRange) -> Bool {
        return delegate?.textFieldCellVMTextFieldShouldInput(text: text, string: string, range: range) ?? true
    }

}


extension TextFieldCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? TextFieldCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension TextFieldCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<TextFieldCell, TextFieldCellVM>()
    }
}
