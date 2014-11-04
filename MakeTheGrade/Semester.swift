//
//  Semester.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Semester: NSManagedObject
{

    @NSManaged var season: String
    @NSManaged var year: NSNumber
    @NSManaged var semesterID: NSNumber
    @NSManaged var belongsTo: Student
    @NSManaged var courseList: NSSet
    
    
    class func addSemester(moc: NSManagedObjectContext,season: String, year: Int, semesterID:Int) -> Semester
    {
        let belongsToUser = NSFetchRequest(entityName: "Student")
        belongsToUser.returnsObjectsAsFaults = false
        belongsToUser.predicate = NSPredicate(format: "studentName = %@","User")
        
        var user:NSArray = moc.executeFetchRequest(belongsToUser, error: nil)!
        
        var userSelected = user[0] as Student
        
        let newSemester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: moc) as Semester
        
        newSemester.season = season
        newSemester.year = year
        newSemester.semesterID = userSelected.returnNumberOfSemesters()
        newSemester.belongsTo = userSelected
        
        println("New Season Created for \(season) in \(year) belonging to \(newSemester.belongsTo)")
        println("\(newSemester.belongsTo.description)")
        println("Number of semesters created: \(userSelected.returnNumberOfSemesters())")
        
        return newSemester
    }
    
}
