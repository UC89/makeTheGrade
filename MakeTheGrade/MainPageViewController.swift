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
    
    /*
    let cellIdentifier = "cellIdentifier"
    @IBOutlet var gradesTableView: UITableView!
    
    
    @IBAction func viewTapped (sender : AnyObject)
    {
        self.view.resignFirstResponder()
    }
    
    //UITableViewDataSource Method
    func numberOfSectionsInTableView(gradesTableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(gradesTableView: UITableView, numberOfRowsInSection section: Int) ->Int
    {
        return gradeCalc.numberOfGrades()
    }
    
    func tableView(gradesTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No grades Entered")
        
        cell.textLabel?.text = String("\(gradeCalc.returnAssignmentNames()[indexPath.row])   \(gradeCalc.returnGrades()[indexPath.row])")                                   //indexPath.row is the number of the row, this is almost
                                                                 // like a for loop in the length of 
                                                                // the tableview numberOfRowsInSection Function
        return cell
    }
    
    //UITableViewDelegate Methods
    func tableView(gradesTableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let alert = UIAlertController(title: "Item Selected", message: "You selected item \(indexPath.row)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
            {
                (alert: UIAlertAction!) in println("An alert of type \(alert.style.hashValue) was tapped!")
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    */
    
    @IBOutlet var gradeTableView: UITableView!
   
    var userCreated: Bool = false
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No Grades Entered")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var userLoaded: Bool = false
        
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
        
        if (userLoaded==false)
        {
            userLoaded=loadStudent()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
