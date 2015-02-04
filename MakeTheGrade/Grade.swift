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

    @NSManaged var assignmentName: NSString
    @NSManaged var pointsEarned: NSNumber
    @NSManaged var pointsPossible: NSNumber
    @NSManaged var percentage: NSNumber
    @NSManaged var gradeType: String
    @NSManaged var belongsTo: Course
    
    
    class func addGrade(moc: NSManagedObjectContext, titleIn: String, pointsEarnedIn: Float, pointsPossibleIn: Float, percentageIn: Float,  courseIDIn:Int,gradeTypeIn:String) -> Grade
    {
        let belongsToCourse = NSFetchRequest(entityName: "Course")
        belongsToCourse.returnsObjectsAsFaults = false
        belongsToCourse.predicate = NSPredicate(format:"courseID = %@","\(courseIDIn)")
        
        var course:NSArray = moc.executeFetchRequest(belongsToCourse, error: nil)!
        var courseSelected = course[0] as Course
        
        if (courseSelected.pointsOrPercentage == true && percentageIn == 0.0)
        {
            // Add UIAlert view here to ask user if they are sure they do not want to add the percentage of this grade to the category.
            println("You didn't enter a category Percentage!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        println("\n\n------***------------Course Selected is \(courseSelected.courseTitle)---------***-----------------")
        
        println("Can Add Grade Function: \(courseSelected.canAddGrade(gradeTypeIn,gradePercentageIn: percentageIn))")
        
        let newGrade = NSEntityDescription.insertNewObjectForEntityForName("Grade", inManagedObjectContext: moc) as Grade
        println("Established grade object")
        newGrade.assignmentName = titleIn
        newGrade.pointsEarned = pointsEarnedIn
        newGrade.pointsPossible = pointsPossibleIn
        newGrade.percentage = percentageIn
        newGrade.gradeType = gradeTypeIn
        println("About to set relationship for grade")
        newGrade.belongsTo = courseSelected as Course
        
        println("Adding a new grade belonging to \(courseSelected.courseTitle)")
        return newGrade
    }
    
    func returnPercentageTowardsCat() -> Float
    {
        var returnFloat = Float()
        
        returnFloat = (self.pointsEarned/self.pointsPossible)*(self.percentage/100)
        println("Returning grade of \(returnFloat) for assignment \(assignmentName) for course\(self.belongsTo.courseTitle)")
        return returnFloat
    }
}
