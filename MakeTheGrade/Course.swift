//
//  Course.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var courseTitle: String
    @NSManaged var credits: NSNumber
    @NSManaged var examsPerc: NSNumber
    @NSManaged var gradeOverride: NSNumber
    @NSManaged var homeworkPerc: NSNumber
    @NSManaged var otherPerc: NSNumber
    @NSManaged var pointsOrPercentage: NSNumber
    @NSManaged var quizesPerc: NSNumber
    @NSManaged var scienceCourse: NSNumber
    @NSManaged var semesterSeason: String
    @NSManaged var belongsTo: Semester
    @NSManaged var gradeList: NSSet

    // change [Int] to [Grade]
    func getGradeList() -> [Int]
    {
        //return [Grade(entity: NSEntityDescription, insertIntoManagedObjectContext: <#NSManagedObjectContext!#>)]
        return [10]
    }
    
    func getCourseAverage() -> Float
    {
        return 100.0
    }
    
    func letterGrade() -> String
    {
        var points = self.getCourseAverage()
        var returnLetter = "Invalid"
        if (points > 93)
        {
            returnLetter = "A"
        }
        else if (points >= 90)
        {
            returnLetter = "A-"
        }
        else if (points >= 87)
        {
            returnLetter = "B+"
        }
        else if (points >= 83)
        {
            returnLetter = "B"
        }
        
        return returnLetter
        
    }
}
