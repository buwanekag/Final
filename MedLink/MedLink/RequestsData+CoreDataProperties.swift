//
//  RequestsData+CoreDataProperties.swift
//  MedLink
//
//  Created by Buwaneka Galpoththawela on 12/8/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RequestsData {

    @NSManaged var createdDate: NSDate?
    @NSManaged var requestSupplyID: String?
    @NSManaged var requestSupplyName: String?
    @NSManaged var toResponseData: NSSet?

}