//
//  User.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/28/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

let baseURL = "http://nox.flareworks.co:9090"
let loginURL = "http://nox.flareworks.co:9090/users/login"

class FLUser {
	
	var userID: String?
	var userToken: String?
	var countryCode: String?
	var phoneNumber: String?
	var deviceId: String?
	var phoneNumberVerified: Int?
	var email: String?
	var avatarURL: String?
	var name: String?
	
	init() {
		
	}
	
	init(user: User) {
		self.userID = user.userID
		self.userToken = user.userToken
		self.countryCode = user.countryCode
		self.phoneNumber = user.phoneNumber
		self.deviceId = user.deviceId
		self.phoneNumberVerified = Int(user.phoneNumberVerified)
		self.email = user.email
		self.avatarURL = user.avatarURL
		self.name = user.name
	}
	
//	class var sessionUser : FLUser {
//		struct Static {
//			static var onceToken : dispatch_once_t = 0
//			static var instance : FLUser? = nil
//		}
//		dispatch_once(&Static.onceToken) {
//			Static.instance = FLUser()
//		}
//		return Static.instance!
//	}
	
	class func createUserFromJSON(json: JSON) -> FLUser {
		var user = FLUser()
		
		if let userid = json["user_id"].string {
			user.userID = userid
		}
		if let token = json["token"].string {
			user.userToken = token
		}
		if let phone = json["phone_number"].string {
			user.phoneNumber = phone
		}
		if let countryCode = json["country_code"].string {
			user.countryCode = countryCode
		}
		if let deviceId = json["device_id"].string {
			user.deviceId = deviceId
		}
		if let email = json["email_address"].string {
			user.email = email
		}
		if let phoneNumberVerified = json["phone_number_verified"].int {
			user.phoneNumberVerified = phoneNumberVerified
		}
		if let avatarURL = json["avatar"].string {
			user.avatarURL = avatarURL
		}
		if let name = json["name"].string {
			user.name = name
		}
		return user
	}
	
	func createOrUpdateSessionUser() -> Void {
		if let user = User.getSessionUser() {
			FlaresAppDelegate.coreDataStack.context.deleteObject(user)
		}
			
		let user: User =
		NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: FlaresAppDelegate.coreDataStack.context) as User
		if let userID = self.userID {
			user.userID = userID
		}
		if let userToken = self.userToken {
			user.userToken = userToken
		}
		if let phoneNumber = self.phoneNumber {
			user.phoneNumber = phoneNumber
		}
		if let countryCode = self.countryCode {
			user.countryCode = countryCode
		}
		if let deviceId = self.deviceId {
			user.deviceId = deviceId
		}
		if let email = self.email {
			user.email = email
		}
		if let avatarURL = self.avatarURL {
			user.avatarURL = avatarURL
		}
		if let name = self.name {
			user.name = name
		}
		if let phoneNumberVerified = self.phoneNumberVerified {
			user.phoneNumberVerified = phoneNumberVerified
		}
		FlaresAppDelegate.coreDataStack.saveContext()
	}
}

extension FLUser {
	
	typealias LoginCompletion = (result: UserResult) -> Void
	typealias ErrorDescription = String
	
	enum UserResult {
		case Results(FLUser)
		case Error(ErrorDescription)
	}
	
	class func login(user: FLUser, passcode: String?, completion: LoginCompletion) {
		
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
				var user = FLUser.createUserFromJSON(json)
				user.createOrUpdateSessionUser()
				
				if user.userID != nil && user.userToken != nil {
					FLUser.findUser(user.userID!, token: user.userToken!, completion: {
						result in
						switch (result) {
						case .Error(let message):
							completion(result: .Error("\(message)"))
							break
						case .Results(let user):
							completion(result: .Results(user))
							break
						}
					})
				}
			}
		}
	}
}

extension FLUser {
	
	typealias DeviceData = Dictionary<String, String>
	
	class func findUser(userID: String, token: String, completion: LoginCompletion) -> Void {
		var url = baseURL + "/users/\(userID)"
		
		var params = Dictionary<String, String>()
		params["user_id"] = userID
		params["token"] = token
		
		Alamofire.request(.GET, url, parameters: params).responseJSON() {
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
				var user = FLUser.createUserFromJSON(json)
				user.userID = userID
				user.userToken = token
				completion(result: .Results(user))
				
				user.createOrUpdateSessionUser()
			}
		}
	}
}
