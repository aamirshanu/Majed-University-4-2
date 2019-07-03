//
//  ScheduleViewController.swift
//  studentModule
//
//  Created by mac on 04/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

struct EnrolledCourses {
    var courseName = ""
    var courseId = ""
}
class ScheduleViewController: UIViewController {

    var good : IndexPath!
    var select : Course!
    var arCourse = [Course]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iboardNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        retrieveCourses()
        retrieveName()
        tableView.separatorStyle = .none
     
       
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
    
   
    func retrieveCourses(){
        let user = Auth.auth().currentUser
        let courseDB = Database.database().reference().child("student-courses").child(user!.uid)
        
        courseDB.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            let courseRef = Database.database().reference().child("Courses").child(snapshot.key)
            courseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictCourse = snapshot.value as? [String:Any] {
                    let course = dictCourse["courseName"] as! String
                    var objCourse = Course()
                    objCourse.courseName = course
                    objCourse.courseId = snapshot.key
                    self.arCourse.append(objCourse)
                    
                   
                }
                 self.tableView.reloadData()
            })
        })
        
    }
    @IBAction func backToCoursesButton(_ sender: UIButton) {
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func backToHomeButton(_ sender: UIButton) {
        gotoHome()
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return true
    }
    
   /* func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference().child("student-courses")
            let groupRef = ref.child((Auth.auth().currentUser?.uid)!).child(arCourse[indexPath.row].courseId)
            // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
            groupRef.removeValue()
            arCourse.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }*/
    @objc func deleteCourses(sender: UIButton) {
        let course = arCourse[sender.tag].courseId
        let ref = Database.database().reference().child("student-courses")
        let groupRef = ref.child((Auth.auth().currentUser?.uid)!).child(course!)
        // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
        groupRef.removeValue()
        arCourse.remove(at: sender.tag) // dataSource being your dataSource array
        tableView.reloadData()
    }
    
    
    @objc func enrollTapped(sender: UIButton) {
        let course = arCourse[sender.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentChatViewController") as! StudentChatViewController
        vc.course = course
        navigationController?.pushViewController(vc, animated: true)
        
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
extension ScheduleViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!ScheduleTableViewCell
        cell.textLabel?.text = arCourse[indexPath.row].courseName
        cell.textLabel?.isHidden = true
        cell.courseButton.setTitle(cell.textLabel?.text, for:.normal)

         good = indexPath
        cell.courseButton.tag = indexPath.row
        
        cell.crossedButton.tag = indexPath.row
        cell.courseButton.addTarget(self, action: #selector(enrollTapped(sender:)), for: .touchUpInside)
        cell.crossedButton.addTarget(self, action: #selector(deleteCourses(sender:)), for: .touchUpInside)


        return cell
    }
}
/*extension ScheduleViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentChatViewController") as! StudentChatViewController
        vc.course = arCourse[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
} */
