//
//  QuizBadgeShowcase.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 04/07/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

/// A table row which shows a collection of badges related to the quizzes available in the application
///
/// Incomplete quizzes (or the badge attached to them) are shown slightly transparent.
///
/// Once a badge has been earnt clicking on it will open a share sheet for the user to share the badge
open class QuizBadgeShowcase: ListItem {

	/// The array of badges to be displayed in the row
	open var badges: [Badge] = []
	
	private var quizzes: [Quiz] = []
	
	private var completedQuizObserver: NSObjectProtocol?
	
	deinit {
		if let completedQuizObserver = completedQuizObserver {
			NotificationCenter.default.removeObserver(completedQuizObserver)
		}
	}
	
	public required init(dictionary: [AnyHashable : Any]) {
		
		super.init(dictionary: dictionary)
		
		guard let quizzesArray = dictionary["quizzes"] as? [String] else { return }
		
		quizzesArray.forEach { (quizURL) in
			
			guard let pageURL = URL(string: quizURL) else { return }
			guard let quiz = StormGenerator.quiz(for: pageURL) else { return }
			
			if let badge = quiz.badge {
				badges.append(badge)
			}
			
			quizzes.append(quiz)
		}
		
		completedQuizObserver = NotificationCenter.default.addObserver(forName: QUIZ_COMPLETED_NOTIFICATION, object: nil, queue: .main, using: { [weak self] (notification) in
			
			self?.parentViewController?.tableView?.reloadData()
		})
	}
	
	override open var cellClass: UITableViewCell.Type? {
		
		if let cellClass = StormObjectFactory.shared.class(for: NSStringFromClass(QuizBadgeCollectionCell.self)) as? UITableViewCell.Type {
			return cellClass
		} else {
			return QuizBadgeCollectionCell.self
		}
	}
    
    var cellItems: [CollectionCellDisplayable]? {
        return badges.map({ (badge) -> QuizBadge in
            return QuizBadge(badge: badge, quiz: quizzes.first(where: { $0.id == badge.id }))
        })
    }
	
	override open func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
		super.configure(cell: cell, at: indexPath, in: tableViewController)
		
		guard let scrollerCell = cell as? CollectionCell else { return }
		
        scrollerCell.items = cellItems
        scrollerCell.clipsToBounds = false
        scrollerCell.contentView.clipsToBounds = false
        scrollerCell.collectionView.clipsToBounds = false
	}
	
	override open var accessoryType: UITableViewCell.AccessoryType? {
		get {
			return UITableViewCell.AccessoryType.none
		}
		set {}
	}
	
	override open var selectionStyle: UITableViewCell.SelectionStyle? {
		get {
			return UITableViewCell.SelectionStyle.none
		}
		set {}
	}
	
	override open var useNibSuperclass: Bool {
		return false
	}
    
    open override var displaySeparators: Bool {
        get {
            return false
        }
        set { }
    }
	
	override open var estimatedHeight: CGFloat? {
		return 192
	}
	
	override open func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
        let itemSizes = cellItems?.compactMap({ CollectionItemViewCell.size(for: $0) }).sorted { (size1, size2) -> Bool in
            size1.height > size2.height
        }
        guard let maxSize = itemSizes?.first else { return estimatedHeight }
        return maxSize.height
	}
}
