//
//  AppDelegate.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 22.12.22.
//

import UIKit
import NEWStreamApp

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appRouter: ApplicationRouter = {
        self.window = UIWindow()
        return ApplicationRouter(window: self.window!)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appRouter.presentRootController()
        return true
    }
}

