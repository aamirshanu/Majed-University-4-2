//
//  adminAssignCourseViewController.swift
//  studentModule
//
//  Created by mac on 20/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

struct Professor {
    var name : String!
    var id: String!
}

class AssignCourseViewController: UIViewController {

    @IBOutlet weak var sectionTxtField: UITextField!
    @IBOutlet weak var bottomSectionPickerConstrant: NSLayoutConstraint!
    @IBOutlet weak var sectionBottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var sectionPicker: UIPickerView!
    @IBOutlet weak var viewSectionPicker: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var viewTimePicker: UIView!
    @IBOutlet weak var bottomTimePickerConstrant: NSLayoutConstraint!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var professorTxtField: UITextField!
    @IBOutlet weak var pickerProfessor: UIPickerView!
    @IBOutlet weak var viewPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewPicker: UIView!
    
    var arrSection = ["VC", "LC"]
    var arrProfessor = [Professor]()
    var selectedProfessor: Professor!
    var selectedCourse: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerProfessor.delegate = self
        pickerProfessor.dataSource = self
        sectionPicker.dataSource = self
        sectionPicker.delegate = self
        getProfessors()
        
    }
    
    @IBAction func chooseSectionButton(_ sender: UIButton) {
        showHideSectionPicker(isShow: true)
        print("Button Pressed")
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected Date is : \(selectedDate)")
        
        //Formate date
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
         var strDate = formatter.string(from: selectedDate)
        print("Date in string format is :\(strDate)")
        
        timeTxtField.text = strDate
        print("Text Time Is :" + timeTxtField.text!)
    }
    func showHideSectionPicker(isShow: Bool) {
        if isShow {
            sectionBottomConstrant.constant = 0
            sectionPicker.reloadAllComponents()
        }
        else {
            sectionBottomConstrant.constant = 220
        }
    }
    func showHideProfessorPicker(isShow: Bool) {
        if isShow {
            viewPickerBottomConstraint.constant = 0
            pickerProfessor.reloadAllComponents()
        }
        else {
            viewPickerBottomConstraint.constant = -viewPicker.frame.height
        }
    }
    func showHideTimePicker(isShow: Bool) {
        if isShow {
            bottomTimePickerConstrant.constant = 0
            timePicker.reloadInputViews()
        }
        else {
            bottomTimePickerConstrant.constant = -timePicker.frame.height
        }
    }
    @IBAction func chooseProfessorButton(_ sender: UIButton) {
        showHideProfessorPicker(isShow: true)
    }
    @IBAction func chooseTimingButton(_ sender: UIButton) {
        showHideTimePicker(isShow: true)
    }
    
    @IBAction func professorPickerDoneButton(_ sender: UIButton) {
        viewPickerBottomConstraint.constant = -viewPicker.frame.height
        print("Field is :" + professorTxtField.text!)
    }
    
    @IBAction func professorPickerCancelButton(_ sender: UIButton) {
        viewPickerBottomConstraint.constant = -220
    }
    
    @IBAction func timePickerDoneButton(_ sender: UIButton) {
        bottomTimePickerConstrant.constant = -220
    }
    @IBAction func timePickerCancelButton(_ sender: UIButton) {
        bottomTimePickerConstrant.constant = -220

    }
    
    @IBAction func sectionPickerDoneButton(_ sender: UIButton) {
            sectionBottomConstrant.constant = 220
    }
    
    @IBAction func sectionPickerCancelButton(_ sender: UIButton) {
        sectionBottomConstrant.constant = 220

    }
    func getProfessors(){
        
        let nameDB = Database.database().reference().child("Professor")
        
        nameDB.observe(.childAdded, with: { (snapshot) in
            
            if let dictProfessor = snapshot.value as? [String:Any] {
                let name = dictProfessor["name"] as! String
                let id = snapshot.key
                
                var objProfessor = Professor()
                objProfessor.name = name
                objProfessor.id = id
                
                self.arrProfessor.append(objProfessor)
            }
        })
    }
    
    @IBAction func assignButton(_ sender: UIButton) {
        //Add the course to professor-courses node
        let professorCoursesRef = Database.database().reference().child("professor-courses").child(selectedProfessor.id)
        professorCoursesRef.updateChildValues(([selectedCourse.courseId:1]))
        
        //Update the course node with isSettled = true
        let courseRef = Database.database().reference().child("Courses").child(selectedCourse.courseId)
        courseRef.updateChildValues(["isSettled":true])
        
        let time = ["courseTime": timeTxtField.text!] as! [String: String]
        let courseTime = Database.database().reference().child("Courses").child(selectedCourse.courseId)
        courseTime.updateChildValues(time)
        
        let section = ["section": sectionTxtField.text!] as! [String: String]
        let courseSection = Database.database().reference().child("Courses").child(selectedCourse.courseId)
        courseSection.updateChildValues(section)
        
    }
}

extension AssignCourseViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == pickerProfessor {
            return arrProfessor[row].name
        } else if pickerView == sectionPicker{
            return arrSection[row]
        }
        return ""
        //return arrProfessor[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if pickerView == pickerProfessor {
            return arrProfessor.count
        } else if pickerView == sectionPicker{
            return arrSection.count
        }
        return 1
        //return arrProfessor.count
    }
}

extension AssignCourseViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerProfessor {
            selectedProfessor = arrProfessor[row]
            professorTxtField.text = selectedProfessor.name
        } else if pickerView == sectionPicker{
            sectionTxtField.text = arrSection[row]
        }
        
        
    }
}


