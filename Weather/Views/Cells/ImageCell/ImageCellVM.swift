//
//  ImageCellVM.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import IGListKit
import RxSwift


protocol ImageCellVMDelegate: class {
    func imageCellVMDidPressed(cellId: String?)
}


class ImageCellVM {
    private var unique = UUID().uuidString
    
    weak var delegate: ImageCellVMDelegate?
    let cellId: String?
    var height: CGFloat
    let imageName: String?
    let imageUrl: String?
    let imageContentMode: UIView.ContentMode
    
    // MARK: - Init
        
    init(delegate: ImageCellVMDelegate?, imageName: String? = nil, imageUrl: String? = nil, imageContentMode: UIView.ContentMode = .scaleAspectFit, cellId: String? = nil, height: CGFloat = 20.0) {
        self.delegate = delegate
        self.cellId = cellId
        self.height = height
        self.imageUrl = imageUrl
        self.imageName = imageName
        self.imageContentMode = imageContentMode
    }
    
    // MARK: - Interface methods
    
    func buttonDidPressed() {
        delegate?.imageCellVMDidPressed(cellId: cellId)
    }
}


extension ImageCellVM: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return unique as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ImageCellVM {
            return object.unique == self.unique
        } else {
            return false
        }
    }
}

extension ImageCellVM: CellViewModel {
    func sectionController() -> ListSectionController {
        return GenericCellSectionController<ImageCell, ImageCellVM>()
    }
}
