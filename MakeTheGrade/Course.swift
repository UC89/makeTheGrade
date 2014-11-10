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
    @NSManaged var isCourseFinished: Bool
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
        
        
        println("\n NEWCOURSEID----------------\(newCourseID) \n")
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
    
    func calcCurrentGrade() -> Float
    {
        var totalPointsEarned = Float()
        var pointsTotalPos = Float()
        
        for grade in self.gradeList
        {
            var gradeObject = grade as Grade
            totalPointsEarned += gradeObject.pointsEarned
            pointsTotalPos += gradeObject.pointsPossible
        }
        println("Current grade \((totalPointsEarned)/pointsTotalPos)*100)")
        return (totalPointsEarned/pointsTotalPos)*100
    }
    
    func returnLetterGrade() -> String
    {
        var currentGrade = self.calcCurrentGrade()
        if (currentGrade > 93)
        {
            return "A"
        }
        else if (currentGrade > 90)
        {
            return "A-"
        }
        else
        {
            return "I DUNNO"
        }
    }
        
}
