//
//  UBCSellController.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import Photos

class UBCSellController: UBViewController {
    
    var content = [UBTableViewSectionData]()
    
    private var buttonView: UIView!
    private var button: HUBGeneralButton!
    
    private(set) lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UBCConstant.cellHeight
        
        tableView.register(UBCSPhotoTableViewCell.self, forCellReuseIdentifier: UBCSPhotoTableViewCell.className)
        tableView.register(UBCSTextViewTableViewCell.self, forCellReuseIdentifier: UBCSTextViewTableViewCell.className)
        tableView.register(UBCSSelectionTableViewCell.self, forCellReuseIdentifier: UBCSSelectionTableViewCell.className)
        tableView.register(UBCSTextFieldTableViewCell.self, forCellReuseIdentifier: UBCSTextFieldTableViewCell.className)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sell"

        self.content = UBCSellDM.sellActions()

        self.setupViews()
    }

    private func setupViews() {
        let viewHeight = UBCConstant.actionButtonHeight + 30
        
        self.view.addSubview(self.tableView)
        self.view.setAllConstraintToSubview(self.tableView, with: UIEdgeInsets(top: 0, left: 0, bottom: -viewHeight, right: 0))
        
        self.buttonView = UIView()
        self.buttonView.backgroundColor = .white
        self.view.addSubview(self.buttonView)
        self.view.setLeadingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setTrailingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setBottomConstraintToSubview(self.buttonView, withValue: 0)
        self.buttonView.setHeightConstraintWithValue(UBCConstant.actionButtonHeight + 30)
        
        self.button = HUBGeneralButton()
        self.button.type = HUBGeneralButtonTypeGreen
        self.button.title = "Done"
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonView.addSubview(self.button)
        self.buttonView.setAllConstraintToSubview(self.button, with: UIEdgeInsets(top: 15, left: UBCConstant.inset, bottom: -15, right: -UBCConstant.inset))
    }
    
    @objc private func buttonPressed() {
        
    }
}


extension UBCSellController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = content[section]
        
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = content[section]
        
        
        return section.headerHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = content[section]
        
        return section.headerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = content[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBCSellCellDM else { return ZERO_HEIGHT }
        
        if row.className == UBCSTextViewTableViewCell.className {
            return UITableViewAutomaticDimension
        }
        
        return row.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = content[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBCSellCellDM else { return UBTableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.className) as? UBTableViewCell & UBCSellCellProtocol
        
        if let cell = cell {
            cell.setContent(content: row)
            cell.showBottomSeparator = !self.tableView.isLast(indexPath)
            
            if let cell = cell as? UBCSPhotoTableViewCell {
                cell.delegate = self
            }
            
            if let cell = cell as? UBCSTextViewTableViewCell {
                cell.delegate = self
            }
            
            return cell
        }
        
        return UBTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = content[indexPath.section]
        guard var row = section.rows[indexPath.row] as? UBCSellCellDM else { return }
        
        if row.type == .category, let content = row.selectContent {
            var selected: Int?
            if let selectedString = row.data as? String {
                selected = content.index(of: selectedString)
            }
            
            let controller = UBCSelectionController(title: row.placeholder, content: content, selected: selected)
            controller.completion = { [weak self] index in
                row.data = content[index]
                section.rows[indexPath.row] = row
                self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        } else if row.type == .location {
            let controller = UBCMapSelectController(title: row.placeholder)
            controller.completion = { [weak self] selectedLocation in
                row.data = selectedLocation
                section.rows[indexPath.row] = row
                self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension UBCSellController: UBCSPhotoTableViewCellDelegate {
    
    func addPhotoPressed(_ index: Int, sender: UIView) {
        let action1 = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
            self?.showImagePicker(sourceType: .camera)
        }
        
        let action2 = UIAlertAction(title: "Photo Library", style: .default) { [weak self] action in
            self?.showImagePicker(sourceType: .photoLibrary)
        }
        
        UBAlert.showActionSheet(withTitle: "Choose action", message: nil, actions: [action1, action2], sourceView: sender)
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        if sourceType == .camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .denied || status == .restricted || status == .notDetermined || UIImagePickerController.isSourceTypeAvailable(.camera) {
                UBAlert.showToEnablePermissions(withMessage: "No access to camera")
                
                return
            }
        } else {
            if PHPhotoLibrary.authorizationStatus() == .denied {
                UBAlert.showToEnablePermissions(withMessage: "No access to library")
                
                return
            }
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension UBCSellController: UBCSTextViewTableViewCellDelegate {
    
    func updateTableView() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}


extension UBCSellController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let section = content[0]
        
        if var row = section.rows.first as? UBCSellCellDM {
            if row.data as? [UIImage] == nil {
                row.data = [UIImage]()
            }
            
            if var data = row.data as? [UIImage], let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                data.append(image)
                row.data = data
            }
            
            section.rows = [row]
            
            self.tableView.reloadData()
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
