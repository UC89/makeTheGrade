//
//  NewCourseViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/24/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewCourseViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var courseTitle: UITextField!
    @IBOutlet var courseCredits: UITextField!
    @IBOutlet var gradeOverride: UITextField!
    @IBOutlet weak var quizPercentage: UITextField!
    @IBOutlet weak var examPercentage: UITextField!
    @IBOutlet weak var homeworkPercentage: UITextField!
    @IBOutlet weak var isScienceClass: UISegmentedControl!
    @IBOutlet weak var pointsOrPercentageSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var otherPercentage: UITextField!
    
    @IBOutlet weak var semesterPickerView: UIPickerView!
    
    var semesterSelected:Semester!
    var pointsOrPercentageVar: Bool!
    var scienceClassVar: Bool!
    var gradeOverrideVar: Float = 0
    var semesterStringList: [String] = ["1","2"]
 
    
    

    
    func loadSemesterStringList() -> NSSet
    {
        println("LoadingSemesterString List ------------------------------------")
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var semesterObjectList = Student.returnSemesterList(context)
        println("returning semesterObjectList \(semesterObjectList)")
   
        println("--------------------------------------------")
        for semester in semesterObjectList
        {
            var semesterInLoop = semester as Semester
            var semesterString = ""
            semesterString = "\(semesterInLoop.season) \(semesterInLoop.year)"
            println(semesterString)
            semesterStringList.append(semesterString)
        }
        println("\(semesterStringList)")
        return semesterObjectList
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
    
    func pickerView(semesterPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (component==0)
        {
            return loadSemesterStringList().count
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(semesterPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        //The string order will correspond to the semesterID, therefore I can get the semster needed based on using t
        // the predicate for semesterid using the value picked from the picker view.
        var semesterStringListInst = loadSemesterStringList()
        if (component==0)
        {
            return semesterStringList[row]
        }
        else
        {
            return "Error"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (component==0)
        {
            //semesterSelected = semesterStringList[row]
        }
        
    }

    
    @IBAction func pointsOrPercentageSegmentOutlet(sender:UISegmentedControl)
    {
        switch pointsOrPercentageSegmentOutlet.selectedSegmentIndex
            {
                case 0:
                    pointsOrPercentageVar = true
                    println("Graded by points")
                case 1:
                    pointsOrPercentageVar = false
                    println("graded by Percentage")
                default:
                break;
            }
    }
    
    //This is working
    @IBAction func isScienceClassSegmentOutlet(sender:UISegmentedControl)
    {
        switch isScienceClass.selectedSegmentIndex
            {
        case 0:
            scienceClassVar = true
            println("Science Class selected \(scienceClassVar)")
        case 1:
            scienceClassVar = false
            println("Is not a science class")
        default:
            break;
        }
    }
    
  /*  @IBAction func submitButtonPressed()
    {
        gradeOverrideVar = gradeOverride.text as Float
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        Course.addCourse(context, title: courseTitle.text, courseCredits: courseCredits.text, courseExamsPerc: examPercentage, courseQuizesPerc: quizPercentage.text, courseHwPerc: homeworkPercentage.text, courseOtherPerc: otherPercentage.text, isScienceCourse: scienceClassVar, isCoursePoints: pointsOrPercentageVar, gradeOverride: gradeOverrideVar, semesterIDIn: Int)
        save()
    }
*/
    
    
    // Add UIAlert if percentages do not add up to 100% or total point amount.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var semesterObjectList = loadSemesterStringList()
        println("Passed loadSemesterStringList")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
