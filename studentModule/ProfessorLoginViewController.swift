//
//  ProfessorLoginViewController.swift
//  studentModule
//
//  Created by mac on 09/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class ProfessorLoginViewController: UIViewController {

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
        
        
        let messageDB = Database.database().reference().child("Professor").child(userID)
        print("new user id" + userID)
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "name" {
                self.iboardNameLbl.text = snapshot.value as? String
                
            }
            
        })
        
    }

}
