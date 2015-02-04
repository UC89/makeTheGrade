//
//  GpaDetailViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/22/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//
// GPA Detail View Controller

import UIKit
import CoreData


class GpaDetailViewController: UIViewController {
    
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()
    
    @IBOutlet var gpaGoalField: UITextField!
    @IBOutlet var overallGPALabel: UILabel!
    @IBOutlet var scienceGPALabel: UILabel!
    @IBOutlet var nonScienceGPALabel: UILabel!
    @IBOutlet var majorGPA: UILabel!
    @IBOutlet var makingGPAGoalLabel: UILabel!
    

    var user: NSManagedObject = NSManagedObject()
    
    @IBAction func clickSubmit()
    {
        
        var request = NSFetchRequest(entityName: "Student")
        request.returnsObjectsAsFaults = false;
        
        //filters User objects to only return those with studentName = to "User"
        request.predicate = NSPredicate(format:"studentName = %@", "User")
        
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        
        var user = result[0] as Student
        println("User \(user.studentName) GPA: \(user.returnGPA())")
        println("\n**********************************************************")
        println("In clickSubmit Function")
        var userObject = user as Student
        println("Set user object")
        userObject.goalGPA = (gpaGoalField.text as NSString).floatValue
        println("Set user ggoal gpa")
        println("Goal GPA Submitted Successfuly  GPA Goal: \(userObject.goalGPA)")
        
        println("----------------------------------------------------------\n")
        
        if (userObject.returnGPA() >= userObject.goalGPA)
        {
            makingGPAGoalLabel.textColor = UIColor.greenColor()
            
            makingGPAGoalLabel.text = "Your GPA of \(userObject.returnGPA()) meets your goal of \(userObject.goalGPA)"
        }
        else
        {
            makingGPAGoalLabel.textColor = UIColor.redColor()
            makingGPAGoalLabel.text = "Your GPA of \(userObject.returnGPA()) does not meet your goal of \(userObject.goalGPA)"
        }
    }
    
    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }

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
        
        var user = result[0] as Student
        println("User \(user.studentName) GPA: \(user.returnGPA())")
        
        
        if (user.returnGPA() >= user.goalGPA)
        {
            makingGPAGoalLabel.textColor = UIColor.greenColor()
            makingGPAGoalLabel.text = "Your GPA of \(user.returnGPA()) meets your goal of \(user.goalGPA)"
        }
        else
        {
            makingGPAGoalLabel.textColor = UIColor.redColor()
            makingGPAGoalLabel.text = "Your GPA of \(user.returnGPA()) does not meet your goal of \(user.goalGPA)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

            loadContext()
            loadUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
