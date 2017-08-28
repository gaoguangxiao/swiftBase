//
//  UserRegViewController.swift
//  EagleFastSwift
//
//  Created by ggx on 2017/7/20.
//  Copyright © 2017年 高广校. All rights reserved.
//

import UIKit
class UserRegViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func RegisterMethod(_ sender: UIButton) {
        
//        print(db!)
        self.navigationController?.popToRootViewController(animated: true)
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
