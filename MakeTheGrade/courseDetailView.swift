//
//  courseDetailView.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 11/9/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

// Need to print lines to confirm which category grades are being added to

import UIKit
import CoreData

class courseDetailView: UIViewController, UITableViewDataSource
{
    @IBOutlet var courseDetailTableView: UITableView!
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var letterGradeHeader: UILabel!
    
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()
    
    var courseGradeDict = [String:NSMutableArray]()
    var courseID: Int!
    var gradeCats = ["Test","Quiz","HW","Other","Uncategorized"]
    var gradeCatsActual = [String]()
    
    func loadContext()
    {
        appDel = (UIApplication.sharedApplication().delegate as AppDelegate)
        context = appDel.managedObjectContext!
    }
    
    func loadCourseGradeDict()
    {
        //gets all User objects
        var request = NSFetchRequest(entityName: "Course")
        request.returnsObjectsAsFaults = false;
        
        //filters User objects to only return those with studentName = to "User"
        request.predicate = NSPredicate(format:"courseID = %@", "\(courseID)")
        
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        //println("printing result \(result)")
        
        var currentCourse = result[0] as Course
        
        courseTitleLabel.text = currentCourse.courseTitle
        letterGradeHeader.text = currentCourse.returnLetterGrade()
        
        var tempTestList = NSMutableArray()
        var tempQuizList = NSMutableArray()
        var tempHWList = NSMutableArray()
        var tempOtherList = NSMutableArray()
        var uncaughtList = NSMutableArray()
        
        currentCourse.printCourseDetails()
        
        for grade in currentCourse.gradeList
        {
            var gradeObj = grade as Grade
            if (gradeObj.gradeType == "Test")
            {
                tempTestList.addObject(gradeObj)
            }
            else if (gradeObj.gradeType == "Quiz")
            {
                tempQuizList.addObject(gradeObj)
            }
            else if (gradeObj.gradeType == "HW")
            {
                tempHWList.addObject(gradeObj)
            }
            else if (gradeObj.gradeType == "Other")
            {
                tempOtherList.addObject(gradeObj)
            }
            else
            {
                uncaughtList.addObject(gradeObj)
            }
        }
        if (tempTestList.count > 0 )
        {
        courseGradeDict["Test"] = tempTestList
        gradeCatsActual.append("Test")
        }
        if (tempQuizList.count > 0)
        {
        courseGradeDict["Quiz"] = tempQuizList
        gradeCatsActual.append("Quiz")
        }
        if (tempHWList.count > 0)
        {
        courseGradeDict["HW"] = tempHWList
        gradeCatsActual.append("HW")
        }
        if (tempOtherList.count > 0)
        {
        courseGradeDict["Other"] = tempOtherList
        gradeCatsActual.append("Other")
        }
        if (uncaughtList.count > 0)
        {
        courseGradeDict["Uncategorized"] = uncaughtList
        gradeCatsActual.append("Uncategorized")
        }
        
        println("\(courseGradeDict)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //println("\n Making Table View in Course Detail View \n ------------------------------------")
        var currentCat = gradeCatsActual[section]
        var currentCatGrades = courseGradeDict[currentCat]
        var currentCatGradesCount = currentCatGrades?.count
        //println("CurrentCatGradesCount = \(currentCatGradesCount)")
        return currentCatGradesCount!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        //println("In numberOfSectionsInTableView returning \(gradeCatsActual) count of \(gradeCatsActual.count)")
        return gradeCatsActual.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        //println("In titleForHeaderInSection and returning \(gradeCatsActual) section \(gradeCats[section])")
        return gradeCatsActual[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       // println("\nMaking Cell--------------------------\n")
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No Grades Entered")
       // println("\n CourseGradeDict[gradeCats]indexPath.section]] returns \(courseGradeDict[gradeCats[indexPath.section]])")
       /* if (courseGradeDict[gradeCats[indexPath.section]] != nil)
        {
            var gradeListTemp = courseGradeDict[gradeCats[indexPath.section]]
            var gradeObj = gradeListTemp?.objectAtIndex(indexPath.row) as Grade
            
            cell.textLabel?.text = "\(gradeObj.assignmentTitle)"
        }
        else
        {
            cell.textLabel?.text = "No Grades Entered"
        }
        */
        
        var currentGradeCat = gradeCatsActual[indexPath.section]
        //println("Passed currentGradeCat")
        var currentGradeCatGrades = courseGradeDict[currentGradeCat]
        //println("\nAbout to get currentGrade object for cell label")
        //println("-----------------------------------------\n\(currentGradeCatGrades)/n")
        var currentGrade = currentGradeCatGrades?.objectAtIndex(indexPath.row) as Grade
        //println("Got currentGrade object \(currentGrade)")
        
        //(NSString(format: "%.03f", user.returnGPA()))
        
        var currentGradeForCell = NSString(format: "%.01f", (Float(currentGrade.pointsEarned) / Float(currentGrade.pointsPossible)) * 100)
        
        cell.textLabel?.text = "\(currentGrade.assignmentName) Grade: \(currentGradeForCell) Percentage: \(currentGrade.percentage)"
        //println("Successfuly set cell label")
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadContext()
        loadCourseGradeDict()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
