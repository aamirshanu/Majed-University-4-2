//
//  ModuleSelectorViewController.swift
//  studentModule
//
//  Created by mac on 09/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ModuleSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func selectorButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            let lv = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(lv, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfessorLoginViewController") as! ProfessorLoginViewController
            navigationController?.pushViewController(vc, animated: true)
        case 2:
             print("No selection")
        default:
            print("No selection")
        }
    }
    
}
