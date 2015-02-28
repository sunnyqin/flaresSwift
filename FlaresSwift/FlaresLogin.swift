//
//  FlaresLogin.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/28/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import Alamofire

let loginURL = "http://nox.flareworks.co:9090/users/login"

class FlaresLogin {
	
	typealias LoginCompletion = (result: LoginResult) -> Void
	typealias ErrorDescription = String
	
	enum LoginResult {
		case Results(User)
		case Error(ErrorDescription)
	}
	
	class func login(user: User, passcode: String?, completion: LoginCompletion) {
		
		var params = Dictionary<String, String>()
		if let phonenumber = user.phoneNumber {
			params["phone_number"] = phonenumber
		}
		if let password = passcode {
			params["password"] = password
		}
		if let countrycode = user.countryCode {
			params["country_code"] = countrycode
		}
		
		Alamofire.request(.GET, loginURL, parameters: params).responseJSON() {
			(_, _, jsonObject, error) in
			
			if error != nil {
				println("Flares error: \(error)")
				completion(result: .Error("login failed"))
				return
			}
			
			let json = JSON(jsonObject!)
			println(jsonObject)
			if json == nil {
				println("Flares JSON error: \(error)")
				completion(result: .Error("parse json failed"))
				return
			}
			
			if json["error"] != nil {
				let message = json["error"]["message"]
				completion(result: .Error("\(message)"))
			}
			else{
				var user = User.createUserFromJSON(json)
				completion(result: .Results(user))
			}
		}
	}
	
}
