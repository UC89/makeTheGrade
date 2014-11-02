//
//  NewSemesterViewController.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/24/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import UIKit

class NewSemesterViewController: UIViewController, UIPickerViewDataSource {
    @IBOutlet var semesterPickerView: UIPickerView!
    var semesters = ["Fall","Spring","Winter","Summer"]
    var years = [2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
    
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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
