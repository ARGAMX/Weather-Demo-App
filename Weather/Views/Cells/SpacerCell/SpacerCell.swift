//
//  SpacerCell.swift
//

import UIKit

class SpacerCell: GenericCell<SpacerCellVM> {
    
    override func configureWith(_ viewModel: SpacerCellVM) {
        backgroundColor = viewModel.backgroundColor
    }
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: SpacerCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: viewModel.height)
    }
    
}
