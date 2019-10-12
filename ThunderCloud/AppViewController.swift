//
//  AppViewController.swift
//  ThunderCloud
//
//  Created by Matthew Cheetham on 01/02/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import UIKit
import os.log

/**
 `TSCAppViewController` is the root class of any Storm CMS driven app. By initialising this class, Storm builds the entire app defined by the JSON files included in the bundle delivered by Storm.
 
 Allocate an instance of this class and set it to the root view controller of the `UIWindow`.
 
 */
open class AppViewController: SplitViewController {
    
    private var appViewControllerLog = OSLog(subsystem: "com.threesidedcube.ThunderCloud", category: "AppViewController")
    
    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers.first
    }
    
    public required init() {
		
        super.init()
        
        StormLanguageController.shared.reloadLanguagePack()
        
        guard let appFileURL = ContentController.shared.fileUrl(forResource: "app", withExtension: "json", inDirectory: nil) else {
            os_log("Failed to initialise as app.json missing from bundle", log: appViewControllerLog, type: .error)
            return
        }
                    
        let appJSONObject = try? JSONSerialization.jsonObject(with: appFileURL)
        guard let _appJSONObject = appJSONObject as? [String: AnyObject] else {
            os_log("app.json is not a valid JSON file", log: appViewControllerLog, type: .error)
            return
        }
            
        guard let vectorPath = _appJSONObject["vector"] as? String else {
            os_log("Vector key is missing in app.json file", log: appViewControllerLog, type: .error)
            return
        }
        
        guard let vectorURL = URL(string: vectorPath) else {
            os_log("Vector key in app.json is not a valid URL", log: appViewControllerLog, type: .error)
            return
        }
				
        guard let stormView = StormGenerator.viewController(URL: vectorURL) else {
            os_log("Failed to initialise a view controller for page at path: %@", log: appViewControllerLog, type: .error, vectorURL.absoluteString)
            return
        }
        
        var launchViewControllers: [UIViewController] = []
        
        // The accordion storm view needs to be wrapped in a UINavigationController otherwise no navigation works from within it!
        if let accordionStormView = stormView as? AccordionTabBarViewController {
            launchViewControllers.append(UINavigationController(rootViewController: accordionStormView))
        } else {
            launchViewControllers.append(stormView)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad, let tabbedPageCollection = stormView as? TabbedPageCollection, let placeholder = tabbedPageCollection.placeholders.first {
            
            let placeholderVC = PlaceholderViewController(placeholder: placeholder)
            launchViewControllers.append(placeholderVC)
        }
        
        viewControllers = launchViewControllers
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
