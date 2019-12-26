//
//  AppDelegate.swift
//  DragAndDrop
//
//  Created by Badre DAHA BELGHITI on 07/12/2019.
//  Copyright © 2019 BadNetApps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame:UIScreen.main.bounds)
        
        // Instantiate From StoryBoard
        let rootVC = SecretWordCollectionController()
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

