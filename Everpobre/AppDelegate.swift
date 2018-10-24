//
//  AppDelegate.swift
//  Everpobre
//
//  Created by Fco_Javier_Rodriguez on 20/10/18.
//  Copyright © 2018 Fco_Javier_Rodriguez. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "Everpobre")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard
            let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? NotebookListViewController
        
        else {
           return true
        }
        
        // Inyect coredata stack to the viewcontroller
        viewController.managedContext = coreDataStack.managedContext
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save data in/with coredata when go to background
        coreDataStack.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save data in/with coredata when the system unsubribe me
        coreDataStack.saveContext()
    }


}

