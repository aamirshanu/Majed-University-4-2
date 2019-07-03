//
//  StudentChatViewController.swift
//  studentModule
//
//  Created by mac on 26/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class StudentChatViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    var course : Course!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func homeButton(_ sender: UIButton) {
        gotoHome()
    }
    @IBAction func coursesButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
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
    @IBAction func chatButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.course = self.course
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
