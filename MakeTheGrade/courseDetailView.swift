//
//  courseDetailView.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 11/9/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import UIKit

class courseDetailView: UIViewController, UITableViewDataSource
{
    @IBOutlet var courseDetailTableView: UITableView!
    var courseGradeList  = ["Grade 1","Grade 2", "Grade 3"]
    var sectionList = ["Section1","Section2"]
    
    var courseID: Int!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sectionList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        return "\(sectionList[section])  courseIDPassed \(courseID)"
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
