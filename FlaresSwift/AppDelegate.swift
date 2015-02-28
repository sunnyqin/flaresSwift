//
//  AppDelegate.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/27/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow!
	lazy var coreDataStack = CoreDataStack()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.window.backgroundColor = UIColor.whiteColor()
		
		var error: NSError?
		if let fetchRequest = coreDataStack.model.fetchRequestTemplateForName("UserFetchRequest") {
			let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as [User]
			if let user = results.first {
				let homeViewController = FLHomeViewController()
				homeViewController.loginUser = user
				self.window.rootViewController = UINavigationController(rootViewController: homeViewController)
				self.window.makeKeyAndVisible()
				return true
			}
		}
		self.window.rootViewController = UINavigationController(rootViewController: FLOnBoardViewController())
		self.window.makeKeyAndVisible()
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		coreDataStack.saveContext()
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
	}
}

