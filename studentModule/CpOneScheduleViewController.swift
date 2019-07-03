//
//  CpOneScheduleViewController.swift
//  studentModule
//
//  Created by mac on 04/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CpOneScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
   
    
    
    @IBAction func coursesButton(_ sender: UIButton) {
        
        //Calling Method
        gotoCourse()
        
        
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        
        //Calling Method
        gotoHome()
        
    }
    
    
    
    
    
    
    //This Method is used when we want to move back More than One Controller
    func gotoCourse(){
        if let nav = self.navigationController {
            let viewControllers = nav.viewControllers
            for aViewController in viewControllers {
                if aViewController is CoursesViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
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
