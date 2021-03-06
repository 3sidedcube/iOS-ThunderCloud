//
//  NumberedViewCell.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 04/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

/// `NumberedViewCell` is used to display cells in an ordered list
open class NumberedViewCell: StormTableViewCell {
	
	/// A `UILabel` that displays the number of the cell. Sits on the left hand side of the cell.
	@IBOutlet weak public var numberLabel: UILabel!
	
	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	override open func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	private func setup() {
		
		numberLabel.textColor = ThemeManager.shared.theme.freeTextColor
		numberLabel.font = ThemeManager.shared.theme.dynamicFont(ofSize: 32, textStyle: .title1)
		numberLabel.backgroundColor = .clear
		numberLabel.adjustsFontSizeToFitWidth = true
	}
}
