//
//  ToggleableListItem.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 04/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

/// `ToggleableListItem` is an `ListItem` which when the row is selected, opens/closes up to reveal/hide more content
open class ToggleableListItem: ListItem {
	
	/// Whether the row is displaying it's hidden content
	open var isFullyVisible: Bool = false
	
	override open func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
		super.configure(cell: cell, at: indexPath, in: tableViewController)
		
		guard let toggleCell = cell as? ToggleableListItemCell else { return }
		
		toggleCell.isFullyVisible = isFullyVisible
	}
	
	override open var cellClass: UITableViewCell.Type? {
		return ToggleableListItemCell.self
	}
	
	override open func handleSelection(of row: Row, at indexPath: IndexPath, in tableView: UITableView) {
		
		if link != nil {
			super.handleSelection(of: row, at: indexPath, in: tableView)
		} else {
			isFullyVisible = !isFullyVisible
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
	
	override open var accessoryType: UITableViewCell.AccessoryType? {
		get {
			return UITableViewCell.AccessoryType.none
		}
		set {}
	}
	
	override open var selectionStyle: UITableViewCell.SelectionStyle? {
		return UITableViewCell.SelectionStyle.default
	}
}
