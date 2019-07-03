//
//  ChatViewController.swift
//  studentModule
//
//  Created by mac on 11/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    //var enrolled : EnrolledCourses!
    var course : Course!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    
    // Declare instance variables here
    
    var messageArray : [Message] = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        messageField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        //TODO: Register your MessageCell.xib file here:
        
        tableView.register(UINib(nibName: "CustomMessageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        //for terminate lines of cell
        tableView.separatorStyle = .none
    }

    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCellTableViewCell
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.bubbleView.layer.cornerRadius = 15
        cell.bubbleView.layer.masksToBounds = true
        
        if cell.senderUsername.text ==  Auth.auth().currentUser?.email   as! String {
            
            
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 149/255, blue: 255/255, alpha: 1)
            cell.senderUsername.textColor = UIColor.white
            cell.messageBody.textColor = UIColor.white
            cell.rightviewConstrant.constant = 5
          cell.leftViewConstrant.constant = 130
            
            
            
        }else{
            
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.leftViewConstrant.constant = 5
          cell.rightviewConstrant.constant = 130
            cell.senderUsername.textColor = UIColor.white
            cell.messageBody.textColor = UIColor.black
           
            
        }
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    
    @objc  func tableViewTapped(){
        messageField.endEditing(true)
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    //TODO: Declare configureTableView here:
    
    func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180.0
    }
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.constraint.constant = 320
            self.view.layoutIfNeeded()
        }
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            
            self.constraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.resignFirstResponder()
        
        return true
    }
    
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Messages").child(course.courseId)
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.tableView.reloadData()
            self.scrollToLastRow()
        })
    }
    
    func scrollToLastRow() {
        if messageArray.count > 0 {
            UIView.animate(withDuration: 0.2) {
                let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            }
        }
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
       
    messageField.endEditing(true)
        
        
        //TODO: Send the message to Firebase and save it in our database
        if messageField.text == nil{
            return
        }else{
       messageField.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageField.text]
        
        messageDB.child(course.courseId).childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            }else{
                print("Message Saved Suuccessfully!")
                self.messageField.text = ""
                self.messageField.isEnabled = true
                self.sendButton.isEnabled = true
                
            }
        }
        }
    }
}

