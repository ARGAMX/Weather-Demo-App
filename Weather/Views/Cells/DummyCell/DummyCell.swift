//
//  DummyCell.swift
//

import UIKit


class DummyCell: GenericCell<DummyCellVM> {

    @IBOutlet weak var shadowBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()     
    }
    
    override func configureWith(_ viewModel: DummyCellVM) {
        backgroundColor = viewModel.backgroundColor
        shadowBackground.isHidden = !viewModel.isShadowBackground
    }
    
    override class func cellSizeWith(_ containerSize: CGSize, _ viewModel: DummyCellVM) -> CGSize {
        return CGSize(width: containerSize.width, height: 1.0)
    }
}
