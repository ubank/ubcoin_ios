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
    
    var model = UBCSellDM()
    var task: URLSessionDataTask?
    
    private var buttonView: UIView!
    private var button: HUBGeneralButton!
    
    private(set) lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UBCConstant.cellHeight
        
        tableView.emptyView.icon.image = UIImage(named: "imgPlaced")
        tableView.emptyView.title.text = "str_sell_success_title".localizedString()
        tableView.emptyView.desc.text = "str_sell_success_desc".localizedString()
        
        tableView.register(UBCSMapTableViewCell.self, forCellReuseIdentifier: UBCSMapTableViewCell.className)
        tableView.register(UBCSPhotoTableViewCell.self, forCellReuseIdentifier: UBCSPhotoTableViewCell.className)
        tableView.register(UBCSTextViewTableViewCell.self, forCellReuseIdentifier: UBCSTextViewTableViewCell.className)
        tableView.register(UBCSSelectionTableViewCell.self, forCellReuseIdentifier: UBCSSelectionTableViewCell.className)
        tableView.register(UBCSTextFieldTableViewCell.self, forCellReuseIdentifier: UBCSTextFieldTableViewCell.className)
        
        return tableView
    }()

    @objc
    convenience init(item: UBCGoodDM) {
        self.init()
        
        model = UBCSellDM.init(item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "str_sell"

        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
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
        self.button.title = "ui_button_done".localizedString()
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonView.addSubview(self.button)
        self.buttonView.setAllConstraintToSubview(self.button, with: UIEdgeInsets(top: 15, left: UBCConstant.inset, bottom: -15, right: -UBCConstant.inset))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc
    private func buttonPressed() {
        guard self.model.isAllParamsNotEmpty(),
            let photoRow = self.model.row(type: .photo) else {
            UBAlert.show(withTitle: "ui_alert_title_attention", andMessage: "error_all_fields_empty")
            
            return
        }
        
        guard let user = UBCUserDM.loadProfile(),
            user.authorizedInTg else {
                self.startActivityIndicator()
                UBCDataProvider.shared.registerInChat { [weak self] success, authorizedInTg, url, appURL in
                    self?.stopActivityIndicator()
                    
                    if authorizedInTg {
                        self?.sendItem(photoRow: photoRow)
                    } else {
                        UBAlert.show(withTitle: "",
                                     andMessage: "str_ubcoin_is_going_to_open_telegram".localizedString(),
                                     withCompletionBlock: {
                                        self?.navigationController?.pushViewController(UBCChatController(url: url, appURL: appURL), animated: true)
                        })
                    }
                }
                
                return
        }
        
        self.sendItem(photoRow: photoRow)
    }
    
    @objc
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        self.tableView.emptyView.isHidden = true
        self.buttonView.isHidden = false
        self.navigationContainer.rightImageTitle = nil
        self.updateBarButtons()
        self.model.sections = UBCSellDM.sellActions()
        self.tableView.reloadData()
        
        if let navigation = self.navigationController as? UBNavigationController {
            navigation.pop(to: UBCMarketController(), animated: true)
        }
    }
    
    private func sendItem(photoRow: UBCSellCellDM) {
        guard let photos = photoRow.data as? [UIImage], photos.count > 0 else { return }
        
        self.startActivityIndicator()
        
        let myGroup = DispatchGroup()
        
        var images = [String]()
        
        for index in 0..<photos.count {
            myGroup.enter()
            
            let photo = photos[index]
            
            UBCDataProvider.shared.uploadImage(photo) { success, url in
                if success {
                    if let url = url {
                        images.append(url)
                    }
                    
                    myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            var params = self.model.allFilledParams()
            
            params["images"] = images
            
            UBCDataProvider.shared.sellItem(params) { [weak self] success in
                self?.stopActivityIndicator()
                
                if success {
                    self?.tableView.emptyView.isHidden = false
                    self?.buttonView.isHidden = true
                    self?.navigationContainer.rightImageTitle = "general_close"
                    self?.updateBarButtons()
                    self?.model.sections = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
}


extension UBCSellController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.model.sections[section]
        
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.model.sections[section]
        
        return section.headerHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.model.sections[section]
        
        return section.headerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = self.model.sections[section]
        
        return section.footerHeight
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = self.model.sections[section]
        
        return section.footerTitle
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.tableView(tableView, titleForFooterInSection: section) == nil {
            return UIView()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.model.sections[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBCSellCellDM else { return ZERO_HEIGHT }
        
        if row.className == UBCSTextViewTableViewCell.className {
            return UITableViewAutomaticDimension
        }
        
        return row.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.model.sections[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBCSellCellDM, let cell = tableView.dequeueReusableCell(withIdentifier: row.className) as? UBTableViewCell & UBCSellCellProtocol else { return UBTableViewCell() }
        
        cell.setContent(content: row)
        cell.showBottomSeparator = !self.tableView.isLast(indexPath)
        
        if let cell = cell as? UBCSPhotoTableViewCell {
            cell.delegate = self
        } else if let cell = cell as? UBCSTextViewTableViewCell {
            cell.delegate = self
        } else if let cell = cell as? UBCSTextFieldTableViewCell {
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.model.sections[indexPath.section]
        guard var row = section.rows[indexPath.row] as? UBCSellCellDM else { return }
        
        if row.type == .category {
            let controller = UBCSelectionController(title: row.placeholder, selected: row.sendData as? String)
            controller.completion = { [weak self] category in
                row.data = category.name
                row.sendData = category.id
                self?.model.updateRow(row)
                self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        } else if row.type == .location {
            let controller = UBCMapSelectController(title: row.placeholder)
            controller.completion = { [weak self] selectedLocation, location in
                row.data = selectedLocation
                row.sendData = ["text": selectedLocation, "longPoint": location.coordinate.longitude, "latPoint": location.coordinate.latitude]
                self?.model.updateRow(row)
                self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension UBCSellController: UBCSPhotoTableViewCellDelegate {
    
    func addPhoto(_ index: Int?, sender: UIView) {
        if let index = index {
            self.navigationController?.pushViewController(UBCPhotosController(model: self.model, index: index), animated: true)
            
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
    
    func deletePhoto(_ index: Int?, sender: UIView) {
        guard let index = index else { return }
        
        self.model.removePhoto(index: index)
        self.tableView.reloadData()
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


extension UBCSellController: UBCSTextCellDelegate {
    
    func updateTableView() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func updatedRow(_ row: UBCSellCellDM) {
        var updateRow = row
        
        if updateRow.reloadButtonActive,
            let row = self.model.row(type: updateRow.type == .price ? .priceUBC : .price) {
            updateRow = row
        } else {
            self.model.updateRow(updateRow)
        }
        
        var updatedType: UBCSellCellType?
        var from = "UBC"
        var to = "USD"
        
        if updateRow.type == .price {
            updatedType = .priceUBC
            swap(&from, &to)
        } else if updateRow.type == .priceUBC {
            updatedType = .price
        }
        
        guard let newType = updatedType, let amountStr = updateRow.data as? String else { return }
        
        let amount = Double(amountStr)
        
        var newRow = self.model.row(type: newType)
        newRow?.placeholder = amount != nil ? "str_convertation_in_progress".localizedString() : ""
        newRow?.data = nil
        newRow?.sendData = nil
        newRow?.isEditable = amount == nil
        newRow?.reloadButtonActive = false
        if let indexPath = self.model.updateRow(newRow) {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
        
        guard let sendAmount = amount else { return }
        
        self.task?.cancel()
        self.task = UBCDataProvider.shared.convert(fromCurrency: from, toCurrency: to, withAmount: NSNumber(value: sendAmount)) { [weak self] success, amount in
            var newRow = self?.model.row(type: newType)
            newRow?.placeholder = ""
            newRow?.data = amount?.stringValue
            newRow?.sendData = amount?.stringValue
            newRow?.reloadButtonActive = !success
            newRow?.isEditable = true
            if let indexPath = self?.model.updateRow(newRow) {
                self?.tableView.reloadSections([indexPath.section], with: .none)
            }
        }
    }
}


extension UBCSellController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var row = self.model.row(type: .photo)
            if var data = row?.data as? [UIImage] {
                data.append(image)
                row?.data = data
            }
            self.model.updateRow(row)
            self.tableView.reloadData()
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension UBCSellController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.superview as? UITableViewCell != nil || touch.view?.superview?.superview as? UITableViewCell != nil {
            return false
        }
        
        return true
    }
}
