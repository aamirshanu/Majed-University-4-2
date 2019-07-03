//
//  ContactViewController.swift
//  studentModule
//
//  Created by mac on 31/01/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class ContactViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
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

    //When We Click on ADVISOR button this method will be called
    @IBAction func backToAdvisor(_ sender: Any) {
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
    }
    
    
    
     //When We Click on HOME button this method will be called
    @IBAction func backToHomeButton(_ sender: Any) {
        
        //Calling Method
       gotoHome()
        
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
    
    
    //when we click on Return Button on Keyboard this method is called
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    //Text View Moves up
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    //Text View Back to Normal Position
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    @IBAction func sendButton(_ sender: Any) {
        
        let messageDB = Database.database().reference().child("Query").child("Advisor Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : textView.text] as [String : Any]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            }else{
                print("Message Saved Suuccessfully!")
                self.textView.text = ""
               
                
    }
}
}
}

