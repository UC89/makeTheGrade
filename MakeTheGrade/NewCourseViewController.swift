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
    
    @IBOutlet var semesterPickerView: UIPickerView!
    
    var pointsOrPercentageVar = true
    var scienceClassVar = true
    var gradeOverrideVar: Float = 0
    var semesterStringList = ["1","2","3"]
    var semesterStringSelected:String = ""
    var semesterDict = [Int:String]()
    var semesterIDSelected: Int!
 
    
    

    //This function is called in viewdidload to load global var for this view
    func loadSemesterDictionary()
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
            var semesterIndex: Int
            semesterString = "\(semesterInLoop.season) \(semesterInLoop.year)"
            semesterIndex = semesterInLoop.semesterID
            println(semesterString)
            semesterDict[semesterIndex] = semesterString
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
                    pointsOrPercentageVar = true
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
            scienceClassVar = true
        }
    }

    @IBAction func submitButtonPressed()
    {
        let courseCreditsFloat = (courseCredits.text as NSString).floatValue
        let courseExamsPercFloat = (examPercentage.text as NSString).floatValue
        let quizPercentageFloat = (quizPercentage.text as NSString).floatValue
        let homeworkPercentageFloat = (homeworkPercentage.text as NSString).floatValue
        let otherPercentageFloat = (otherPercentage.text as NSString).floatValue
        let gradeOverrideFloat = (gradeOverride.text as NSString).floatValue
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        Course.addCourse(context, title: courseTitle.text, courseCredits: courseCreditsFloat, courseExamsPerc: courseExamsPercFloat, courseQuizesPerc: quizPercentageFloat, courseHwPerc: homeworkPercentageFloat, courseOtherPerc: otherPercentageFloat, isScienceCourse: scienceClassVar, isCoursePoints: pointsOrPercentageVar, gradeOverride: gradeOverrideFloat, semesterIDIn: semesterIDSelected)
        save()
        println("Course added with name \(courseTitle.text) and semester id of \(semesterIDSelected)")
    }


    
    func numberOfComponentsInPickerView(semesterPickerView: UIPickerView) -> Int
    {
        return 1
    }

    // returns the # of rows in each component..
    func pickerView(semesterPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (component==0)
        {
            return semesterDict.count
        }
        else
        {
            return 0
        }
    }
    
    
    func pickerView(semesterPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        //Sort semesterDict
        if (component==0)
        {
            return semesterDict[row]
        }
        else
        {
            return "Error"
        }
    }
    
    func pickerView(semesterPickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = semesterDict[row]
        var myTitle = NSAttributedString(string: titleData!, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0),NSForegroundColorAttributeName:UIColor(red: (158.0/255.0), green: (54.00/255.00), blue: (252.0/255.0), alpha: 1.0)])
        return myTitle
    }


    
    func pickerView(semesterPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        semesterIDSelected = row
        println("SemesterIDSelected -------------\(semesterIDSelected)")
    }
    

    
    
    // Add UIAlert if percentages do not add up to 100% or total point amount.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadSemesterDictionary()
        println("Passed loadSemesterStringList")
        println("--------------------------------------------------")
        println("Trying to print semester Dict \(semesterDict)")
        println("--------------------------------------------------")
        if (semesterDict.count>0)
        {
            self.semesterPickerView.selectRow(0, inComponent: 0, animated: true)
            semesterIDSelected=0
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
