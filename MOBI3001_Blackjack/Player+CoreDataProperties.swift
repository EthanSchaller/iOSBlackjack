//
//  Player+CoreDataProperties.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var points: Int32

}

extension Player : Identifiable {

}
