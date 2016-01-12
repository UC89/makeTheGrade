//
//  NewGradeViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/24/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewGradeViewController: UIViewController,UIPickerViewDelegate{
    
    
    @IBOutlet var assignmentNameTextField: UITextField!
    @IBOutlet var pointsEarnedTextField: UITextField!
    @IBOutlet var pointsPossibleTextField: UITextField!
    @IBOutlet var percOfCategoryTextField: UITextField!
    
    @IBOutlet var coursePickerView: UIPickerView!
    
    @IBOutlet var gradePercentageUsed: UITableView!
    
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()

    var courseDict = [Int:String]()
    var courseSelectedId: Int!
    var categoryIDList = ["Test","Quiz","HW","Other"]
    var categoryID = String()
    
    var gradeIDSent = Int()
    
    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }
    
    func loadCourseDictionary()
    {
        //println("LoadingSemesterString List ------------------------------------")
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var courseObjectList = Student.returnAllCourses(context)
        //println("returning semesterObjectList \(courseObjectList)")
        
        //println("--------------------------------------------")
        for course in courseObjectList
        {
            var courseInLoop = course as Course
            var courseIndex: Int
            var courseString = "\(courseInLoop.courseTitle)"
            var courseID = courseInLoop.courseID
            courseDict[courseID] = courseString
        }
    }
    
    func numberOfComponentsInPickerView(coursePickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    func pickerView(coursePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (component==0)
        {
            return categoryIDList.count
        }
        else
        {
            return courseDict.count
        }
    }
    
    func pickerView(coursePickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        //Sort semesterDict
        if (component==0)
        {
            return categoryIDList[row]
        }
        else
        {
            return courseDict[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if (component==0)
        {
            categoryID = categoryIDList[row]
            println("Selected \(categoryID)")
        }
        else
        {
            courseSelectedId = row
            println("Selected \(courseSelectedId)")
        }
    }
    func save()
    {
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var error : NSError?
        if(context.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    @IBAction func clickSubmit()
    {

        var emptyString = ""
        
        if (assignmentNameTextField.text==emptyString || pointsEarnedTextField.text==emptyString || pointsPossibleTextField.text==emptyString)
        {
            println("This is not a valid form. Please fill in all of the required fields.")
        }
/*else if
        {
            // var categoryIDList = ["Test","Quiz","HW","Other"]
        }
*/ 
        else
        {
        let gradeTitle = assignmentNameTextField.text as String

        let gradePointsEarned = (pointsEarnedTextField.text as NSString).floatValue
        let gradePointsPossible = (pointsPossibleTextField.text as NSString).floatValue
        let percentageOfCat = (percOfCategoryTextField.text as NSString).floatValue
        
        
        // Need to add constraints here to make sure grades are valid
        println("\n*****************\n Adding a grade\n------------------------------------------------\n")
        
        Grade.addGrade(context, titleIn: gradeTitle, pointsEarnedIn: gradePointsEarned, pointsPossibleIn: gradePointsPossible, percentageIn: percentageOfCat, courseIDIn: courseSelectedId, gradeTypeIn: categoryID)
        }
        save()
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadContext()
        loadCourseDictionary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
