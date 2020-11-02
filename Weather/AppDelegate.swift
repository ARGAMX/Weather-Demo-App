//
//  AppDelegate.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareMainViewController()
        return true
    }
    
    private func prepareMainViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TownsListVC()
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }

}

