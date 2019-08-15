//
//  TSCBadgeScrollerViewCell.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 20/09/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

import UIKit
import ThunderTable

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    
    override init() {
        
        super.init()
        setup()
    }
    
    override var itemSize: CGSize {
        didSet {
            activeDistance = itemSize.height
        }
    }
    
    var maximumInterimSpacing: CGFloat? {
        didSet {
            invalidateLayout()
        }
    }
    
    var activeDistance: CGFloat = 0.0
    var zoomFactor: CGFloat = 0.2
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        if let collectionView = collectionView {
            itemSize = CGSize(width:collectionView.bounds.width / 3, height: collectionView.bounds.size.height)
        } else {
            itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: 120)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        if newBounds.size.height > 0 {
            itemSize = CGSize(width: newBounds.width / 3, height: newBounds.height)
        }
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect), let collectionView = collectionView else { return super.layoutAttributesForElements(in: rect) }
        
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        var finalAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attribute in superAttributes {
            
            let attributeCopy = attribute.copy() as! UICollectionViewLayoutAttributes
            
            if attribute.frame.intersects(visibleRect) {
                
                let distance = visibleRect.midX - attributeCopy.center.x
                let normalizedDistance = distance / activeDistance
                
                if abs(distance) < activeDistance {
                    let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
                    attributeCopy.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attributeCopy.zIndex = Int(round(zoom))
                }
            }
            
            finalAttributes.append(attributeCopy)
        }
        
        return finalAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        let superContentSize = super.collectionViewContentSize
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: superContentSize.height)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment: CGFloat = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2.0)
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        guard let superAttributes = super.layoutAttributesForElements(in: targetRect) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        for attribute in superAttributes {
            let itemHorizontalCenter = attribute.center.x
            
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

open class BadgeScrollerViewCell: CollectionCell {
    
    public var badges: [Badge]? {
        didSet {
            reload()
        }
    }
    
    private static let widthCalculationLabel = UILabel(frame: .zero)
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "TSCBadgeScrollerItemViewCell", bundle: Bundle(for: BadgeScrollerViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        let layout = CarouselLayout()
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.clipsToBounds = false
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges?.count ?? 0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        guard let badges = badges else { return cell }
        
        let badge = badges[indexPath.item]
        
        if let badgeCell = cell as? TSCBadgeScrollerItemViewCell {
            
            badgeCell.badgeImageView.accessibilityLabel = badge.iconAccessibilityLabel
            badgeCell.badgeImageView.image = badge.icon
            badgeCell.titleLabel.text = badge.title
            
            let hasEarnt = badge.id != nil ? BadgeController.shared.hasEarntBadge(with: badge.id!) : false
            badgeCell.badgeImageView.alpha = hasEarnt ? 1.0 : 0.44
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let badges = badges else {
            return CGSize.zero
        }
        
        let badge = badges[indexPath.item]
        return BadgeScrollerViewCell.sizeFor(badge: badge)
    }
    
    /// Calculates the size of the collection list item for the given badge
    ///
    /// - Parameter badge: The badge which will be rendered
    /// - Returns: The size the badges content will occupy
    public class func sizeFor(badge: Badge) -> CGSize {
        
        let hasEarnt = badge.id != nil ? BadgeController.shared.hasEarntBadge(with: badge.id!) : false
        
        let cellWidthPadding = TSCBadgeScrollerItemViewCell.cellPadding.left + TSCBadgeScrollerItemViewCell.cellPadding.right
        let cellHeightPadding = TSCBadgeScrollerItemViewCell.cellPadding.top + TSCBadgeScrollerItemViewCell.cellPadding.bottom
        
        guard let title = badge.title, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return CGSize(width: 76 + cellWidthPadding, height: 76 + cellHeightPadding)
        }
        
        let widthLabel = BadgeScrollerViewCell.widthCalculationLabel
        widthLabel.font = ThemeManager.shared.theme.dynamicFont(ofSize: 13, textStyle: .footnote, weight: hasEarnt ? .bold : .regular)
        widthLabel.numberOfLines = 1
        widthLabel.sizeToFit()
        
        // minimum 76 as that's what we restrict the image view's width to
        let labelPadding = TSCBadgeScrollerItemViewCell.labelPadding.left + TSCBadgeScrollerItemViewCell.labelPadding.right
        let contentWidth = min(76, widthLabel.frame.width + labelPadding)
        let width = contentWidth + cellWidthPadding
        
        let labelHeightPadding = TSCBadgeScrollerItemViewCell.labelPadding.bottom + TSCBadgeScrollerItemViewCell.labelPadding.top
        let height = cellHeightPadding + 76 + labelHeightPadding + TSCBadgeScrollerItemViewCell.labelImageSpacing + widthLabel.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let badge = badges?[indexPath.item], let badgeId = badge.id else {
            return
        }
        
        if BadgeController.shared.hasEarntBadge(with: badgeId) {
            
            let defaultShareBadgeMessage = "Badge Earnt".localised(with: "_TEST_COMPLETED_SHARE")
            
            var items: [Any] = []
            
            if let icon = badge.icon {
                items.append(icon)
            }
            
            items.append(badge.shareMessage ?? defaultShareBadgeMessage)
            
            let shareViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            shareViewController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact]
            
            let keyWindow = UIApplication.shared.keyWindow
            shareViewController.popoverPresentationController?.sourceView = keyWindow
            if let window = keyWindow {
                shareViewController.popoverPresentationController?.sourceRect = CGRect(x: window.center.x, y: window.frame.maxY, width: 100, height: 100)
            }
            shareViewController.popoverPresentationController?.permittedArrowDirections = [.up]
            
            shareViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                NotificationCenter.default.sendAnalyticsHook(.badgeShare(badge, (from: "BadgeScroller", destination: activityType, shared: completed)))
            }
            
            parentViewController?.present(shareViewController, animated: true, completion: nil)
        }
    }
}
