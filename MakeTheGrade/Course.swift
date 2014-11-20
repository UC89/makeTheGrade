//
//  Course.swift
//  MakeTheGrade
//
//  Created by Taylor Somma on 10/25/14.
//  Copyright (c) 2014 Taylor Somma. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var courseTitle: String
    @NSManaged var credits: NSNumber
    @NSManaged var examsPerc: NSNumber
    @NSManaged var gradeOverride: NSNumber
    @NSManaged var homeworkPerc: NSNumber
    @NSManaged var otherPerc: NSNumber
    @NSManaged var pointsOrPercentage: NSNumber
    @NSManaged var quizesPerc: NSNumber
    @NSManaged var scienceCourse: NSNumber
    @NSManaged var semesterSeason: String
    @NSManaged var gradeOverrideBool: Bool
    @NSManaged var isCourseFinished: Bool
    @NSManaged var courseID: NSNumber
    @NSManaged var goalGrade: NSNumber
    @NSManaged var belongsTo: Semester
    @NSManaged var gradeList: NSSet
    
    var currentGrade: Double = Double()
    
    
    class func addCourse(moc: NSManagedObjectContext, title:String,courseCredits:Float,courseExamsPerc:Float,courseQuizesPerc:Float,courseHwPerc:Float,courseOtherPerc:Float,isScienceCourse:Bool, isCoursePoints:Bool, gradeOverride:Float,semesterIDIn:Int) -> Course
    {
        let belongsToSemester = NSFetchRequest(entityName: "Semester")
        belongsToSemester.returnsObjectsAsFaults = false
        belongsToSemester.predicate = NSPredicate(format:"semesterID = %@","\(semesterIDIn)")
        
        var semester:NSArray = moc.executeFetchRequest(belongsToSemester, error: nil)!
        var semesterSelected = semester[0] as Semester
        
        var newCourseID:Int = semesterSelected.belongsTo.returnNumberOfCourses()
        
        
        let newCourse = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: moc) as Course
        newCourse.courseTitle = title
        newCourse.credits = courseCredits
        newCourse.examsPerc = courseExamsPerc
        newCourse.homeworkPerc = courseHwPerc
        newCourse.quizesPerc = courseQuizesPerc
        newCourse.otherPerc = courseOtherPerc
        newCourse.pointsOrPercentage = isCoursePoints
        newCourse.scienceCourse = isScienceCourse
        newCourse.belongsTo = semesterSelected
        newCourse.courseID = newCourseID
        
        
        println("\n NEWCOURSEID----------------\(newCourseID) \n")
        if (gradeOverride>0 )
        {
            newCourse.gradeOverrideBool = true
            newCourse.gradeOverride = gradeOverride
        }
        else
        {
            newCourse.gradeOverrideBool = false
        }
        
        println("New course Created for \(semesterIDIn)  belonging to \(newCourse.belongsTo)")
        //println("Number of courses created: \(userSelected.returnNumberOfCourses())")
        return newCourse
    }
    
    func returnTotalPointsPossible() -> Float
    {
        var totalPoints = Float(examsPerc) + Float(quizesPerc) + Float(homeworkPerc) + Float(otherPerc)
        return Float(totalPoints)
    }
    func returnPointsNeededToMakeGrade() -> Float
    {
        var returnPoints = Float()
        returnPoints = (goalGrade/100 * returnTotalPointsPossible()) - (calcCurrentGrade() * returnTotalPointsPossible())
        return returnPoints
    }
    
    //This func also sets isCourseFinished
    func returnCourseCompletePercentage() -> Double
    {
        
        if (isCourseFinished == true)
        {
            return 100.0
        }
        else if (gradeOverride > 0)
        {
            isCourseFinished = true
            return 100.0
        }
        if (pointsOrPercentage == true)
        {
            var pointsCompleted = 0.0
            var pointsPossible = 0.0
            pointsPossible = examsPerc + quizesPerc + homeworkPerc + otherPerc
            for grade in gradeList
            {
                var gradeObj = grade as Grade
                pointsCompleted += gradeObj.pointsPossible
            }
            if (((pointsCompleted/pointsPossible)*100) >= 100)
            {
                isCourseFinished = true
            }
            return (pointsCompleted/pointsPossible)*100
        }
        else if (pointsOrPercentage == false)
        {
            var percentageComplete = 0.0
            for grade in gradeList
            {
                //Possible gradetypes ["Test","Quiz","HW","Other"]
                var gradeObj = grade as Grade
                if (gradeObj.gradeType == "Test")
                {
                    percentageComplete += (gradeObj.percentage * examsPerc)/100
                }
                else if (gradeObj.gradeType == "Quiz")
                {
                    percentageComplete += (gradeObj.percentage * quizesPerc)/100
                }
                else if (gradeObj.gradeType == "HW")
                {
                    percentageComplete += (gradeObj.percentage * homeworkPerc)/100
                }
                else if (gradeObj.gradeType == "Other")
                {
                    percentageComplete += (gradeObj.percentage * otherPerc)/100
                }
            }
            if (percentageComplete >= 100.0)
            {
                isCourseFinished = true
            }
            
            return percentageComplete
        }
        else
        {
            println("Error calculating percentage")
            return -1.0
        }
    }
    
    func returnCategoryCompleteDictionary() -> Array<Double>
    {
        //exam,quiz,hw,other
        var testComplete = 0.0
        var quizComplete = 0.0
        var hwComplete = 0.0
        var otherComplete = 0.0
        
        if (pointsOrPercentage == true)
        {
            for grade in gradeList
            {
                var gradeObj = grade as Grade
                if (gradeObj.gradeType == "Test")
                {
                    testComplete += gradeObj.pointsPossible
                }
                else if (gradeObj.gradeType == "Quiz")
                {
                    quizComplete += gradeObj.pointsPossible
                }
                else if (gradeObj.gradeType == "HW")
                {
                    hwComplete += gradeObj.pointsPossible
                }
                else if (gradeObj.gradeType == "Other")
                {
                    otherComplete += gradeObj.pointsPossible
                }
            }
            return [(testComplete / examsPerc)*100,(quizComplete / quizesPerc)*100,(hwComplete / quizesPerc)*100, (otherComplete / otherPerc)*100]
        }
        else if (pointsOrPercentage == false)
        {
            for grade in gradeList
            {
                var gradeObj = grade as Grade
                if (gradeObj.gradeType == "Test")
                {
                    testComplete += (gradeObj.percentage * examsPerc)/100
                }
                else if (gradeObj.gradeType == "Quiz")
                {
                    quizComplete += (gradeObj.percentage * quizesPerc)/100
                }
                else if (gradeObj.gradeType == "HW")
                {
                    hwComplete += (gradeObj.percentage * homeworkPerc)/100
                }
                else if (gradeObj.gradeType == "Other")
                {
                    otherComplete += (gradeObj.percentage * otherPerc)/100
                }
            }
            return [(testComplete / examsPerc)*100,(quizComplete / quizesPerc)*100,(hwComplete / quizesPerc)*100, (otherComplete / otherPerc)*100]
        }
       var percentageArray = [0.0,0.0,0.0,0.0]
       return percentageArray
    }
    
    
    func goalMet() -> Bool
    {
        if (returnPointsNeededToMakeGrade() <= 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    func printCourseDetails()
    {
        println("\n\n----------------------------------------------\n\n")
        println("Course Title: \(courseTitle)")
        println("Course ID: \(courseID)")
        println("Credits: \(credits)")
        println("pointsOrPercentage Value: \(pointsOrPercentage)")
        println("Science Class Value: \(scienceCourse)")
        println("Percentage of Course completed: \(returnCourseCompletePercentage())")
        println("Categories complete Dict: \(returnCategoryCompleteDictionary())")
        println("Exams Perc Value: \(examsPerc)")
        println("Quiz perc Value: \(quizesPerc)")
        println("HW perc Value: \(homeworkPerc)")
        println("Other Perc Value: \(otherPerc)")
    }
    
    func calcCurrentGrade() -> Float
    {
        var returnGrade: Float = Float()
        if (pointsOrPercentage == 1)
        {
            returnGrade = calcCurrentGradeForPoints()
        }
        else
        {
            returnGrade = calcCurrentGradeForPercentage()
        }
        return returnGrade
    }
    
    func calcCurrentGradeForPoints() -> Float
    {
        var totalPointsEarned = 0.0
        var totalPointsPossible = 0.0
        
        for grade in gradeList
        {
            var gradeObj = grade as Grade
            totalPointsEarned += gradeObj.pointsEarned
            totalPointsPossible += gradeObj.pointsPossible
        }
        
        currentGrade = (totalPointsEarned/totalPointsPossible)
        return Float(totalPointsEarned/totalPointsPossible) * 100
    }
    
    func calcCurrentGradeForPercentage() -> Float
    {
        var testPointsEarnedTotal = 0.0
        var testPercentageComplete = 0.0
        var quizPointEarnedTotal = 0.0
        var quizPercentageComplete = 0.0
        var hwPointsEarnedTotal = 0.0
        var hwPercentageComplete = 0.0
        var otherPointsEarnedTotal = 0.0
        var otherPercentageComplete = 0.0
        
        var testTaken = false
        var quizTaken = false
        var hwTaken = false
        var otherTaken = false

        var totalPoints = 0.0
        
        var testPercOfHundred = 0.0
        var quizPercOfHundred = 0.0
        var hwPercOfHundred = 0.0
        var otherPercOfHundred = 0.0
        
        var categoryGrades = [Double]()
        
        for grade in gradeList
        {
            var gradeObj = grade as Grade
            if (gradeObj.gradeType == "Test")
            {
                testPointsEarnedTotal += (gradeObj.pointsEarned / gradeObj.pointsPossible) * gradeObj.percentage
                testPercentageComplete += gradeObj.percentage
                testTaken = true
            }
            else if (gradeObj.gradeType == "Quiz")
            {
                quizPointEarnedTotal += (gradeObj.pointsEarned / gradeObj.pointsPossible) * gradeObj.percentage
                quizPercentageComplete += gradeObj.percentage
                quizTaken = true
            }
            else if (gradeObj.gradeType == "HW")
            {
                hwPointsEarnedTotal += (gradeObj.pointsEarned / gradeObj.pointsPossible) * gradeObj.percentage
                hwPercentageComplete += gradeObj.percentage
                hwTaken = true
            }
            else if (gradeObj.gradeType == "Other")
            {
                otherPointsEarnedTotal += (gradeObj.pointsEarned / gradeObj.pointsPossible) * gradeObj.percentage
                otherPercentageComplete += gradeObj.percentage
                otherTaken = true
            }
            else
            {
                println("----------------Error---------In Course calcCurrentGradeModel-----------")
            }
        }
        
        if (testTaken)
        {
            var testGradeAdd = ((100/testPercentageComplete) * testPointsEarnedTotal) / 100
            var gradeToAdd = testGradeAdd
            println("Test Grade Info/n----------------------")
            println("testGradeAddVar = \(testGradeAdd) (100/testPercentageComplete *testPointsEarnedTotal)")
            println("gradeToAdd = \(gradeToAdd)  testGradeAdd * examsPerc")
            categoryGrades.append(gradeToAdd)
        }
        
        if (quizTaken)
        {
            var quizGradeAdd = ((100/quizPercentageComplete) * quizPointEarnedTotal) / 100
            var gradeToAdd = quizGradeAdd
            categoryGrades.append(gradeToAdd)
        }
        
        if (hwTaken)
        {
            var hwGradeAdd = ((100/hwPercentageComplete) * hwPointsEarnedTotal) / 100
            var gradeToAdd = hwGradeAdd
            categoryGrades.append(gradeToAdd)
        }
       
        if (otherTaken)
        {
            var otherGradeToAdd = ((100/otherPercentageComplete) * otherPointsEarnedTotal) / 100
            var gradeToAdd = otherGradeToAdd
            categoryGrades.append(gradeToAdd)
        }
        
        for grade in categoryGrades
        {
            totalPoints += grade
        }
        
        var numberOfCategories:Double = Double(categoryGrades.count)
        var returnGrade = (totalPoints / numberOfCategories) * 100
        println("-----------------------------------------------")
        println("Grade for: \(courseTitle)")
        println("numberOfCategories = \(numberOfCategories)")
        println("totalPoints = \(totalPoints)")
        println("------------------------------------------------")
        currentGrade = returnGrade
        return Float(returnGrade)
    }
    
    func returnLetterGrade() -> String
    {
        if (pointsOrPercentage == true)
        {
            currentGrade = Double(self.calcCurrentGradeForPoints())
        }
        else if (pointsOrPercentage == false)
        {
            currentGrade = Double(self.calcCurrentGradeForPercentage())
        }
        if (currentGrade > 93)
        {
            return "A"
        }
        else if (currentGrade > 90)
        {
            return "A-"
        }
        else if (currentGrade > 86)
        {
            return "B+"
        }
        else if (currentGrade > 83)
        {
            return "B"
        }
        else if (currentGrade > 80)
        {
            return "B-"
        }
        else if (currentGrade > 76)
        {
            return "C+"
        }
        else if (currentGrade > 73)
        {
            return "C"
        }
        else if (currentGrade > 70)
        {
            return "C-"
        }
        else if (currentGrade > 66)
        {
            return "D+"
        }
        else if (currentGrade > 63)
        {
            return "D"
        }
        else if (currentGrade > 60)
        {
            return "D-"
        }
        else if (currentGrade > 0)
        {
            return "F"
        }
        else
        {
            return "--"
        }
    }
    
}
