//
//  StudentHomeMessageViewController.swift
//  studentModule
//
//  Created by mac on 05/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class StudentHomeMessageViewController: UIViewController {
  
 
    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var arrMessage = [StudentMessage]()
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
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Professor Message").child("Advisor Messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            
            // let sender = snapshotValue["a@k.com"]!
            
            let message = StudentMessage()
            
            message.messageBody = text
            // message.sender = sender
            
            self.arrMessage.append(message)
            self.tableView.reloadData()
            
        })
        
    }

    @IBAction func homeButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension StudentHomeMessageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! UITableViewCell
        
        //cell.lblSender.text = arrMessage[indexPath.row].sender
       
        cell.textLabel?.text = arrMessage[indexPath.row].messageBody
        return cell
    }
    
    
}
