//
//  StudentListFourViewController.swift
//  studentModule
//
//  Created by mac on 17/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class StudentListFourViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var array = ["1. Majed Tariq Shami", "2. Shami Urrahman", "3. Sheikh Arslan ", "4. Abdul Talha", "5. Farrukh","6. Majed Tariq Shami", "7. Shami Urrahman", "8. Sheikh Arslan ", "9. Abdul Talha", "10. Farrukh","11. Majed Tariq Shami", "12. Shami Urrahman", "13. Sheikh Arslan ", "14. Abdul Talha", "15. Farrukh","16. Majed Tariq Shami", "17. Shami Urrahman", "18. Sheikh Arslan ", "19. Abdul Talha", "20. Farrukh"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
