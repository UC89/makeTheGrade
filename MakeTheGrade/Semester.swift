//
//  Semester.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Semester: NSManagedObject {

    @NSManaged var season: String
    @NSManaged var year: NSNumber
    @NSManaged var belongsTo: Student
    @NSManaged var courseList: NSSet
    
    
    class func addSemester(moc: NSManagedObjectContext,season: String, year: Int) -> Semester
    {
        let belongsToUser = NSFetchRequest(entityName: "Student")
        belongsToUser.returnsObjectsAsFaults = false
        belongsToUser.predicate = NSPredicate(format: "studentName = %@","User")
        var user:NSArray = moc.executeFetchRequest(belongsToUser, error: nil)!
        var userSelected = user[0] as Student
        let newSemester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: moc) as Semester
        newSemester.season = season
        newSemester.year = year
        newSemester.belongsTo = userSelected
        println("New Season Created for \(season) in \(year) belonging to \(newSemester.belongsTo)")
        println("\(newSemester.belongsTo.description)")
        println("Number of semesters created: \(userSelected.returnNumberOfSemesters())")
        return newSemester
    }
    /*
    class func addUser(moc: NSManagedObjectContext,username: String, password: String) -> User
    {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as User
        newUser.userName = username
        newUser.password = password
        println("Object Saved")
        return newUser
    }
    
    class func loadUser(moc: NSManagedObjectContext, userToLoad: String) -> String
    {
        
        var returnString: String = ""
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format:"userName = %@", userToLoad)
        var result: NSArray = moc.executeFetchRequest(request, error: nil)!
        
        if (result.count>0)
        {
            var resName = result[0].valueForKey("userName") as String
            var resPassword = result[0].valueForKey("password") as String
            returnString = "Username: \(resName)  Password: \(resPassword)"
            println("Object Loaded")
        }
        else
        {
            returnString = "Error"
        }
        
        return returnString
    }
*/
    
}
