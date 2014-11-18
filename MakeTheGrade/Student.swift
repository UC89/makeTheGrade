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
    @NSManaged var goalGPA: NSNumber
    @NSManaged var semesterList: NSSet
    

    
    
    func returnNumberOfSemesters() -> Int
    {
        return semesterList.count
    }
    func returnNumberOfCourses() -> Int
    {
        var returnInt: Int = 0
        for semester in semesterList
        {
            var semesterObj = semester as Semester
            returnInt += semesterObj.courseList.count
        }
        return returnInt
    }
    
    
    class func returnSemesterList(moc: NSManagedObjectContext) -> NSSet
    {
        let returnArray = [Semester]()
        let belongsToUser = NSFetchRequest(entityName: "Student")
        belongsToUser.returnsObjectsAsFaults = false
        belongsToUser.predicate = NSPredicate(format: "studentName = %@","User")
        
        var user:NSArray = moc.executeFetchRequest(belongsToUser, error: nil)!
        
        var userSelected = user[0] as Student
        
        var listOfSemesters = userSelected.semesterList
        
        return listOfSemesters
    }
    
    class func returnAllCourses(moc: NSManagedObjectContext) -> [Course]
    {
        var returnSet:[Course] = []
        
        let belongsToUser = NSFetchRequest(entityName: "Student")
        belongsToUser.returnsObjectsAsFaults = false
        belongsToUser.predicate = NSPredicate(format: "studentName = %@","User")
        
        var user:NSArray = moc.executeFetchRequest(belongsToUser, error: nil)!
        if (user.count>0)
        {
            var userSelected = user[0] as Student
            for semester in userSelected.semesterList
            {
                var semesterAsSemester = semester as Semester
                
                for course in semesterAsSemester.courseList
                {
                    returnSet.append(course as Course)
                }
            }
            return returnSet
        }
        else
        {
            return []
        }
    }
    
    func returnNumberOfGrades() -> Int
    {
        println("\n In returnNumberOfGrades in student model file")
        var numberOfGrades = 0
        println("Set number of grades init value")
        for semester in self.semesterList
        {
            println("In for semester in semesterList")
            var semesterObject = semester as Semester
            for course in semesterObject.courseList
            {
                println("In for course in semesterObject")
                var courseObject = course as Course
                for grade in courseObject.gradeList
                {
                    println("In for grade in courseO ject.gradeList")
                    numberOfGrades += 1
                }
            }
        }
        println("Going to return Number of Grades\n")
        return numberOfGrades
    }
    
    func returnGPA() -> Float
    {
        println("\n In ReturnGPA Function\n")
        
        var totalGrades = Float()
        var totalCredits = Float()
        var gradePoints = Float()
        
        
        for semester in self.semesterList
        {
            var semesterAsSemester = semester as Semester
            for course in semesterAsSemester.courseList
            {
                var currentGrade = Float(0.0)
                var courseObject = course as Course
                if (courseObject.pointsOrPercentage == true)
                {
                    currentGrade = courseObject.calcCurrentGradeForPoints()
                }
                else if (courseObject.pointsOrPercentage == false)
                {
                    currentGrade = courseObject.calcCurrentGradeForPercentage()
                }
                totalGrades += currentGrade
                totalCredits += courseObject.credits
                if (currentGrade > 93)
                {
                    gradePoints += (4.0 * courseObject.credits)
                }
                else if (currentGrade > 90)
                {
                    gradePoints += (3.7 * courseObject.credits)
                }
                else if (currentGrade > 87)
                {
                    gradePoints += (3.4 * courseObject.credits)
                }
                else if (currentGrade > 83)
                {
                    gradePoints += (3.0 *  courseObject.credits)
                }
                else if (currentGrade > 80)
                {
                    gradePoints += (2.7 * courseObject.credits)
                }
                else if (currentGrade > 77)
                {
                    gradePoints += (2.3 * courseObject.credits)
                }
                else if (currentGrade > 73)
                {
                    gradePoints += (2.0 * courseObject.credits)
                }
                else if (currentGrade > 70)
                {
                    gradePoints += (1.7 * courseObject.credits)
                }
                else if (currentGrade > 67)
                {
                    gradePoints += (1.3 * courseObject.credits)
                }
                else if (currentGrade > 63)
                {
                    gradePoints += (1.0 * courseObject.credits)
                }
                else
                {
                    gradePoints += 0.0
                }
            }
        }
        println("\n----------------------------------------------------")
        println("Calculating GPA with \(gradePoints) grade points")
        println("Credits: \(totalCredits) for \(totalGrades) classes")
        println("GPA is \(gradePoints/totalCredits)")
        println("Returning GPA\n")
        return (gradePoints/totalCredits)
    }

}
