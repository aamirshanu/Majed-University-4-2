//
//  ProfessorProfileInformationViewController.swift
//  studentModule
//
//  Created by mac on 11/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class ProfessorProfileInformationViewController: UIViewController, UITextFieldDelegate,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSpecialisation: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtId.delegate = self
        txtName.delegate = self
        txtPhone.delegate = self
        scrollView.delegate = self
        retrieveMessages()
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
        
        navigationController?.popViewController(animated: true)
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
       
        let messageDB = Database.database().reference().child("Professor").child(userID)
        print("new user id" + userID)
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "professorId" {
                self.txtId.text = snapshot.value as? String
            }
            
            else if snapshot.key == "name" {
                self.txtName.text = snapshot.value as? String
                
            }else if snapshot.key == "nationalId" {
                self.txtSpecialisation.text = snapshot.value as? String
                
            }else if snapshot.key == "address"{
                self.txtAddress.text = snapshot.value as? String
                
            }else if snapshot.key == "phone"{
                self.txtPhone.text = snapshot.value as? String
                
            }else if snapshot.key == "email"{
                self.txtEmail.text = snapshot.value as? String
            }
            
        })
        
    }
    
}
