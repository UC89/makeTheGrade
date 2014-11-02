//
//  Student.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Student: NSManagedObject {

    @NSManaged var studentName: String
    @NSManaged var totalSciCredits: NSNumber
    @NSManaged var totalNonSciCredits: NSNumber
    @NSManaged var totalCredits: NSNumber
    @NSManaged var sciGpa: NSNumber
    @NSManaged var overallGpa: NSNumber
    @NSManaged var nonSciGpa: NSNumber
    @NSManaged var semesterList: NSSet
    
    var userCreated: Bool = false
}
