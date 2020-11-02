//
//  UIViewController+StatusBarNotifications.swift
//

import UIKit
import NVActivityIndicatorView


protocol ViewControllerAnimatingProtocol: class {
    func startAnimateBasicAnimation()
    func startAnimate()
    func stopAnimate()
}

extension UIViewController: ViewControllerAnimatingProtocol, NVActivityIndicatorViewable {
    
    // MARK: - public
    
    func startAnimateBasicAnimation() {
        startAnimating()
    }
    
    func startAnimate() {
        startAnimating(type: myChoiceAimationType)
    }
    
    func stopAnimate() {
        stopAnimating()
    }
    
   // MARK: - private
    
    var randomAnimationType: NVActivityIndicatorType {
        let all = NVActivityIndicatorType.allCases
        let rand = Int(arc4random_uniform(UInt32(all.count - 1))) + 1
        return all[rand]
    }
    
    var myChoiceAimationType: NVActivityIndicatorType {
        return NVActivityIndicatorType.ballRotateChase
    }
}
