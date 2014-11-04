//
//  NewSemesterViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/24/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewSemesterViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var semesterPickerView: UIPickerView!
    
    var semesters = ["Fall","Spring","Winter","Summer","Q1","Q2","Q3","Q4"]
    var years = [2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026]
    var semesterSelected = "Fall"
    var yearSelected = 2014
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(semesterPickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(semesterPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (component==0)
        {
            return semesters.count
        }
        else
        {
            return years.count
        }
    }
    
    func pickerView(semesterPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        if (component==0)
        {
            return semesters[row]
        }
        else
        {
            return String(years[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (component==0)
        {
            semesterSelected = semesters[row]
        }
        else
        {
            yearSelected = years[row]
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

   
    @IBAction func submitButtonPressed()
    {
        var semesterIDIn = 1
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        Semester.addSemester(context, season: semesterSelected, year: yearSelected,semesterID: semesterIDIn)
        save()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
