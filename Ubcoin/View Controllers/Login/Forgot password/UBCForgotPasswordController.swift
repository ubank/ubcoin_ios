//
//  UBCForgotPasswordController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 31.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCForgotPasswordController: UBViewController {

    @IBOutlet weak var info: HUBLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot password"
        self.info.textColor = UBColor.titleColor
    }
    
    @IBAction func sendEmail() {
        self.navigationController?.popViewController(animated: true)
    }
}
