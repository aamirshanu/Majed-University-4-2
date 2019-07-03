//
//  InformationViewController.swift
//  studentModule
//
//  Created by mac on 06/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class InformationViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtOffice: UITextField!
    @IBOutlet weak var txtOfficeHour: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var iboardNameLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        retrieveMessages()
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
    @IBAction func advisorButton(_ sender: Any) {
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
        gotoHome()
        
    }
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
        
        
        let messageDB = Database.database().reference().child("Advisor Information")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "name" {
                self.txtName.text = snapshot.value as? String
            }
                
            else if snapshot.key == "office" {
                self.txtOffice.text = snapshot.value as? String
                
            }else if snapshot.key == "email" {
                self.txtEmail.text = snapshot.value as? String
                
            }else if snapshot.key == "phone"{
                self.txtPhone.text = snapshot.value as? String
                
            }else if snapshot.key == "office hour"{
                self.txtOfficeHour.text = snapshot.value as? String
            }
            
        })
        
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
