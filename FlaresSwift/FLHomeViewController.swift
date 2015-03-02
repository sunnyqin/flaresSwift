//
//  FLHomeViewController.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/28/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let FlaresAppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
let FlaresAppWindow = FlaresAppDelegate.window

class FLHomeViewController: UIViewController {
	
	var loginUser: User!
	var count = 0
	var timer: NSTimer?
		
	convenience override init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		self.navigationController?.navigationBarHidden = true
		
		let background = UIImageView(frame: self.view.bounds)
		background.image = UIImage(named: "bg_blur")
		self.view.addSubview(background)
		
		let titleLabel = UILabel(frame: CGRectMake(50, 0, self.view.bounds.size.width - 50 * 2, 56))
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.backgroundColor = UIColor.clearColor()
		titleLabel.font = UIFont.systemFontOfSize(20.0)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.text = "Flares"
		self.view.addSubview(titleLabel)
		
		let backButton = UIButton()
		backButton.frame = CGRectMake(0, 0, 60, 60)
		backButton.setImage(UIImage(named: "btn_back"), forState: UIControlState.Normal)
		backButton.addTarget(self, action: "logout", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(backButton)
		
//		let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//			Int64(5 * Double(NSEC_PER_SEC)))
//		dispatch_after(delayTime, dispatch_get_main_queue()) {
//			[unowned self] in
//			
//			var url = baseURL + "/users/3afc86cb-92e1-489a-8f8f-e0d0665cb2d9"
//			let request = NSURLRequest(URL: NSURL(string: url)!)
//			NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
//				response, data, error in
//				
//			})
//		}
		
//		dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
//
//		}
		
		dispatch_async(dispatch_get_main_queue()) {
			[unowned self] in
			let userInfo = "name: \(self.loginUser.name) \nphonenumber: \(self.loginUser.phoneNumber) \ncountryCode: \(self.loginUser.countryCode) \nemail: \(self.loginUser.email) \nphoneNumberVerified: \(self.loginUser.phoneNumberVerified) \nuser_id: \(self.loginUser.userID) \nuser_token: \(self.loginUser.userToken)"
			let alert = UIAlertView(title: userInfo, message: nil, delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		
		timer = NSTimer.scheduledTimerWithTimeInterval(5.0,
			target: self,
			selector: Selector("timerFireMethod:"),  // line 1
			userInfo: nil,
			repeats: false)
		
		let mainLoop = NSRunLoop.mainRunLoop()
		mainLoop.addTimer(timer!, forMode: NSDefaultRunLoopMode)
	}
	
	func timerFireMethod(timer: NSTimer) {
		self.timer!.invalidate()
		self.timer = nil
		
		self.refreashUserInfo()
	}
	
	func refreashUserInfo() -> Void {
		FLUser.findUser(self.loginUser.userID, token: self.loginUser.userToken, completion: {
			result in
			switch (result) {
			case .Error(let message):
				break
			case .Results(let user):
				if let user = User.getSessionUser() {
					self.loginUser = user
					let userInfo = "name: \(self.loginUser.name) \nphonenumber: \(self.loginUser.phoneNumber) \ncountryCode: \(self.loginUser.countryCode) \nemail: \(self.loginUser.email) \nphoneNumberVerified: \(self.loginUser.phoneNumberVerified) \nuser_id: \(self.loginUser.userID) \nuser_token: \(self.loginUser.userToken)"
					println("\(userInfo)")
				}
				break
			}
		})
	}
	
	func logout() -> Void {
		
		if loginUser != nil {
			FlaresAppDelegate.coreDataStack.context.deleteObject(loginUser)
			FlaresAppDelegate.coreDataStack.saveContext()
		}
		
		self.timer?.invalidate()
		self.timer = nil
		
		let rootViewController = FLOnBoardViewController()
		FlaresAppWindow.rootViewController = rootViewController
	}
}