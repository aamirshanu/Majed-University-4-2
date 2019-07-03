//
//  StudentListChatViewController.swift
//  studentModule
//
//  Created by mac on 01/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

struct StudentList {
    var studentId : String!
    var studentName : String!
    var studentEmail : String!
}

class StudentListChatViewController: UIViewController {

    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var arrStdList = [StudentList]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registeredStudent()
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
        navigationController?.popViewController(animated: true)
    }
    func registeredStudent(){
        let user = Auth.auth().currentUser
        
       
        let Ref = Database.database().reference().child("Student")
           Ref.observe(.childAdded, with: { (snapshot) in
            if let dictStd = snapshot.value as? [String:Any] {
                var objStd = StudentList()
                objStd.studentName = dictStd["name"] as! String
                objStd.studentId = snapshot.key
                objStd.studentEmail = dictStd["email"] as! String
                self.arrStdList.append(objStd)
                self.tableView.reloadData()
            
            }
            
        })
        
    }

}
extension StudentListChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if arrStdList[indexPath.row].studentId == Auth.auth().currentUser!.uid as! String{
            cell.isUserInteractionEnabled = false
        }
        
        cell.textLabel?.text = arrStdList[indexPath.row].studentName
        
        return cell
    }
}
extension StudentListChatViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OneOnOneChatViewController") as! OneOnOneChatViewController
        
        vc.selectedUser = arrStdList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

