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

        self.title = "str_forgot_password"
        self.view.backgroundColor = UIColor.white
        self.info.textColor = UBColor.titleColor
        self.email.placeholder = "str_email".localizedString()
        self.email.returnKeyType = .done
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmail() {
        
        if (self.email.text?.isEmail)! {
            self.startActivityIndicator()
            UBCDataProvider.shared.sendVerificationCode(toEmail: self.email.text) { [weak self] success in
                self?.stopActivityIndicator()
                if (success) {
                    self?.navigationController?.pushViewController(UBCResetPasswordController(email: self?.email.text), animated: true)
                }
            }
        }
        else {
            UBCToast.showErrorToast(withMessage: "str_wrong_email")
        }
    }
}

extension UBCForgotPasswordController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
