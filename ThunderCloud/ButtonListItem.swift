//
//  ButtonListItem.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 04/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

/// `ButtonListItem` is a subclass of `ListItem`, it represents an item with a single button on it.
/// It is rendered out as an `StormTableViewCell`
open class ButtonListItem: ListItem {

	/// The target to call when the button is pressed
	public var target: AnyObject?
	
	/// The selector to call on target when the button is selected
	public var selector: Selector?
	
	/// Creates a new instance with a target and selector
	///
	/// - Parameters:
	///   - target: The object to have selector called on upon pressing button
	///   - selector: The selector to call on target when button pressed
	public init(target: AnyObject?, selector: Selector?) {
		
		super.init(dictionary: [:])
		self.target = target
		self.selector = selector
	}
	
	/// Creates a new instance with a custom title and button title
	///
	/// - Parameters:
	///   - title: The title to be displayed in the cell
	///   - buttonTitle: The title to be displayed on the button
	///   - target: The object to have selector called on upon pressing button
	///   - selector: The selector to call on target when button pressed
	public convenience init(title: String?, buttonTitle: String?, target: AnyObject?, selector: Selector?) {
		
		self.init(target: target, selector: selector)
		
		self.title = title
		let link = StormLink()
		link.title = buttonTitle
		
		embeddedLinks = [link]
	}
	
    /// Given a Storm object dictionary, initialises a ButtonListItem.
    ///
    /// - Parameter dictionary: A Storm object dictionary.
	public required init(dictionary: [AnyHashable : Any]) {
		super.init(dictionary: dictionary)
	}
    
    /// Given a Storm object dictionary, initialises a ButtonListItem.
    /// If required, a StormLanguageController instance can be injected.
    ///
    /// - Parameters:
    ///   - dictionary: A Storm object dictionary.
    ///   - languageController: A StormLanguageController instance. Defaults to `.shared`. Only override when running from unit tests - leave as `.shared` for production use.
    public override init(dictionary: [AnyHashable: Any], languageController: StormLanguageController = StormLanguageController.shared) {
        super.init(dictionary: dictionary, languageController: languageController)
    }
    
    /// When given a Storm object dictionary, and a StormLanguageController instance,
    /// configures the row based on the contents of the dictionary.
    ///
    /// - Parameters:
    ///   - dictionary: A Storm object dictionary.
    ///   - languageController: A StormLanguageController instance.
    public override func configure(with dictionary: [AnyHashable: Any], languageController: StormLanguageController) {
        super.configure(with: dictionary, languageController: languageController)
        
        guard let buttonDict = dictionary["button"] as? [AnyHashable : Any],
            let linkDict = buttonDict["link"] as? [AnyHashable : Any],
            let link = StormLink(dictionary: linkDict, languageController: languageController) else {
                return
        }
        
        if link.title == nil, let titleDict = buttonDict["title"] as? [AnyHashable : Any] {
            link.title = languageController.string(for: titleDict)
        }
        
        var links = embeddedLinks ?? []
        links.insert(link, at: 0)
        embeddedLinks = links
    }
	
	override open func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
		super.configure(cell: cell, at: indexPath, in: tableViewController)
		
		guard let embeddedCell = cell as? StormTableViewCell else {
			return
		}
		guard let links = embeddedCell.links, links.count == 1 else {
			return
		}
			
		embeddedCell._target = target
		embeddedCell.selector = selector
	}
	
	override open var accessoryType: UITableViewCell.AccessoryType? {
		get {
			return UITableViewCell.AccessoryType.none
		}
		set {}
	}
	
	override open var selectionStyle: UITableViewCell.SelectionStyle? {
		return UITableViewCell.SelectionStyle.none
	}
}
