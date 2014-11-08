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
    
    class func addGrade(moc: NSManagedObjectContext, pointsEarnedIn: Float, pointsPossibleIn: Float, percentageIn: Float, courseIDIn:Int,gradeType:String) -> Grade
    {
        let belongsToCourse = NSFetchRequest(entityName: "Course")
        belongsToCourse.returnsObjectsAsFaults = false
        belongsToCourse.predicate = NSPredicate(format:"courseID = %@","\(courseIDIn)")
        
        var course:NSArray = moc.executeFetchRequest(belongsToCourse, error: nil)!
        var courseSelected = course[0] as Course
        
        let newGrade = NSEntityDescription.insertNewObjectForEntityForName("Grade", inManagedObjectContext: moc) as Grade
        newGrade.pointsEarned = pointsEarnedIn
        newGrade.pointsPossible = pointsPossibleIn
        newGrade.percentage = percentageIn
        newGrade.relationship = courseSelected 
        
        return newGrade
        
        
    }
}
