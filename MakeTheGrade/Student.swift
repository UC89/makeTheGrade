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
    
    func returnNumberOfSemesters() -> Int
    {
        return semesterList.count
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

}
