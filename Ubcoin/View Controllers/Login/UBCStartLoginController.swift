//
//  UBCStartLoginController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 28.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCStartLoginController: UBViewController {
    
    @IBOutlet weak var infoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoButton.titleColor = UBCColor.green
        self.infoButton.titleLabel?.font = UBFont.descFont
        
        self.navigationContainer?.hiddenNavigation = true
    }
    
    @IBAction func showLogin() {
        self.navigationController?.pushViewController(UBCLoginController(), animated: true)
    }
    
    @IBAction func showRegistration() {
        self.navigationController?.pushViewController(UBCSignUpController(), animated: true)
    }
}
