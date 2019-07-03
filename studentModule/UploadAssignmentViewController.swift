//
//  UploadAssignmentViewController.swift
//  studentModule
//
//  Created by mac on 11/03/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
class UploadAssignmentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
 
    let image = UIImagePickerController()
    
    var imageReference: StorageReference{
        return Storage.storage().reference().child("Images")
    }
    @IBOutlet weak var iboardNameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      image.delegate = self
        // Do any additional setup after loading the view.
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
    @IBAction func browseButton(_ sender: UIButton) {
       
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true){
            //code
        }
    }
    
  @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.image = image
        }else{
            print("Error !!!!!!!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
   @IBAction func uploadButton(_ sender: UIButton) {
    //Image Uploading :
    let imageName = NSUUID().uuidString //to make image name unique
    
    //Get storage reference to our profile_images DB
    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
    
    //Compressed image using jpeg
    if let profileImage = self.imageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
        
       // if let imageData = UIImagePNGRepresentation(self.imageView.image!) {
        //Upload data on Firebase Storage
        storageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
            if error != nil {
                print("Error while trying to upload image -> \(error!.localizedDescription)")
                return
            }
            
            //Image uploaded successfully
            
            
        })
    
        

    }
    
    
        
    }
}

