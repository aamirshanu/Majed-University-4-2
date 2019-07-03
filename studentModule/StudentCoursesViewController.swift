//
//  StudentCoursesViewController.swift
//  studentModule
//
//  Created by mac on 01/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class StudentCoursesViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    var courseList : Course!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func studentButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentListViewController") as! StudentListViewController
        vc.course = self.courseList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func courseDetailsButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CourseTimingViewController") as! CourseTimingViewController
        vc.courseTiming = self.courseList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func groupChatButton(_ sender: UIButton) {
        
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.course = self.courseList
            navigationController?.pushViewController(vc, animated: true)
        
            }
}
