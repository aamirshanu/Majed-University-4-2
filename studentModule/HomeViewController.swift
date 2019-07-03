//
//  SecondViewController.swift
//  studentModule
//
//  Created by mac on 31/01/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        //For Showing Navigation Bar on the Top of the Controller
        navigationController?.isNavigationBarHidden = false
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
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        //when we click on Courses Button Page will be moved to Courses Page
        let vc = storyboard?.instantiateViewController(withIdentifier: "CoursesViewController") as! CoursesViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
}
