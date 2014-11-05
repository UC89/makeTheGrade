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
    @NSManaged var gradeOverrideBool: Bool
    @NSManaged var courseID: NSNumber
    
    @NSManaged var belongsTo: Semester
    @NSManaged var gradeList: NSSet
    
    
    
    class func addCourse(moc: NSManagedObjectContext, title:String,courseCredits:Float,courseExamsPerc:Float,courseQuizesPerc:Float,courseHwPerc:Float,courseOtherPerc:Float,isScienceCourse:Bool, isCoursePoints:Bool, gradeOverride:Float,semesterIDIn:Int) -> Course
    {
        let belongsToSemester = NSFetchRequest(entityName: "Semester")
        belongsToSemester.returnsObjectsAsFaults = false
        belongsToSemester.predicate = NSPredicate(format:"semesterID = %@","\(semesterIDIn)")
        
        var semester:NSArray = moc.executeFetchRequest(belongsToSemester, error: nil)!
        var semesterSelected = semester[0] as Semester
        
        var newCourseID:Int = semesterSelected.belongsTo.returnNumberOfCourses()
        
        
        let newCourse = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: moc) as Course
        newCourse.courseTitle = title
        newCourse.credits = courseCredits
        newCourse.examsPerc = courseExamsPerc
        newCourse.homeworkPerc = courseHwPerc
        newCourse.quizesPerc = courseQuizesPerc
        newCourse.otherPerc = courseOtherPerc
        newCourse.pointsOrPercentage = isCoursePoints
        newCourse.scienceCourse = isScienceCourse
        newCourse.belongsTo = semesterSelected
        newCourse.courseID = newCourseID
        
        
        println("NEWCOURSEID----------------\(newCourseID)")
        if (gradeOverride>0 )
        {
            newCourse.gradeOverrideBool = true
            newCourse.gradeOverride = gradeOverride
        }
        else
        {
            newCourse.gradeOverrideBool = false
        }
        
        println("New course Created for \(semesterIDIn)  belonging to \(newCourse.belongsTo)")
        //println("Number of courses created: \(userSelected.returnNumberOfCourses())")
        return newCourse
    }
    

    // change [Int] to [Grade]
   // func getGradeList() -> [Int]
   // {
        //return [Grade(entity: NSEntityDescription, insertIntoManagedObjectContext: //)]
    //    return [10]
    //}
  /*
    func getCourseAverage() -> Float
    {
        return 100.0
    }
    
    func letterGrade() -> String
    {
        var points = getCourseAverage()
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
*/
        
}
