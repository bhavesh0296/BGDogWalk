//
//  Walk+CoreDataProperties.swift
//  BGDogWalk
//
//  Created by bhavesh on 17/06/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dog: Dog?

}
