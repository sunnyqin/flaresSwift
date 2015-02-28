//
//  FLOnBoardViewController.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/27/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit

class FLOnBoardViewController: UIViewController {

	var tutorial: FLTutorial?
	
	convenience override init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.navigationBarHidden = true
		
		showTutorial()
	}
	
	func showTutorial() -> Void {
		tutorial = FLTutorial(frame: UIScreen.mainScreen().bounds)
		tutorial!.delegate = self
		self.view.addSubview(tutorial!)
		
		tutorial!.showLastPage()
	}
}

extension FLOnBoardViewController: FLTutorialDeleage {
	func BeginToSignIn() -> Void {
		tutorial!.isTimering = false
		
		let viewController = FLSignInViewController()
		let navController = UINavigationController(rootViewController: viewController)
		presentViewController(navController, animated: true) {
			
		}
	}
	
	func BeginToSignUp() -> Void {
		tutorial!.isTimering = false
		
		let viewController = FLSignUpViewController()
		let navController = UINavigationController(rootViewController: viewController)
		presentViewController(navController, animated: true, completion: {})
	}
}
