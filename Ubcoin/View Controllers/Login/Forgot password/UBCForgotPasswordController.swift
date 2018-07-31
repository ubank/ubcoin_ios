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
    @IBOutlet weak var email: UBFloatingPlaceholderTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot password"
        self.info.textColor = UBColor.titleColor
        self.email.placeholder = "Email"
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmail() {
        
        if (self.email.text?.isEmail)! {
            UBCDataProvider.shared.resendPassword(forEmail: self.email.text) { [weak self] success  in
                if (success) {
                    UBCToast.showErrorToast(withMessage: "An email with your new password has been successfully sent")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            UBCToast.showErrorToast(withMessage: "Wrong email")
        }
    }
}
