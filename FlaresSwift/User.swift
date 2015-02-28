//
//  User.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/28/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation

class User {
	
	var userID: String?
	var userToken: String?
	var countryCode: String?
	var phoneNumber: String?
	var deviceId: String?
	var phoneNumberVerified: Int?
	var email: String?
	
	init() {

	}
	
	class func createUserFromJSON(json: JSON) -> User {
		var user = User()
		
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
		if let email = json["email"].string {
			user.email = email
		}
		if let phoneNumberVerified = json["phone_number_verified"].int {
			user.phoneNumberVerified = phoneNumberVerified
		}
		return user
	}
}
