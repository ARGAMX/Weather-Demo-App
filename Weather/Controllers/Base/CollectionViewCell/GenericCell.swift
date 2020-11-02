//
//  GenericCell.swift
//

import UIKit


class GenericCell<T: CellViewModel>: BaseCell {
    
    class func cellSizeWith(_ containerSize: CGSize, _ viewModel: T) -> CGSize {
        _$l("### ERROR !!! 'cellSizeWith' called from GenericCell. You should override that function in iheritor cell of <\(T.self)>")
        return CGSize(width: containerSize.width, height: containerSize.height)
    }
    
    func configureWith(_ viewModel: T) {
        
    }
    
}
