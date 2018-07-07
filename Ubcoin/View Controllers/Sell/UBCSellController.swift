//
//  UBCSellController.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSellController: UBViewController {
    
    var content = [UBTableViewSectionData]()
    
    private(set) lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UBCSPhotoTableViewCell.self, forCellReuseIdentifier: UBCSPhotoTableViewCell.className)
        tableView.register(UBCSTextFieldTableViewCell.self, forCellReuseIdentifier: UBCSTextFieldTableViewCell.className)
        tableView.register(UBCSSelectionTableViewCell.self, forCellReuseIdentifier: UBCSSelectionTableViewCell.className)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sell"

        self.content = UBCSellDM.sellActions()

        self.setupViews()
    }

    func setupViews() {
        self.view.addSubview(self.tableView)
        self.view.addConstraints(toFillSubview: self.tableView)
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
            
            return cell
        }
        
        return UBTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
    }
}


extension UBCSellController: UBCSPhotoTableViewCellDelegate {
    
    func addPhotoPressed(_ index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension UBCSellController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let section = content[0]
        
        if var row = section.rows.first as? UBCSellCellDM {
            if row.data as? [UIImage] == nil {
                row.data = [UIImage]()
            }
            
            if var data = row.data as? [UIImage], let image = info[.originalImage] as? UIImage {
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
