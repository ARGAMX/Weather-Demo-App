//
//  UIViewController+StatusBarNotifications.swift
//

import UIKit
import SwiftMessages


protocol ViewControllerMessagesProtocol: class {
    func showBlockingAlert(title: String?, message: String?, okPress: SimpleBlock?)
    func showStatusBarSuccess(_ message: String)
    func showStatusBarInfo(_ message: String)
    func showStatusBarError(_ message: String)
    func showStatusBarError(_ error: Error)
    func showStatusBarError(_ error: NSError)
    func showStatusBarError(_ error: ServerError)
}


extension UIViewController: ViewControllerMessagesProtocol {
    
    func showBlockingAlert(title: String?, message: String?, okPress: SimpleBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК".localized(), style: .default, handler: { (action: UIAlertAction!) in
            okPress?()
        })
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true, completion: nil)
    }

    func showStatusBarSuccess(_ message: String) {
        MessagePresenter.showStatusBarSuccess(self, message)
    }
    
    func showStatusBarInfo(_ message: String) {
        MessagePresenter.showStatusBarInfo(self, message)
    }
    
    func showStatusBarError(_ message: String) {
        MessagePresenter.showStatusBarError(self, message)
    }
    
    func showStatusBarError(_ error: Error) {
        MessagePresenter.showStatusBarError(self, error)
    }
    
    func showStatusBarError(_ error: NSError) {
        MessagePresenter.showStatusBarError(self, error.domain)
    }
    
    func showStatusBarError(_ error: ServerError) {
        MessagePresenter.showStatusBarError(self, error)
    }

}

struct MessagePresenter {
    
   // MARK: - public
    
    static func showStatusBarSuccess(_ vc: UIViewController?, _ message: String) {
        MessagePresenter.statusBarMessage(vc, .success, message: message)
    }
    
    static func showStatusBarInfo(_ vc: UIViewController?, _ message: String) {
        MessagePresenter.statusBarMessage(vc, .info, message: message)
    }
    
    static func showStatusBarError(_ vc: UIViewController?, _ message: String) {
        if (message.count > 0) {
            MessagePresenter.statusBarMessage(vc, .warning, message: message)
        }
        else {
            MessagePresenter.statusBarMessage(vc, .warning, message: serverUnknownError2)
        }
    }
    
    static func showStatusBarError(_ vc: UIViewController?, _ error: Error) {
        let errorText = error.extractErrorText()
        showStatusBarError(vc, errorText)
    }
    
    static func showStatusBarError(_ vc: UIViewController?, _ error: ServerError) {
        let errorText = error.errCodeAndMsg
        showStatusBarError(vc, errorText)
    }
    
   // MARK: - private
    
    private static func statusBarMessage(_ vc: UIViewController?, _ theme: Theme, message: String) {
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        //config.presentationContext = .viewController(vc)
        config.duration = .seconds(seconds: 4.0)
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: "", body: message)
        view.button?.removeFromSuperview()
        SwiftMessages.show(config: config, view: view)
    }
    
}
