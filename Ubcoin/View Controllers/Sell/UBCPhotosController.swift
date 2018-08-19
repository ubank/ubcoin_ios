//
//  UBCPhotosController.swift
//  Ubcoin
//
//  Created by Aidar on 18/08/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import Photos

final class UBCPhotosController: UBViewController {
    
    private var model: UBCSellDM?
    private var row: UBCSellCellDM?
    private var startIndex = 0
    
    private var selectedIndex = 0 {
        didSet {
            var image: UIImage?
            if let array = self.row?.data as? [UIImage], array.count > self.selectedIndex, self.selectedIndex >= 0 {
                image = array[self.selectedIndex]
            } else {
                image = nil
            }
            
            self.imageView.image = image
            self.tableView.reloadData()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageView, self.bottomContainer])
        
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        imageView.addSubview(view)
        imageView.addConstraints(toFillSubview: view)
        
        return imageView
    }()
    
    private lazy var bottomContainer: UIView = { [unowned self] in
        let view = UIView()
        
        view.backgroundColor = .white
        view.setHeightConstraintWithValue(170)
        
        view.addSubview(self.tableView)
        view.setLeadingConstraintToSubview(self.tableView, withValue: 0)
        view.setTrailingConstraintToSubview(self.tableView, withValue: 0)
        view.setTopConstraintToSubview(self.tableView, withValue: 0)
        
        view.addSubview(self.deleteButton)
        view.setCenterXConstraintToSubview(self.deleteButton)
        view.setBottomConstraintToSubview(self.deleteButton, withValue: -25)
        
        view.addTopSeparator()
        
        return view
    }()
    
    private lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(UBCSPhotoTableViewCell.self, forCellReuseIdentifier: UBCSPhotoTableViewCell.className)
        
        tableView.setHeightConstraintWithValue(100)
        
        return tableView
    }()
    
    private lazy var deleteButton: UIButton = { [unowned self] in
        let button = UBButton()
        
        button.image = UIImage(named: "general_delete")
        button.addTarget(self, action: #selector(removePhoto), for: .touchUpInside)
        
        return button
    }()
    
    convenience init(model: UBCSellDM, index: Int) {
        self.init()
        
        self.model = model
        self.row = model.photoRow()
        self.startIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationContainer.clearColorNavigation = true
        self.navigationContainer.buttonsImageColor = .white
        
        self.setupViews()
        
        self.selectedIndex = self.startIndex
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.stackView)
        self.view.addConstraints(toFillSubview: self.stackView)
    }
    
    @objc
    private func removePhoto() {
        guard var data = self.row?.data as? [UIImage], self.selectedIndex >= 0, data.count > self.selectedIndex else { return }
        
        data.remove(at: self.selectedIndex)
        self.row?.data = data
        self.selectedIndex = self.selectedIndex - 1
        self.model?.updateRow(self.row)
    }
}


extension UBCPhotosController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.row?.height ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = self.row, let cell = tableView.dequeueReusableCell(withIdentifier: row.className) as? UBCSPhotoTableViewCell else { return UBTableViewCell() }
        
        cell.setContent(content: row)
        cell.delegate = self
        cell.indexHighlited = self.selectedIndex
        
        return cell
    }
}


extension UBCPhotosController: UBCSPhotoTableViewCellDelegate {
    
    func addPhotoPressed(_ index: Int?, sender: UIView) {
        if let index = index {
            self.selectedIndex = index
            
            return
        }
        
        let action1 = UIAlertAction(title: "str_sell_camera".localizedString(), style: .default) { [weak self] action in
            self?.showImagePicker(sourceType: .camera)
        }
        
        let action2 = UIAlertAction(title: "str_sell_library".localizedString(), style: .default) { [weak self] action in
            self?.showImagePicker(sourceType: .photoLibrary)
        }
        
        UBAlert.showActionSheet(withTitle: "str_sell_choose".localizedString(), message: nil, actions: [action1, action2], sourceView: sender)
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        if sourceType == .camera {
            if !HUBPermissions.checkPermission(.camera) {
                return
            }
        } else {
            if PHPhotoLibrary.authorizationStatus() == .denied {
                UBAlert.showToEnablePermissions(withMessage: "ui_alert_message_error_no_access".localizedString())
                
                return
            }
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension UBCPhotosController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage, var data = self.row?.data as? [UIImage] else { return }
        
        data.append(image)
        self.row?.data = data
        self.selectedIndex = data.count - 1
        self.model?.updateRow(self.row)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
