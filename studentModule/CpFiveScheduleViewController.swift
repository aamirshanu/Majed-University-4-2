//
//  CpFiveScheduleViewController.swift
//  studentModule
//
//  Created by mac on 05/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CpFiveScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func coursesButton(_ sender: UIButton) {
        
        //This is used to back to that Controller from where we come on this Controller
        navigationController?.popViewController(animated: true)
    }
    @IBAction func homeButton(_ sender: UIButton) {
        
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
}
