//
//  UBCFiltersListController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/3/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFiltersListController: UBViewController {

    @objc var completion: ((UBCFilterDM) -> Void)?
    
    private var model: UBCFilterDM
    private lazy var tableView: UBTableView = { [unowned self] in
        let tableView = UBTableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UBCConstant.cellHeight
        
        tableView.register(UBDefaultTableViewCell.self, forCellReuseIdentifier: "UBDefaultTableViewCell")
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
    init(model: UBCFilterDM) {
        self.model = model

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_filters".localizedString()
        
        setupViews()
    }

    private func setupViews() {
        
        let viewHeight = UBCConstant.actionButtonHeight + 30
        self.view.addSubview(self.tableView)
        self.view.setAllConstraintToSubview(self.tableView, with: UIEdgeInsets(top: 0, left: 0, bottom: -viewHeight, right: 0))
        
        self.view.addSubview(self.buttonView)
        self.view.setLeadingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setTrailingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setBottomConstraintToSubview(self.buttonView, withValue: 0)
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        gesture.delegate = self
//        self.view.addGestureRecognizer(gesture)
    }
    
    //MARK: - Actions
    
    @objc
    private func buttonPressed() {
        if let completion = self.completion {
            completion(model)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func updateSort(data: UBTableViewRowData) {
        if let sortParam = model.sortParam,
            sortParam.name == data.name {
            if sortParam.value == UBCFilterParam.ascSort {
                sortParam.value = UBCFilterParam.descSort
            } else {
                model.sortParam = nil
            }
        } else {
            model.sortParam = UBCFilterParam(rowData: data)
        }
        
        tableView.reloadData()
    }
}

extension UBCFiltersListController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.model.sections[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBTableViewRowData,
            let cell = tableView.dequeueReusableCell(withIdentifier: row.className) as? UBDefaultTableViewCell else { return UBTableViewCell() }
        
        if indexPath.section == 1 {
            if let sortParam = model.sortParam,
                sortParam.name == row.name {
                let iconName = sortParam.value == UBCFilterParam.ascSort ? "icSortMinMax" : "icSortMaxMin"
                row.rightIcon = UIImage(named: iconName)
                row.attributedTitle = NSAttributedString(string: row.title, attributes: [.foregroundColor: UBCColor.green, .font: UBFont.titleFont])
            } else {
                row.attributedTitle = nil
                row.rightIcon = nil
            }
        }
        
        cell.rowData = row
        cell.showBottomSeparator = !self.tableView.isLast(indexPath)
        
//        if let cell = cell as? UBCSPhotoTableViewCell {
//            cell.delegate = self
//        } else if let cell = cell as? UBCSTextFieldTableViewCell {
//            cell.delegate = self
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.model.sections[indexPath.section]
        guard let row = section.rows[indexPath.row] as? UBTableViewRowData else { return }
        
        if row.name == UBCFilterParam.categoryType {
            let controller = UBCCategoriesFilterController(selectedCategories: model.categoryFilters)
            self.navigationController?.pushViewController(controller, animated: true)
            
            controller.completion = { [weak self] selectedCategoryFilters in
                self?.model.updateCategoryFilters(selectedCategoryFilters: selectedCategoryFilters)
            }
        } else if indexPath.section == 1 {
            updateSort(data: row)
        }
    }
}

extension UBCFiltersListController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.superview as? UITableViewCell != nil || touch.view?.superview?.superview as? UITableViewCell != nil {
            return false
        }
        
        return true
    }
}
