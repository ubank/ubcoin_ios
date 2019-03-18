//
//  UBCSellController.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import Photos

final class UBCSellController: UBViewController {
    
    private var model = UBCSellDM()
    private var item: UBCGoodDM?
    
    private var editingFinished = false
    fileprivate var isEditingMode: Bool {
        get {
            return self.item != nil
        }
    }
    
    private lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UBCConstant.cellHeight
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = ZERO_HEIGHT
        
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
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setHeightConstraintWithValue(UBCConstant.actionButtonHeight + 30)
        
        let button = HUBGeneralButton()
        button.type = HUBGeneralButtonTypeGreen
        button.title = "ui_button_done".localizedString()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        view.addSubview(button)
        view.setAllConstraintToSubview(button, with: UIEdgeInsets(top: 15, left: UBCConstant.inset, bottom: -15, right: -UBCConstant.inset))
        
        return view
    }()

    @objc
    convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
        self.model = UBCSellDM(item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isEditingMode ? "ui_button_edit" : "str_sell"

        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        let isEdit = self.item != nil
        
        let viewHeight = isEdit ? 0 : UBCConstant.actionButtonHeight + 30
        
        self.view.addSubview(self.tableView)
        self.view.setAllConstraintToSubview(self.tableView, with: UIEdgeInsets(top: 0, left: 0, bottom: -viewHeight, right: 0))
        
        if !isEdit {
            self.view.addSubview(self.buttonView)
            self.view.setLeadingConstraintToSubview(self.buttonView, withValue: 0)
            self.view.setTrailingConstraintToSubview(self.buttonView, withValue: 0)
            self.view.setBottomConstraintToSubview(self.buttonView, withValue: 0)
        } else {
            self.navigationContainer.rightTitle = "ui_button_save".localizedString()
        }
        
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
        
        guard self.model.isValidURL() else {
            UBAlert.show(withTitle: "ui_alert_title_attention", andMessage: "error_invalid_link")
            
            return
        }
        
        self.sendItem(photoRow: photoRow, id: self.item?.id)
    }
    
    @objc
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        if self.isEditingMode && !self.editingFinished {
            self.buttonPressed()
            
            return
        }
        
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
    
    private func sendItem(photoRow: UBCSellCellDM, id: String?) {
        guard var photos = photoRow.data as? [Any], photos.count > 0 else { return }
        
        self.startActivityIndicator()
        
        let myGroup = DispatchGroup()
        
        for index in 0..<photos.count {
            let photo = photos[index]
            
            if let photo = photo as? UIImage {
                myGroup.enter()
                
                UBCDataProvider.shared.uploadImage(photo) { success, url in
                    if success, let url = url {
                        photos[index] = url
                    }
                    
                    myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            var params = self.model.allFilledParams()
            
            if let id = id {
                params["id"] = id
            }
            
            params["images"] = photos
            
            UBCDataProvider.shared.sellItem(params) { [weak self] success, item in
                self?.stopActivityIndicator()
                
                guard let `self` = self, success else { return }
                
                if self.isEditingMode {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationItemChanged), object: item)
                }
                
                switch item?.status {
                case UBCItemStatusCheck,
                     UBCItemStatusChecking:
                    self.tableView.emptyView.icon.image = UIImage(named: "imgModeration")
                    self.tableView.emptyView.title.text = "str_sell_moderation_title".localizedString()
                    self.tableView.emptyView.desc.text = "str_sell_moderation_desc".localizedString()
                default:
                    self.tableView.emptyView.icon.image = UIImage(named: "imgPlaced")
                    self.tableView.emptyView.title.text = "str_sell_success_title".localizedString()
                    self.tableView.emptyView.desc.text = "str_sell_success_desc".localizedString()    
                }
                
                self.editingFinished = true
                self.tableView.emptyView.isHidden = false
                self.buttonView.isHidden = true
                self.navigationContainer.hiddenBackButton = true
                self.navigationContainer.rightImageTitle = "general_close"
                self.updateBarButtons()
                self.model.sections = []
                self.tableView.reloadData()
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
            UBCSTextViewTableViewCell.defaultCell.setContent(content: row)
            UBCSTextViewTableViewCell.defaultCell.width = UIScreen.main.bounds.size.width
            
            return UBCSTextViewTableViewCell.defaultCell.cellHeight
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
            let controller = UBCCategorySelectionController(title: row.placeholder, selected: row.sendData as? String)
            controller.completion = { [weak self] category in
                let prevCategoryID = row.sendData as? String
                let needReloadParams = category.id != prevCategoryID &&
                    (category.id == DigitalGoodsID || prevCategoryID == DigitalGoodsID)
                
                row.data = category.name
                row.sendData = category.id
                self?.model.updateRow(row)
                
                if needReloadParams {
                    self?.model.reloadParams()
                }
                self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        } else if row.type == .condition {
            let values = row.type.values
            for value in values {
                let isSelected = value.name == row.sendData as? String
                value.isSelected = isSelected
                value.accessoryType = isSelected ? .checkmark : .none
            }
            let controller = UBCSelectionController(title: row.placeholder, content: values)
            self.navigationController?.pushViewController(controller, animated: true)
            
            controller.completion = { [weak self] item in
                row.data = item.title
                row.sendData = item.name
                self?.model.updateRow(row)
                self?.tableView.reloadData()
            }
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
    
    private func updatePrice(type: UBCSellCellType?, updateRow: UBCSellCellDM) {
        guard let type = type, let amountStr = updateRow.data as? String else { return }
        
        let amount = Double(amountStr)
        
        var newRow = self.model.row(type: type)
        newRow?.placeholder = amount != nil ? "str_convertation_in_progress".localizedString() : ""
        newRow?.data = nil
        newRow?.sendData = nil
        newRow?.isEditable = amount == nil
        newRow?.reloadButtonActive = false
        if let indexPath = self.model.updateRow(newRow) {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        guard let sendAmount = amount else { return }
        
        var from = "USD"
        if updateRow.type == .priceUBC {
            from = "UBC"
        } else if updateRow.type == .priceETH {
            from = "ETH"
        }
        
        var to = "USD"
        if type == .priceUBC {
            to = "UBC"
        } else if type == .priceETH {
            to = "ETH"
        }
        
        add(UBCDataProvider.shared.convert(fromCurrency: from, toCurrency: to, withAmount: NSNumber(value: sendAmount)) { [weak self] success, amount in
            var newRow = self?.model.row(type: type)
            newRow?.placeholder = ""
            newRow?.data = amount?.stringValue
            newRow?.sendData = amount?.stringValue
            newRow?.reloadButtonActive = !success
            newRow?.isEditable = true
            if let indexPath = self?.model.updateRow(newRow) {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        })
    }
    
    private func enteredPriceRow(type: UBCSellCellType) -> UBCSellCellDM? {
        
        var row1: UBCSellCellDM?
        var row2: UBCSellCellDM?
        
        if type == .price {
            row1 = self.model.row(type: .priceUBC)
            row2 = self.model.row(type: .priceETH)
        } else if type == .priceUBC {
            row1 = self.model.row(type: .price)
            row2 = self.model.row(type: .priceETH)
        } else if type == .priceETH {
            row1 = self.model.row(type: .priceUBC)
            row2 = self.model.row(type: .price)
        }
        
        if ((row1?.data as? String) != nil) {
            return row1
        } else if ((row2?.data as? String) != nil) {
            return row2
        } else {
            return nil
        }
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
            let row = enteredPriceRow(type: updateRow.type) {
            updateRow = row
        } else {
            self.model.updateRow(updateRow)
        }
        
        if updateRow.type == .price {
            cancelAllTasks()
            updatePrice(type: .priceUBC, updateRow: updateRow)
            updatePrice(type: .priceETH, updateRow: updateRow)
        } else if updateRow.type == .priceUBC {
            cancelAllTasks()
            updatePrice(type: .price, updateRow: updateRow)
            updatePrice(type: .priceETH, updateRow: updateRow)
        } else if updateRow.type == .priceETH {
            cancelAllTasks()
            updatePrice(type: .price, updateRow: updateRow)
            updatePrice(type: .priceUBC, updateRow: updateRow)
        }
    }
}


extension UBCSellController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var row = self.model.row(type: .photo)
            if var data = row?.data as? [Any] {
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
