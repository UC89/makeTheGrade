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
    var semesterCourseDict = [Int:NSMutableArray]()
    var mainUser:[Student] = []
  

    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }
    
    func loadSemesterCourseDict()
    {
        println("\n In loadSemesterCourseDict")
        var user = mainUser[0]
        var index = 0
        for semester in user.semesterList
        {
            var tempCourseList = NSMutableArray()
            var semesterObj = semester as Semester
            //println("In semester \(semesterObj.returnSemesterString())")
            for course in semesterObj.courseList
            {
                var courseObj = course as Course
                //println("Course obj print \(courseObj)")
                //println("current course in loop \(courseObj.courseTitle)")
                tempCourseList.addObject(courseObj)
                //println("tempCourseList is \(tempCourseList)")
            }
            semesterCourseDict[index] = tempCourseList
            //println("Semester with id \(index) has \(tempCourseList)")
            index += 1
        }
        //println("semesterCourseDict is \(semesterCourseDict)\n")
    }
    
    //FINAL FUNC
    func loadUserGPA()
    {
        var user:Student = mainUser[0] as Student
        
        if (user.returnNumberOfGrades() > 0)
        {
            var userGPAString = (NSString(format: "%.03f", user.returnGPA()))
            gpaButton.setTitle("\(userGPAString)", forState:UIControlState.Normal)
        }
    }

    //Need to find a way to make courseObjectList global for this view. done through calling a function in viewdidload and changing vars declared before viewdidload
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var user:Student = mainUser[0] as Student
        if (user.returnNumberOfCourses() > 0)
        {
            var courseList:Array = semesterCourseDict[section]!
            //println("Semestercoursedict[count] = \(semesterCourseDict[section]) count: \(courseList.count)")
            return courseList.count
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView:UITableView!)->Int
    {
        var user:Student = mainUser[0] as Student
        return user.returnNumberOfSemesters()
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
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No Courses For This Semester")
        //println("IndexPath.Section = \(indexPath.section) indexPath.row = \(indexPath.row)")
        var currentSemester = semesterCourseDict[indexPath.section]
        //println("Current semster  = \(currentSemester)")
      //  var currentCourse = currentSemester[indexPath.row]
        var currentCourse: Course = currentSemester?.objectAtIndex(indexPath.row) as Course
        var currentCourseGradeString = NSString(format:"%.02f" , currentCourse.calcCurrentGrade())
        cell.textLabel?.text = "\(currentCourse.courseTitle) \(currentCourseGradeString)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        var selectedSemester = semesterCourseDict[indexPath.section]
        var selectedCourse = selectedSemester?.objectAtIndex(indexPath.row) as Course
        sendCourseID = selectedCourse.courseID
        performSegueWithIdentifier("clickCourseName", sender: cell)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            println("\n\n---------------Deleting Course from Context--------------------")
            var courseToDeleteList = semesterCourseDict[indexPath.section]
            var courseToDelete = courseToDeleteList?.objectAtIndex(indexPath.row) as Course
            println("courseToDelete: \(courseToDelete.courseTitle)")
            context.deleteObject(courseToDelete)
            println("Error part 1")
            loadSemesterCourseDict()
            println("error part 2")
            gradeTableView.reloadData()
            println("Semester Course Dict: \(semesterCourseDict)")
            println("error part 3")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            println("error part 4")
        }
    }
    

    
    //Line to delete an nsmanagedobject
    // [aContext deleteObject:aManagedObject]
    //context.save()
    
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
            //svc.currentUser = mainUser[0] as Student
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
                //println("In result.count if statement: \(result.count)")
                //println("User already created")
                //println("\n NUMBER OF COURSES------------------\(result[0].returnNumberOfCourses()) \n")
                mainUser.append(result[0] as Student)
                return true
            }
            else
            {
                //println("User not found")
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
                //println("User created \(newUser.studentName)")
                save()
                mainUser.append(newUser)
                return true
            }
        }
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var courseObjectList  = Student.returnAllCourses(context)
        //println("Course Object List ------------\(courseObjectList.count)")
        
        if (userLoaded==false)
        {
            userLoaded=loadStudent()
        }

        //Add funcs here to load superUser , can then add all required var declarations from superuser on top and initialize them down here.

        loadUserGPA()
        loadSemesterCourseDict()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*func loadUserGPA()
{
// var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//  var context:NSManagedObjectContext = appDel.managedObjectContext!

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
*/
