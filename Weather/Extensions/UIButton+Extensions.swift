//
//  UIButton+Extensions.swift
//

import UIKit

extension UIButton {
    
    public func setImage(_ image: UIImage?) {
        self.setImage(image, for: .normal)
    }
    
    public func setTitle(_ title: String?) {
        self.setTitle(title, for: .normal)
    }
    
    public func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: .normal)
    }

    public func makeSpaceBetweenIconAndText(insetAmount: CGFloat = 8.0) {
        // move image away left from the text
        let inset = insetAmount / 2.0
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -1.0 * inset, bottom: 0, right: inset)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -1.0 * inset)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
            
    public func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    public func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
    }
    
}
