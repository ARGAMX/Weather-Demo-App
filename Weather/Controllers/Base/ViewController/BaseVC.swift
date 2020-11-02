//
//  RootVC.swift
//

import UIKit


protocol ViewControllerProtocol: class {
}

protocol ViewControllerCommonProtocol:
    ViewControllerAcitvityProtocol,
    ViewControllerProtocol
{}

protocol ViewControllerAcitvityProtocol:
    ViewControllerAnimatingProtocol,
    ViewControllerMessagesProtocol
{}


class BaseVC: UIViewController {
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - public
    
    @objc func actionRefresh(_ sender: Any) {
        
    }
    
    // MARK: - private

}
