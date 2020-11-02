//
//  SpinnerCellSC.swift
//

import IGListKit


func SpinnerCellSC() -> ListSingleSectionController {
    
	let configureBlock = { (item: Any, cell: UICollectionViewCell) in
		guard let cell = cell as? SpinnerCell else { return }
		cell.animate()
	}
	
	let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
		guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 50.0)
	}
	
	return ListSingleSectionController(
		cellClass: SpinnerCell.self,
		configureBlock: configureBlock,
		sizeBlock: sizeBlock)
}
