//
//  UIView+Extensions.swift
//

import UIKit
import Foundation
import RxSwift

// Cells helper

extension UIView {
	
	@nonobjc public class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
		return fromNib(nibNameOrNil, type: self)
	}
	
	@nonobjc public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T {
		let v: T? = fromNib(nibNameOrNil, type: T.self)
		return v!
	}
	
	@nonobjc public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
		var view: T?
		let name: String
		if let nibName = nibNameOrNil {
			name = nibName
		} else {
			name = nibName
		}
		let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)!
		for v in nibViews {
			if let tog = v as? T {
				view = tog
			}
		}
		return view
	}
	
	@nonobjc public class var nibName: String {
		let name = "\(self)".components(separatedBy: ".").first ?? ""
		return name
	}
	
	@nonobjc public class var nib: UINib? {
		if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
			return UINib(nibName: nibName, bundle: nil)
		} else {
			return nil
		}
	}
	
	@nonobjc public class func getNib() -> UINib? {
		let classString : String = NSStringFromClass(self.classForCoder())
		if let className = classString.components(separatedBy: ".").last {
			return UINib(nibName:className , bundle: nil)
		}
		return nil
	}
	
	@nonobjc public class func getReuseIdentifier() -> String {
		return NSStringFromClass(self)
	}
}


extension UIView {
	@nonobjc static var reusableIdentifier: String {
		return "\(self.classForCoder())" + "_identifier"
	}
	
	@nonobjc static var nibForClass: UINib? {
		return UINib.init(nibName: "\(self.classForCoder())", bundle: nil)
	}
}


// For laoding view from nib

extension UIView {
	
    func rounded(radius: CGFloat = 0) {
		if radius == 0 {
			self.layer.cornerRadius = self.bounds.height / 2
		} else {
			self.layer.cornerRadius = radius
		}
		self.clipsToBounds = true
    }
	
    @discardableResult func addBlurView(style: UIBlurEffect.Style = .dark, isOverlapsAll: Bool = false) -> UIView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        isOverlapsAll ? nil : self.sendSubviewToBack(blurEffectView)
        return blurEffectView
    }
}

extension UIView {
	
    var snapshot: UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    func addShadow(isRectangular: Bool) {
        addShadow(isRectangular: isRectangular, shadowOpacity: 0.1)
    }
    
    func addShadow(isRectangular: Bool, shadowOpacity: Float) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = shadowOpacity
        if (isRectangular) {
            self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
        }
    }
    
    func addSquareShadow(color: UIColor, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func addRoundedShadow(color: UIColor, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.addSquareShadow(color: color, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity)
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height/2).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowPath = shadowPath
    }
}

extension UITableView {

	func hideEmptyCells() {
		self.tableFooterView = UIView(frame: .zero)
	}
	
	func deselectCellIfNeeded() {
		if let indexPath = self.indexPathForSelectedRow {
			self.deselectRow(at: indexPath, animated: true)
		}
	}
}

extension UIScrollView {
	func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
		return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
	}
}
