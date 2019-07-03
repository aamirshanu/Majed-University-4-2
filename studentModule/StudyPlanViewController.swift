//
//  StudyPlanViewController.swift
//  studentModule
//
//  Created by mac on 17/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase


struct SettledCourses {
    var courseName = ""
    var courseId = ""
}
class StudyPlanViewController: UIViewController {
    
    var selectedCourse: SettledCourses!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iboardNameLbl: UILabel!
    var arrayCourse = [SettledCourses]()
    var button : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getSettledCourses()
        retrieveName()
    }
    
    func retrieveName(){
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
        
        let messageDB = Database.database().reference().child("Student").child(userID)
        print("new user id" + userID)
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "name" {
                self.iboardNameLbl.text = snapshot.value as? String
                
            }
            
        })
        
    }
    func getSettledCourses(){
        
        let nameDB = Database.database().reference().child("Courses")
        
        nameDB.observe(.childAdded, with: { (snapshot) in
            
            if let dictCourses = snapshot.value as? [String:Any] {
                let courseName = dictCourses["courseName"] as! String
                let settle = dictCourses["isSettled"] as! Bool
                
                var objCourse = SettledCourses()
                objCourse.courseName = courseName
                objCourse.courseId = snapshot.key
                if settle {
                    self.arrayCourse.append(objCourse)
                    print(self.arrayCourse)
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    
    @IBAction func coursesButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        gotoHome()
    }
    
    @IBAction func enrollButtonPressed(_ sender: UIButton) {
    }
    
    @objc func enrollTapped(sender: UIButton) {
        let course = arrayCourse[sender.tag]
        
        let studentCoursesRef = Database.database().reference().child("student-courses").child(Auth.auth().currentUser!.uid)
        studentCoursesRef.updateChildValues([course.courseId:1])
        
        let enrolledCorsesRef = Database.database().reference().child("enrolled-courses").child(course.courseId)
        enrolledCorsesRef.updateChildValues([Auth.auth().currentUser!.uid:1])
    }
    
    //This Method is used when we want to move back More than One Controller
    func gotoHome(){
        if let nav = self.navigationController {
            let viewControllers = nav.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
    
}

extension StudyPlanViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyPlanCell", for: indexPath) as! StudyPlanCell
       
        cell.textLabel?.text = arrayCourse[indexPath.row].courseName
        button = cell.enrollButton
        cell.enrollButton.tag = indexPath.row
        cell.enrollButton.addTarget(self, action: #selector(enrollTapped(sender:)), for: .touchUpInside)

    
        return cell
    }
}

