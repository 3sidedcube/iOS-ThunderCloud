//
//  HeaderListItem.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 05/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit

/// Subclass of `ImageListItem` which displays an image header with a slight dark overlay and centered title text and subtitle
class HeaderListItem: ImageListItem {
	
	required init(dictionary: [AnyHashable : Any]) {
		
		super.init(dictionary: dictionary)
		titleTextColor = .white
		detailTextColor = .white
	}

	override var cellClass: AnyClass? {
		return HeaderListItemCell.self
	}
}
