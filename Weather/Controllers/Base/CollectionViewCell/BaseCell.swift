//
//  BaseCell.swift
//

import UIKit


open class BaseCell: UICollectionViewCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func layoutSubviews() {
        configureView()
        super.layoutSubviews()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureView() {
        
    }
        
}
