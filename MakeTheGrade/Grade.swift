//
//  Grade.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Grade: NSManagedObject {

    @NSManaged var pointsEarned: NSNumber
    @NSManaged var pointsPossible: NSNumber
    @NSManaged var percentage: NSNumber
    @NSManaged var relationship: Course

}
