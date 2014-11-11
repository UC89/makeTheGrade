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
    var userGPA:Float = 3.000
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()
    var sendCourseID: Int = 0
    

    
    //Set empty uservar up here
    //var superUser = User()
    func loadUserGPA()
    {
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        //gets all User objects
        var request = NSFetchRequest(entityName: "Student")
        request.returnsObjectsAsFaults = false;
        
        //filters User objects to only return those with studentName = to "User"
        request.predicate = NSPredicate(format:"studentName = %@", "User")
        
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        
        var user = result[0] as Student
        
        if (user.returnNumberOfGrades() > 0)
        {
            var userGPA = user.returnGPA()
            var userGPAString = (NSString(format: "%.03f", userGPA))
            println("Number of grades \(user.returnNumberOfGrades())")
            println("GPA \(user.returnGPA())")
            println("Setting userGPA in MakeTheGrade Main Page")
            gpaButton.setTitle("\(userGPAString)", forState: UIControlState.Normal)
        }
    }
    
    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }
    
//Need to find a way to make courseObjectList global for this view. done through calling a function in viewdidload and changing vars declared before viewdidload
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var courseObjectList  = Student.returnAllCourses(context)
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
        cell.textLabel?.text = "\(courseObjectList[indexPath.row].courseTitle) \(courseObjectList[indexPath.row].returnLetterGrade())"
        }
        else
        {
            cell.textLabel?.text = "No Courses Entered"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
    
        println("Selected \(indexPath.row) cell says \(cell?.textLabel?.text)")
        sendCourseID = indexPath.row
        performSegueWithIdentifier("clickCourseName", sender: cell)
        
    }
    
    
    //Send vars to other view controller here
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "clickCourseName")
        {
            var svc = segue.destinationViewController as courseDetailView
            svc.courseID = sendCourseID
        }
        else if (segue.identifier == "addOptionSegue")
        {
            var svc = segue.destinationViewController as AddOptionViewController
        }
        else if (segue.identifier == "gpaDetailSegue")
        {
            var svc = segue.destinationViewController as GpaDetailViewController
            //svc.currentUser =
        }
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
                println("\n NUMBER OF COURSES------------------\(result[0].returnNumberOfCourses()) \n")
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

        loadUserGPA()
        //rgpaButton.setTitle("\(userGPA)" , forState: UIControlState.Normal)
      /*
        if (user.returnNumberOfGrades() > 0)
        {
            println("")
            println("Number of Grades is more than 0")
            println("")
            gpaButton.setTitle("/(user.returnGPA())", forState: UIControlState.Normal)
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
