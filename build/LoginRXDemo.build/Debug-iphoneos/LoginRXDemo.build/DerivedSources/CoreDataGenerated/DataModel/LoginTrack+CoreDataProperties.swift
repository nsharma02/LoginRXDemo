//
//  LoginTrack+CoreDataProperties.swift
//  
//
//  Created by admin on 30/10/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension LoginTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginTrack> {
        return NSFetchRequest<LoginTrack>(entityName: "LoginTrack")
    }

    @NSManaged public var loginDate: Date?
    @NSManaged public var username: String?

}
