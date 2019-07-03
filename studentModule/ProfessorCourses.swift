//
//  ProfessorCoursesPickerViewController.swift
//  studentModule
//
//  Created by mac on 10/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class ProfessorCourses: UIViewController {
    
    @IBOutlet weak var iboardNameLbl: UILabel!
    var student : Student!
    @IBOutlet weak var tableView: UITableView!
    var arrCourses = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveCourses()
        retrieveName()
    }
    
    func retrieveName(){
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
        
        let messageDB = Database.database().reference().child("Professor").child(userID)
        print("new user id" + userID)
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "name" {
                self.iboardNameLbl.text = snapshot.value as? String
                
            }
            
        })
        
    }
    
    func retrieveCourses(){
        let user = Auth.auth().currentUser
        let courseDB = Database.database().reference().child("professor-courses").child(user!.uid)
        
        courseDB.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let courseRef = Database.database().reference().child("Courses").child(snapshot.key)
            courseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictCourse = snapshot.value as? [String:Any] {
                    let objCourse = Course()
                    objCourse.courseName = dictCourse["courseName"] as! String
                    objCourse.courseId = snapshot.key
                    objCourse.time = dictCourse["courseTime"] as! String
                    objCourse.section = dictCourse["section"] as! String

                    self.arrCourses.append(objCourse)
                    self.tableView.reloadData()
                }
                
                print(self.arrCourses)
            })
        })
        
    }
    @objc func enrollTapped(sender: UIButton) {
        let course = arrCourses[sender.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentCoursesViewController") as! StudentCoursesViewController
        vc.courseList = course
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfessorCourses : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfessorCoursesTableViewCell
        cell.textLabel?.text = arrCourses[indexPath.row].courseName
        cell.textLabel?.isHidden = true
        cell.cellButton.setTitle(cell.textLabel?.text, for:.normal)
        
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: #selector(enrollTapped(sender:)), for: .touchUpInside)
        return cell
    }
}
/*extension ProfessorCourses : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentCoursesViewController") as! StudentCoursesViewController
        vc.courseList = arrCourses[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}*/
