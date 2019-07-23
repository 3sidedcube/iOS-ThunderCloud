//
//  EmbeddedLinksListItem.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 04/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

#warning("Add tests.")

/// Subclass of `ListItem` that allows embedded links, each link is displayed as a `UIButton`
open class EmbeddedLinksListItem: ListItem {

	/// An array of `TSCLink`s to display in the list item
	public var embeddedLinks: [StormLink]?
	
	required public init(dictionary: [AnyHashable : Any]) {
		
		super.init(dictionary: dictionary)
		
		guard let linkDictionaries = dictionary["embeddedLinks"] as? [[AnyHashable : Any]] else {
			return
		}
		
		embeddedLinks = linkDictionaries.compactMap({ (dictionary) -> StormLink? in
			return StormLink(dictionary: dictionary)
		})
	}
	
	override open var cellClass: UITableViewCell.Type? {
		return EmbeddedLinksListItemCell.self
	}
	
	override open func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
		super.configure(cell: cell, at: indexPath, in: tableViewController)
		guard let embeddedLinksCell = cell as? EmbeddedLinksListItemCell else {
			return
		}
		
		// If we have no links make sure to get rid of the spacing on mainStackView
		if let links = embeddedLinks, links.count > 0 {
			embeddedLinksCell.mainStackView?.spacing = 12
		} else {
			embeddedLinksCell.mainStackView?.spacing = 0
		}
		
		embeddedLinksCell.links = embeddedLinks
        embeddedLinksCell.contentStackView?.isHidden = (title == nil || title!.isEmpty) && (subtitle == nil || subtitle!.isEmpty) && image == nil && imageURL == nil
	}
}
