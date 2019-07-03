//
//  ProfileInformationViewController.swift
//  studentModule
//
//  Created by mac on 06/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfileInformationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCourse: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtNationalId: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtphone: UITextField!
    
   
    
    
    @IBOutlet weak var scrollView: UIScrollView!
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
  
    @IBAction func homeButton(_ sender: Any) {
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
    }
    
    
    func retrieveMessages(){
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
        let messageDB = Database.database().reference().child("Student").child(userID)
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "studentId" {
                self.txtId.text = snapshot.value as? String
            }
                
            else if snapshot.key == "name" {
                self.txtName.text = snapshot.value as? String
                
            }else if snapshot.key == "Course" {
                self.txtCourse.text = snapshot.value as? String
                
            }else if snapshot.key == "address"{
                self.txtAddress.text = snapshot.value as? String
                
            }else if snapshot.key == "nationalId"{
                self.txtNationalId.text = snapshot.value as? String
                
            }else if snapshot.key == "phone"{
                self.txtphone.text = snapshot.value as? String
                
            }else if snapshot.key == "email"{
                self.txtEmail.text = snapshot.value as? String
            }
            
        })
        
    }
    
    
}
