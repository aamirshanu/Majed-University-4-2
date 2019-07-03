//
//  SettlingCoursesViewController.swift
//  studentModule
//
//  Created by mac on 20/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class SettlingCoursesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrCourses = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        retrieveCourses()
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func retrieveCourses(){
        
        let courseDB = Database.database().reference().child("Courses")
        
        courseDB.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                
                let courseName = dict["courseName"] as! String
                
                let course = Course()
                
                if  dict["isSettled"] as! Bool == false{
                    course.courseName = courseName
                    course.courseId = snapshot.key
                    self.arrCourses.append(course)
                }
                
            }
            self.tableView.reloadData()
        })
    }
}

extension SettlingCoursesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
        cell.textLabel?.text = arrCourses[indexPath.row].courseName
        return cell
    }
}
extension SettlingCoursesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AssignCourseViewController") as! AssignCourseViewController
        vc.selectedCourse = self.arrCourses[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)
    }
}
