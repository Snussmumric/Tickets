//
//  FavoriteTicket+CoreDataProperties.swift
//  Tickets
//
//  Created by Антон Васильченко on 27.01.2021.
//
//

import Foundation
import CoreData


extension FavoriteTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTicket> {
        return NSFetchRequest<FavoriteTicket>(entityName: "FavoriteTicket")
    }

    @NSManaged public var created: Date?
    @NSManaged public var departure: Date?
    @NSManaged public var expires: Date?
    @NSManaged public var returnDate: Date?
    @NSManaged public var airline: String?
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var price: Int64
    @NSManaged public var flightNumber: Int16

}

extension FavoriteTicket : Identifiable {

}
