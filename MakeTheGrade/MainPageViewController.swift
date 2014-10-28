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

class MainPageViewController: UIViewController {
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
        
        cell.textLabel?.text = String("\(gradeCalc.returnAssignmentNames()[indexPath.row])   \(gradeCalc.returnGrades()[indexPath.row])")
        
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
    
    lazy var managedObjectContext : NSManagedObjectContext? =
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext
        {
            return managedObjectContext
        }
        else
        {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println(managedObjectContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
