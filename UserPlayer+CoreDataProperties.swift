//
//  UserPlayer+CoreDataProperties.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//
//

import Foundation
import CoreData


extension UserPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPlayer> {
        return NSFetchRequest<UserPlayer>(entityName: "UserPlayer")
    }

    @NSManaged public var name: String?
    @NSManaged public var points: Int32

}

extension UserPlayer : Identifiable {

}
