//
//  ThirdViewController.swift
//  studentModule
//
//  Created by mac on 31/01/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class CoursesViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

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

     //When We Click on HOME button this method will be called
    @IBAction func homeButton(_ sender: UIButton) {
        
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
