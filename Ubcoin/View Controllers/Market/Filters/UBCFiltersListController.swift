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
    private lazy var tableView: UBDefaultTableView = { [unowned self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        
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
        self.navigationContainer.rightTitle = "str_clear_all".localizedString()
        
        setupViews()
        tableView.update(withSectionsData: model.sections)
    }

    private func setupViews() {
        
        let viewHeight = UBCConstant.actionButtonHeight + 30
        self.view.addSubview(self.tableView)
        self.view.setAllConstraintToSubview(self.tableView, with: UIEdgeInsets(top: 0, left: 0, bottom: -viewHeight, right: 0))
        
        self.view.addSubview(self.buttonView)
        self.view.setLeadingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setTrailingConstraintToSubview(self.buttonView, withValue: 0)
        self.view.setBottomConstraintToSubview(self.buttonView, withValue: 0)
    }
    
    //MARK: - Actions
    
    @objc
    private func buttonPressed() {
        if let completion = self.completion {
            completion(model)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func rightBarButtonClick(_ sender: Any?) {
        model.clearFilters()
        tableView.reloadData()
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
            model.sortParam = UBCFilterParam(rowData: data, value: UBCFilterParam.ascSort)
        }
        
        tableView.reloadData()
    }
}

extension UBCFiltersListController: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        
        if data.name == UBCFilterType.category.rawValue {
            let controller = UBCCategoriesFilterController(selectedCategories: model.categoryFilters)
            self.navigationController?.pushViewController(controller, animated: true)
            
            controller.completion = { [weak self] selectedCategoryFilters in
                self?.model.updateCategoryFilters(selectedCategoryFilters: selectedCategoryFilters)
            }
        } else if indexPath.section == 1 {
            updateSort(data: data)
        }
    }
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        
        if indexPath.section == 1 {
            if let sortParam = model.sortParam,
                sortParam.name == data.name {
                let iconName = sortParam.value == UBCFilterParam.ascSort ? "icSortMinMax" : "icSortMaxMin"
                data.rightIcon = UIImage(named: iconName)
                data.attributedTitle = NSAttributedString(string: data.title, attributes: [.foregroundColor: UBCColor.green, .font: UBFont.titleFont])
            } else {
                data.attributedTitle = nil
                data.rightIcon = nil
            }
            
            cell.rowData = data;
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
