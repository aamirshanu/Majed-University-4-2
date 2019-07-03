//
//  StudentListTwoViewController.swift
//  studentModule
//
//  Created by mac on 17/02/19.
//  Copyright © 2019 mac. All rights reserved.
//
import UIKit
import Firebase

struct Student {
    
    var studentName :String!
    var studentId :String!
    var studentNationalId :String!
    var studentEmail :String!
    var studentPhone :String!
    var studentAddress :String!
}

class StudentListViewController: UIViewController {
      @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var iboardNameLbl: UILabel!
    var course: Course!
    var selection : Student!
    var arrStd = [Student]()
    
    //TODO: Add Student array
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
           getStudent()
        
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
    
    func getStudent(){
        
        let studentRef = Database.database().reference().child("enrolled-courses").child(course.courseId)
        
        studentRef.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            let studentRef = Database.database().reference().child("Student").child(snapshot.key)
            studentRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dict = snapshot.value as? [String:Any] {
                    let studentId = dict["studentId"] as! String
                    let studentName = dict["name"] as! String
                    let studentAddress = dict["address"] as! String
                    let studentEmail = dict["email"] as! String
                    let studentNationalId = dict["nationalId"] as! String
                    let studentPhone = dict["phone"] as! String
                    
                    var student = Student()
                    student.studentId = studentId
                    student.studentName = studentName
                    student.studentAddress = studentAddress
                    student.studentEmail = studentEmail
                    student.studentPhone = studentPhone
                    student.studentNationalId = studentNationalId
                    
                    self.arrStd.append(student)
                }
                self.tableView.reloadData()
            })
            
            
           
        })
    }
   
}
extension StudentListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrStd[indexPath.row].studentName
        return cell
    }
}
