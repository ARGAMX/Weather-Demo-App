//
//  GenericCellSectionController.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import IGListKit


class GenericCellSectionController<C: GenericCell<T>, T: CellViewModel>: ListSectionController {
    
    private var viewModel: T?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let viewModel = viewModel,
            let containerSize = collectionContext?.containerSize else {
                return CGSize.zero
        }

        return C.cellSizeWith(containerSize, viewModel)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(C.self, for: self, at: index)
        if let viewModel = viewModel {
            cell.configureWith(viewModel)
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? T
    }
    
    override func didSelectItem(at index: Int) {
        viewModel?.didSelectItem?(at: index)
    }
        
}
