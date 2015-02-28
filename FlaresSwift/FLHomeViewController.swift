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

class FLHomeViewController: UIViewController {
	
	var loginUser: User!
	
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
	}
	
	func logout() -> Void {
		
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		if loginUser != nil {
			appDelegate.coreDataStack.context.deleteObject(loginUser)
			appDelegate.coreDataStack.saveContext()
		}
		
		var window = appDelegate.window
		let rootViewController = FLOnBoardViewController()
		window.rootViewController = rootViewController
	}
}