//
//  User.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/28/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import CoreData

@objc(User)

class User: NSManagedObject {

    @NSManaged var countryCode: String
    @NSManaged var deviceId: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String
    @NSManaged var userID: String
    @NSManaged var userToken: String
	@NSManaged var avatarURL: String
	@NSManaged var name: String
	@NSManaged var phoneNumberVerified: NSNumber
	
	//MARK: getCurrentUser
	
	class func getSessionUser() -> User? {
		var error: NSError?
		if let fetchRequest = FlaresAppDelegate.coreDataStack.model.fetchRequestTemplateForName("UserFetchRequest") {
			let results = FlaresAppDelegate.coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as [User]
			if let user = results.first {
				return user
			}
		}
		return nil
	}
}
