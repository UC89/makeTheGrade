//
//  MainPageViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/22/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//
// This page will display all of the courses taken in a tableview. These courses will be sorted by semester
// The letter grade will be displayed to the right of the course name. The overall GPA will be displayed 
// on the top of the page. Swiping to the right will display a detail view of the gpa breakdown. This controller will be 
// called MainPageDetailViewController.swift.

import UIKit
import CoreData

class MainPageViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var gradeTableView: UITableView!
    @IBOutlet var gpaButton: UIButton!
   
    var userCreated: Bool = false
    var courseObjectList:[Course] = []
    var user = Student()
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()
    
    //Set empty uservar up here
    //var superUser = User()
    func loadUser()
    {
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        //gets all User objects
        var request = NSFetchRequest(entityName: "Student")
        request.returnsObjectsAsFaults = false;
        
        //filters User objects to only return those with studentName = to "User"
        request.predicate = NSPredicate(format:"studentName = %@", "User")
        
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        
        user = result[0] as Student
    }
    
    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }
    
//Need to find a way to make courseObjectList global for this view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var courseObjectList  = Student.returnAllCourses(context)
        println("Course object Lis ---------------\(courseObjectList.count)")
        if (courseObjectList.count>0)
        {
            return courseObjectList.count
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView:UITableView!)->Int
    {
        println("number of semesters-----------------------\(Student.returnSemesterList(context).count)")
        return Student.returnSemesterList(context).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var semesterList = Student.returnSemesterList(context)
        var semesterArray = semesterList.allObjects
        var thisSemester = semesterArray[section] as Semester
        return "\(thisSemester.returnSemesterString())"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No Grades Entered")
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var courseObjectList  = Student.returnAllCourses(context)
        if (courseObjectList.count>0)
        {
        cell.textLabel?.text = "\(courseObjectList[indexPath.row].courseTitle)"
        }
        else
        {
            cell.textLabel?.text = "No Courses Entered"
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var userLoaded: Bool = false
        loadContext()
        //save function
        func save()
        {
            var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            var error : NSError?
            if(context.save(&error) ) {
                println(error?.localizedDescription)
            }
        }
        
        func loadStudent() -> Bool
        {
            var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            //gets all User objects
            var request = NSFetchRequest(entityName: "Student")
            request.returnsObjectsAsFaults = false;
            
            //filters User objects to only return those with studentName = to "User"
            request.predicate = NSPredicate(format:"studentName = %@", "User")
            
            var result: NSArray = context.executeFetchRequest(request, error: nil)!
            println("printing result \(result)")
            if (result.count > 0)
            {
                println("In result.count if statement: \(result.count)")
                println("User already created")
                println("NUMBER OF COURSES------------------\(result[0].returnNumberOfCourses())")
                return true
            }
            else
            {
                println("User not found")
                var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                
                let newUser = NSEntityDescription.insertNewObjectForEntityForName("Student",inManagedObjectContext: context) as Student
                newUser.studentName = "User"
                newUser.sciGpa=0
                newUser.nonSciGpa=0
                newUser.totalSciCredits=0
                newUser.totalNonSciCredits=0
                newUser.overallGpa=0
                newUser.totalCredits=0
                println("User created \(newUser.studentName)")
                save()
                return true
            }
        }
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var courseObjectList  = Student.returnAllCourses(context)
        println("Course Object List ------------\(courseObjectList.count)")
        
        if (userLoaded==false)
        {
            userLoaded=loadStudent()
        }
        
        //Add funcs here to load superUser , can then add all required var declarations from superuser on top and initialize them down here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
