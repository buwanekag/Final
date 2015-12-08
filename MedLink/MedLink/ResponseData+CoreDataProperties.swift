//
//  ResponseData+CoreDataProperties.swift
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

extension ResponseData {

    @NSManaged var respondedAt: NSDate?
    @NSManaged var responseID: String?
    @NSManaged var responseType: String?
    @NSManaged var toRequestsData: RequestsData?

}
