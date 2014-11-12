//
//  courseDetailView.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 11/9/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import UIKit
import CoreData

class courseDetailView: UIViewController, UITableViewDataSource
{
    @IBOutlet var courseDetailTableView: UITableView!
    var courseGradeList  = ["Grade 1","Grade 2", "Grade 3"]
    var sectionList = ["Section1","Section2"]
    
    var appDel = AppDelegate()
    var context = NSManagedObjectContext()
    
    var courseGradeDict = [String:NSMutableArray]()
    var courseID: Int!
    
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
        println("printing result \(result)")
        
        var currentCourse = result[0] as Course
        
        var tempTestList = NSMutableArray()
        var tempQuizList = NSMutableArray()
        var tempHWList = NSMutableArray()
        var tempOtherList = NSMutableArray()
        var uncaughtList = NSMutableArray()
        
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
        courseGradeDict["Test"] = tempTestList
        courseGradeDict["Quiz"] = tempQuizList
        courseGradeDict["HW"] = tempHWList
        courseGradeDict["Other"] = tempOtherList
        courseGradeDict["Uncategorized"] = uncaughtList
        
        println("\(courseGradeDict)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return courseGradeDict.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        return "Hello"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "No Grades Entered")

        if (courseGradeList.count>0)
        {
            cell.textLabel?.text = "\(courseGradeList[indexPath.row])"
        }
        else
        {
            cell.textLabel?.text = "No Grades Entered"
        }
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
