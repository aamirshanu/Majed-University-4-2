//
//  OneOnOneChatViewController.swift
//  studentModule
//
//  Created by mac on 02/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class OneOnOneChatViewController: UIViewController, UITableViewDelegate {

    var selectedUser: StudentList!{
        didSet {
            navigationItem.title = selectedUser?.studentName
        }
    }
    var arrMessages = [IndividualMessage]()

    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstrant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "CustomMessageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        getMessagesFromFirebase()
    }

    @IBAction func sendButton(_ sender: UIButton) {
        handleSendMessage(toUser: selectedUser)
    }
    func getMessagesFromFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //Get reference of our DB
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        
        //Observe the DB for any changes
        userMessagesRef.observe(.childAdded) { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("Messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //Get the dictionary that we stored while sending the message
                let dictMessage = snapshot.value as! [String:String]
                
                //Instantiate Message object
                let messageObject = IndividualMessage(dictionary: dictMessage)
                
                if messageObject.chatPartnerId == self.selectedUser?.studentId {
                    //Add the message object to arrMessages
                    self.arrMessages.append(messageObject)
                    
                    //Reload the table
                    self.tableView.reloadData()
                    
                    self.scrollToLastRow()
                    
                }
            })
        }
    }
    func scrollToLastRow() {
        if arrMessages.count > 0 {
            UIView.animate(withDuration: 0.2) {
                let indexPath = IndexPath(row: self.arrMessages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func handleSendMessage(toUser: StudentList) {
        
        let messagesDB = Database.database().reference().child("Messages")
        
        guard let fromUserId = Auth.auth().currentUser?.uid else {
            print("Current user id not available")
            return
        }
        
        let dictMessage = ["toUserId": toUser.studentId, "fromUserId":fromUserId, "text": txtMessage.text!]
        
        let childMessage = messagesDB.childByAutoId()
        childMessage.setValue(dictMessage) { (error, reference) in
            
            if error != nil {
                print("An error occured while saving \(error!.localizedDescription)")
                return
            }
            
            print("Message saved successfully in Messages node")
            self.txtMessage.text = ""
            
            //Get the key of auto generated child node above
            let messageId = childMessage.key
            
            //Get a new reference for from user
            let fromUserReference = Database.database().reference(withPath: "user-messages").child(fromUserId)
            fromUserReference.updateChildValues([messageId!:1], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    return
                }
                
                print(snapshot)
            })
            
            //Get a new reference for to user
            let toUserReference = Database.database().reference(withPath: "user-messages").child(toUser.studentId)
            toUserReference.updateChildValues([messageId!:1], withCompletionBlock: { (error, snapshot) in
                if error != nil {
                    return
                }
                
                print(snapshot)
            })
        }
    }

}
extension OneOnOneChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCellTableViewCell
        
        let message = arrMessages[indexPath.row]
        
        cell.bubbleView.layer.cornerRadius = 15
        cell.bubbleView.layer.masksToBounds = true
        cell.messageBody.text = message.text
        
        //cell.viewBubbleWidth.constant = estimateFrameForText(message.text).width + 32
        
        if message.fromUserId == Auth.auth().currentUser!.uid {
            //Message was sent
            cell.rightviewConstrant.constant = 5
            cell.leftViewConstrant.constant = 130
            
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 149/255, blue: 255/255, alpha: 1)
            cell.messageBody.textColor = .white
            
        }
        else {
            cell.leftViewConstrant.constant = 5
            cell.rightviewConstrant.constant = 130
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.messageBody.textColor = .black
            
        }
        
        return cell
    }
}
