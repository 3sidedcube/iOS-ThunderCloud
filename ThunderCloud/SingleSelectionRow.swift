//
//  SingleSelectionRow.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 08/09/2017.
//  Copyright © 2017 3sidedcube. All rights reserved.
//

import Foundation
import ThunderTable

class SingleSelectionRow: InputTableRow {
	
	override var cellClass: AnyClass? {
		return SingleSelectionTableViewCell.self
	}
	
	var checkCornerRadius: CGFloat = 14.0
	
	private var indexPath: IndexPath?
	
	private var tableView: UITableView?
	
	init(title: String?, id: String, required: Bool = false) {
		super.init(id: id, required: required)
		self.title = title
		
		selectionHandler = {  (row, selected, indexPath, tableView) -> Void in
			guard let cell = tableView.cellForRow(at: indexPath) as? SingleSelectionTableViewCell else { return }
			cell.checkView.set(on: selected, animated: true)
			self.set(value: selected, sender: cell.checkView)
		}
		
		value = false
	}
	
	override init(id: String, required: Bool) {
		super.init(id: id, required: required)
		value = false
	}
	
	override func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
		self.indexPath = indexPath
		self.tableView = tableViewController.tableView
		
		super.configure(cell: cell, at: indexPath, in: tableViewController)
		
		guard let selectionCell = cell as? SingleSelectionTableViewCell else { return }
		
		updateTargetsAndSelectors(for: selectionCell.checkView)
		selectionCell.checkView.borderRadius = checkCornerRadius
		selectionCell.checkView.isUserInteractionEnabled = false
		
		guard let boolValue = value as? Bool else {
			selectionCell.checkView.set(on: true, animated: false)
			return
		}
		selectionCell.checkView.set(on: boolValue, animated: false)
	}
	
	override var accessoryType: UITableViewCellAccessoryType? {
		get {
			return UITableViewCellAccessoryType.none
		}
		set {}
	}
	
	override var selectionStyle: UITableViewCellSelectionStyle? {
		get {
			return UITableViewCellSelectionStyle.none
		}
		set {}
	}
	
	override var remainSelected: Bool {
		return true
	}
}