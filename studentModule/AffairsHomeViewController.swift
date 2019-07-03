//
//  AffairsHomeViewController.swift
//  studentModule
//
//  Created by mac on 09/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

class AffairsHomeViewController: UIViewController {

    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        //For Showing Navigation Bar on the Top of the Controller
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func addCoursesButton(_ sender: UIButton) {
        alert()
    }
    
    func alert(){
        
        let alert = UIAlertController(title: "Course", message: "Add Course Here!", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let Ok = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            let textField = alert.textFields?[0]
            print(textField?.text!)
            
            if textField?.text == ""{
                return
            }
            else{
                let dictCourse: [String:Any] = ["courseName": textField!.text!,"isSettled":false]
                self.ref.child("Courses").childByAutoId().setValue(dictCourse)
            }
        }
        alert.addAction(Ok)
        
        alert.addTextField { (TextField: UITextField) in
            TextField.placeholder = "Enter Course Name"
        }
        
        self.present(alert, animated:true, completion:nil)
    }
}
