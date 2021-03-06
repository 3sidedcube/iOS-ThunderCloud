//
//  QuizImageSelectionViewController.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 10/08/2017.
//  Copyright © 2017 3sidedcube. All rights reserved.
//

import UIKit
import ThunderCollection
import ThunderTable

extension ImageOption: CollectionItemDisplayable {

    /// The selected colour to use for the image option when displayed in a quiz
    public static var selectedColor: UIColor = ThemeManager.shared.theme.mainColor

    /// The border width of the selection indicator around the image cell
    public static var selectedBorderWidth: CGFloat = 2

    /// The border colour to use for the image option when unselected
    public static var borderColor: UIColor = .clear

    /// The vertical spacing between the image and label on image selection cells
    public static var verticalSpacing: CGFloat = 4
    
    public var cellClass: UICollectionViewCell.Type? {
        return ImageSelectionCollectionViewCell.self
    }
    
    public func configure(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionViewController: CollectionViewController) {
        guard let imageSelectionCell = cell as? ImageSelectionCollectionViewCell else { return }

        let tintColor = cell.isSelected ? Self.selectedColor : Self.borderColor
        
        imageSelectionCell.imageView.accessibilityLabel = image?.accessibilityLabel
        imageSelectionCell.imageView.image = image?.image
        imageSelectionCell.labelContainerView.isHidden = title == nil
        imageSelectionCell.imageView.layer.borderColor = tintColor.cgColor
        imageSelectionCell.imageView.layer.borderWidth = cell.isSelected ? Self.selectedBorderWidth : 1
        
        imageSelectionCell.labelContainerView.backgroundColor = cell.isSelected ? tintColor : .clear
        imageSelectionCell.contentStackView.spacing = Self.verticalSpacing
        
        guard let title = title else {
            imageSelectionCell.label.text = nil
            imageSelectionCell.label.attributedText = nil
            return
        }
        
        var textAttributes: [NSAttributedString.Key : Any] = [
            .font: ThemeManager.shared.theme.dynamicFont(ofSize: 15, textStyle: .body, weight: cell.isSelected ? .bold : .regular),
            .foregroundColor: cell.isSelected ? .white : ThemeManager.shared.theme.darkGrayColor
        ]
        
        if UIAccessibility.buttonShapesEnabled {
            textAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        imageSelectionCell.label.attributedText = NSAttributedString(string: title, attributes: textAttributes)
    }
    
    public var remainSelected: Bool {
        return true
    }
}

open class QuizImageSelectionViewController: CollectionViewController, QuizQuestionViewController {
    
    public var delegate: QuizQuestionViewControllerDelegate?
    
    public var question: ImageSelectionQuestion?
    
    public var quiz: Quiz?
    
    public var screenName: String?
    
    open override func viewDidLoad() {
        
        // To fix an issue where isSelected is never called on off-screen cells we need to add this line, as prefetching breaks deselecting cells which are off-screen
        collectionView?.isPrefetchingEnabled = false
        collectionView?.backgroundColor = ThemeManager.shared.theme.backgroundColor
        view.backgroundColor = ThemeManager.shared.theme.backgroundColor
        
        columns = 2
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
            flowLayout.minimumLineSpacing = 22
        }
        
        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 44+32, right: 0)
        
        super.viewDidLoad()
        
        guard let question = question else { return }
        
        collectionView?.allowsMultipleSelection = question.limit > 1
        
        data = [
            
            CollectionSection(items: question.options, selectionHandler: { [weak self] (item, selected, indexPath, collectionView) -> (Void) in
                
                guard let strongSelf = self else { return }
                
                guard let _question = strongSelf.question else { return }
                
                if selected {
                    NotificationCenter.default.sendAnalyticsHook(.testSelectImageAnswer(strongSelf.quiz, _question, indexPath.item))
                } else {
                    NotificationCenter.default.sendAnalyticsHook(.testDeselectImageAnswer(strongSelf.quiz, _question, indexPath.item))
                }
                
                if selected {
                    
                    // If we've selected more answers than limit allows
                    if _question.limit > 1 && _question.answer.count > _question.limit - 1, let firstAnswer = _question.answer.first {
                        
                        // Deselect the last selected (No need to remove it from the question object as deselect handler will do this for us)
                        let removeIndexPath = IndexPath(item: firstAnswer, section: 0)
                        strongSelf.collectionView?.deselectItem(at: removeIndexPath, animated: true)
                        // Need to manually set it as un-selected as UIKit doesn't do this for us -.-
                        if let collectionView = strongSelf.collectionView {
                            strongSelf.collectionView(collectionView, didDeselectItemAt: removeIndexPath)
                        }
                    }
                    
                    // As long as it's not already selected
                    if !_question.answer.contains(indexPath.item) {
                        _question.answer.append(indexPath.item)
                    }
                    
                } else {
                    
                    if let removeIndex = _question.answer.firstIndex(of: indexPath.item) {
                        _question.answer.remove(at: removeIndex)
                    }
                }
                
                strongSelf.delegate?.quizQuestionViewController(strongSelf, didChangeAnswerFor: _question)
            })
        ]
    }
}
