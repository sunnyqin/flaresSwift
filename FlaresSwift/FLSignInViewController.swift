//
//  FLSignInViewController.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/27/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit

let SelectCountryString = "select a country"

class FLSignInViewController: UIViewController {
	
	var countryLabel: UILabel!
	var countryCodeTextField: UITextField!
	var phoneNumberTextField: UITextField!
	var passcodeTextField: UITextField!
	var signButton: UIButton!
	
	convenience override init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBarHidden = true
		
		let background = UIImageView(frame: self.view.bounds)
		background.image = UIImage(named: "bg_blur")
		self.view.addSubview(background)
		
		let titleLabel = UILabel(frame: CGRectMake(50, 0, self.view.bounds.size.width - 50 * 2, 56))
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.backgroundColor = UIColor.clearColor()
		titleLabel.font = UIFont.systemFontOfSize(20.0)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.text = "Log-in"
		self.view.addSubview(titleLabel)
		
		let backButton = UIButton()
		backButton.frame = CGRectMake(0, 0, 60, 60)
		backButton.setImage(UIImage(named: "btn_back"), forState: UIControlState.Normal)
		backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(backButton)
		
		countryLabel = UILabel()
		countryLabel.font = UIFont.systemFontOfSize(18.0)
		countryLabel.textColor = UIColor.whiteColor()
		countryLabel.backgroundColor = UIColor.clearColor()
		countryLabel.numberOfLines = 1
		countryLabel.textAlignment = NSTextAlignment.Left
		countryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
		countryLabel.text = SelectCountryString
		
		countryCodeTextField = UITextField()
		countryCodeTextField.placeholder = ""
		countryCodeTextField.text = "86"
		countryCodeTextField.textColor = UIColor.whiteColor()
		countryCodeTextField.keyboardType = UIKeyboardType.NumberPad
		countryCodeTextField.returnKeyType = UIReturnKeyType.Next
		countryCodeTextField.autocorrectionType = UITextAutocorrectionType.No
		
		phoneNumberTextField = UITextField()
		phoneNumberTextField.textColor = UIColor.whiteColor()
		phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
		phoneNumberTextField.text = "13862076873"
		phoneNumberTextField.returnKeyType = UIReturnKeyType.Next
		phoneNumberTextField.autocorrectionType = UITextAutocorrectionType.No
		
		passcodeTextField = UITextField()
		passcodeTextField.textColor = UIColor.whiteColor()
		passcodeTextField.keyboardType = UIKeyboardType.NumberPad
		passcodeTextField.text = "1111"
		passcodeTextField.returnKeyType = UIReturnKeyType.Next
		passcodeTextField.autocorrectionType = UITextAutocorrectionType.No
		passcodeTextField.secureTextEntry = true
		
		signButton = UIButton()
		signButton.setBackgroundImage(UIImage(named: "btn_active_up"), forState: UIControlState.Normal)
		signButton.setTitle("log-in", forState: UIControlState.Normal)
		signButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		signButton.titleLabel?.font = UIFont.systemFontOfSize(18.0)
		signButton.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
		
		let lineHeight = 1.0
		let line1 = UIView()
		line1.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
		let line2 = UIView()
		line2.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
		let line3 = UIView()
		line3.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
		let line4 = UIView()
		line4.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
		
		self.view.addSubview(countryLabel)
		self.view.addSubview(countryCodeTextField)
		self.view.addSubview(phoneNumberTextField)
		self.view.addSubview(passcodeTextField)
		self.view.addSubview(signButton)
		self.view.addSubview(line1)
		self.view.addSubview(line2)
		self.view.addSubview(line3)
		self.view.addSubview(line4)
		
		countryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		countryCodeTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
		phoneNumberTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
		passcodeTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
		signButton.setTranslatesAutoresizingMaskIntoConstraints(false)
		line1.setTranslatesAutoresizingMaskIntoConstraints(false)
		line2.setTranslatesAutoresizingMaskIntoConstraints(false)
		line3.setTranslatesAutoresizingMaskIntoConstraints(false)
		line4.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		let viewDictionary: NSDictionary = ["countryLabel": countryLabel, "countryCodeTextField": countryCodeTextField, "phoneNumberTextField": phoneNumberTextField, "passcodeTextField": passcodeTextField, "line1": line1, "line2": line2, "line3": line3, "line4": line4, "signButton": signButton]
		var height = 25
		if (self.view.bounds.size.height > 480) {
			height = 35
		}
		let constraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:[countryLabel(>=260)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let constraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:[countryLabel(\(height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		countryLabel.addConstraints(constraintH)
		countryLabel.addConstraints(constraintV)
		
		let constraintH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[phoneNumberTextField(>=180)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let constraintV2 = NSLayoutConstraint.constraintsWithVisualFormat("V:[phoneNumberTextField(\(height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		phoneNumberTextField.addConstraints(constraintH2)
		phoneNumberTextField.addConstraints(constraintV2)
		
		let constraintH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:[passcodeTextField(>=260)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let constraintV3 = NSLayoutConstraint.constraintsWithVisualFormat("V:[passcodeTextField(\(height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		passcodeTextField.addConstraints(constraintH3)
		passcodeTextField.addConstraints(constraintV3)
		
		let constraintH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:[countryCodeTextField(60)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let constraintV4 = NSLayoutConstraint.constraintsWithVisualFormat("V:[countryCodeTextField(\(height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		countryCodeTextField.addConstraints(constraintH4)
		countryCodeTextField.addConstraints(constraintV4)
		
		let constraintH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:[signButton(>=260)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let constraintV5 = NSLayoutConstraint.constraintsWithVisualFormat("V:[signButton(>=35)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		signButton.addConstraints(constraintH5)
		signButton.addConstraints(constraintV5)
		
		let line1H = NSLayoutConstraint.constraintsWithVisualFormat("H:[line1(>=260)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let line1V = NSLayoutConstraint.constraintsWithVisualFormat("V:[line1(1)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		line1.addConstraints(line1H)
		line1.addConstraints(line1V)
		
		let line2H = NSLayoutConstraint.constraintsWithVisualFormat("H:[line2(60)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let line2V = NSLayoutConstraint.constraintsWithVisualFormat("V:[line2(1)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		line2.addConstraints(line2H)
		line2.addConstraints(line2V)
		
		let line3H = NSLayoutConstraint.constraintsWithVisualFormat("H:[line3(>=180)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let line3V = NSLayoutConstraint.constraintsWithVisualFormat("V:[line3(1)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		line3.addConstraints(line3H)
		line3.addConstraints(line3V)
		
		let line4H = NSLayoutConstraint.constraintsWithVisualFormat("H:[line4(>=260)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let line4V = NSLayoutConstraint.constraintsWithVisualFormat("V:[line4(1)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		line4.addConstraints(line4H)
		line4.addConstraints(line4V)
		
		let keyboardHeight = 216.0
		var orginy = 60
		if (self.view.frame.size.height > 480) {
			orginy = 100
		}
		let viewH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[countryLabel]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[line1]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[line2]-15-[line3]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[line4]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[signButton]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewH6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[countryCodeTextField]-15-[phoneNumberTextField]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
		let viewV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(orginy)-[countryLabel]-[line1(1)]-[countryCodeTextField]-[line2(1)]-[passcodeTextField]-[line4(1)]-20-[signButton]", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewDictionary)
		let viewV2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(orginy)-[countryLabel]-[line1(1)]-[phoneNumberTextField]-[line3(1)]-[passcodeTextField]-[line4(1)]-20-[signButton]", options: NSLayoutFormatOptions.AlignAllTrailing, metrics: nil, views: viewDictionary)
		self.view.addConstraints(viewH1)
		self.view.addConstraints(viewH2)
		self.view.addConstraints(viewH3)
		self.view.addConstraints(viewH4)
		self.view.addConstraints(viewH5)
		self.view.addConstraints(viewH6)
		self.view.addConstraints(viewV1)
		self.view.addConstraints(viewV2)
	}
	
	func back() -> Void {
		self.dismissViewControllerAnimated(false, completion: {})
	}
	
	func login() -> Void {
		
		let phonenumber = phoneNumberTextField.text
		let passcode = passcodeTextField.text
		let countrycode = countryCodeTextField.text
		
		var user = User()
		user.phoneNumber = phonenumber
		user.countryCode = countrycode
		
		FlaresLogin.login(user, passcode: passcode) {
			switch ($0) {
				case .Error(let message):
					let alert = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
					alert.show()
					break
				case .Results(let results):
					let alert = UIAlertView(title: "login success", message: nil, delegate: self, cancelButtonTitle: "OK")
					alert.show()
					break
			}
		}
	}
}

extension FLSignInViewController: UIAlertViewDelegate {
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if buttonIndex == 0 {
			var appDelegate = UIApplication.sharedApplication().delegate
			var window = appDelegate?.window
			let homeViewController = UINavigationController(rootViewController: FLHomeViewController())
			
			window??.rootViewController = homeViewController
		}
	}
}