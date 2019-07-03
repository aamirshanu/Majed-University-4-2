//
//  CourseTimingViewController.swift
//  studentModule
//
//  Created by mac on 01/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class CourseTimingViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var sectionLbl: UILabel!
    @IBOutlet weak var courseTimelbl: UILabel!
    var courseTiming : Course!
    var arrtime = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

       courseTimelbl.text = courseTiming.time
        sectionLbl.text = courseTiming.section
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
    
    @IBAction func homeButton(_ sender: UIButton) {
        gotoHome()
    }
    //This Method is used when we want to move back More than One Controller
    func gotoHome(){
        if let nav = self.navigationController {
            let viewControllers = nav.viewControllers
            for aViewController in viewControllers {
                if aViewController is ProfessorLoginViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
}

