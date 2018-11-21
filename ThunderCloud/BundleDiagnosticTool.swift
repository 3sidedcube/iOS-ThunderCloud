//
//  BundleDiagnosticsTool.swift
//  ThunderCloud
//
//  Created by Matthew Cheetham on 15/11/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

import Foundation
import UIKit
import Baymax
import UserNotifications

class BundleDiagnosticTool: DiagnosticTool {
    var displayName: String {
        return "Bundles"
    }
    
    func launchUI(in navigationController: UINavigationController) {
        
        let diagView = BundleDiagnosticTableViewController(style: .grouped)
        navigationController.show(diagView, sender: self)
    }
}

class BundleDiagnosticTableViewController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .long
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Bundle Information"
        tableView.register(UINib(nibName: "InformationTableViewCell", bundle: Bundle(for: BundleDiagnosticTableViewController.self)), forCellReuseIdentifier: "informationRow")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == BundleDiagnosticSection.buildInformationSection.rawValue {
            return 1
        } else if section == BundleDiagnosticSection.timestampSection.rawValue {
            return 2
        } else if section == BundleDiagnosticSection.actionSection.rawValue {
            return 2
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationRow", for: indexPath) as! InformationTableViewCell
        
        cell.keyLabel.text = nil
        cell.keyLabel.textColor = .black
        cell.valueLabel.text = nil
        
        if indexPath.section == BundleDiagnosticSection.buildInformationSection.rawValue {
            
            if indexPath.row == BuildInformationDiagnosticRows.buildDateRow.rawValue {
                
                cell.keyLabel.text = "Date"
                
                let fm = FileManager.default
                
                if let excPath = Bundle.main.executablePath {
                    
                    do {
                        if let creationDate = try fm.attributesOfItem(atPath: excPath)[FileAttributeKey.creationDate] as? Date {
                            cell.valueLabel.text = dateFormatter.string(from: creationDate)
                        }
                    } catch {
                        cell.valueLabel.text = "Unknown"
                    }
                }
            }
        } else if indexPath.section == BundleDiagnosticSection.timestampSection.rawValue {
            
            if indexPath.row == BundleTimestampDiagnosticRows.bundleTimestampRow.rawValue {
                
                cell.keyLabel.text = "Bundle"
                
                if let bundleManifestURL = ContentController.shared.bundleDirectory?.appendingPathComponent("manifest.json"){
                    
                    do {
                        
                        let data = try Data(contentsOf: bundleManifestURL)
                        
                        guard let manifest = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any] else {
                            throw ContentControllerError.defaultError
                        }
                        
                        guard let timeStamp = manifest["timestamp"] as? TimeInterval else {
                            throw ContentControllerError.defaultError
                        }
                        
                        cell.valueLabel.text = "\(dateFormatter.string(from: Date(timeIntervalSince1970: timeStamp)))\n(\(String(timeStamp)))"
                        
                    } catch {
                        cell.valueLabel.text = "Not found"
                    }
                }
            } else if indexPath.row == BundleTimestampDiagnosticRows.deltaTimestampRow.rawValue {
                
                cell.keyLabel.text = "Delta"
                
                if let bundleManifestURL = ContentController.shared.deltaDirectory?.appendingPathComponent("manifest.json"){
                    
                    do {
                        
                        let data = try Data(contentsOf: bundleManifestURL)
                        
                        guard let manifest = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any] else {
                            throw ContentControllerError.defaultError
                        }
                        
                        guard let timeStamp = manifest["timestamp"] as? TimeInterval else {
                            throw ContentControllerError.defaultError
                        }
                        
                        cell.valueLabel.text = "\(dateFormatter.string(from: Date(timeIntervalSince1970: timeStamp)))\n(\(String(timeStamp)))"
                        
                    } catch {
                        cell.valueLabel.text = "Not found"
                    }
                }
            }
        } else if indexPath.section == BundleDiagnosticSection.actionSection.rawValue {
            
            if indexPath.row == ActionDiagnosticRows.deleteDeltaRow.rawValue {
                
                cell.keyLabel.text = "Delete Delta Bundle"
                cell.keyLabel.textColor = .red
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == ActionDiagnosticRows.developerModeRow.rawValue {
                
                if DeveloperModeController.appIsInDevMode {
                    cell.keyLabel.text = "Revert to live bundle"
                } else {
                    cell.keyLabel.text = "Switch to test bundle"
                }
                
                cell.accessoryType = .disclosureIndicator
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == BundleDiagnosticSection.buildInformationSection.rawValue {
            return "Build Information"
        } else if section == BundleDiagnosticSection.timestampSection.rawValue {
            return "Timestamps"
        } else if section == BundleDiagnosticSection.actionSection.rawValue {
            return "Actions"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == BundleDiagnosticSection.actionSection.rawValue {
            
            if indexPath.row == ActionDiagnosticRows.deleteDeltaRow.rawValue {
                
                let confirmationAlert = UIAlertController(title: "Delete Delta Bundle", message: "This will delete the delta bundle and cannot be undone. The app will be killed after this is completed. Are you sure you wish to proceed?", preferredStyle: .alert)
                confirmationAlert.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
                    
                    guard let deltaDirectory = ContentController.shared.deltaDirectory else {
                        return
                    }
                    
                    ContentController.shared.removeBundle(in: deltaDirectory)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Delta Deleted"
                    content.body = "Tap here to re-launch the app"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    // Create the request
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    
                    // Schedule the request with the system.
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request, withCompletionHandler: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        exit(-1)
                    }
                    
                }))
                
                confirmationAlert.addAction(UIAlertAction(title: "No, go back", style: .cancel, handler: nil))
                
                present(confirmationAlert, animated: true, completion: nil)
                
            } else if indexPath.row == ActionDiagnosticRows.developerModeRow.rawValue {
                
                if DeveloperModeController.appIsInDevMode {
                    UserDefaults.standard.set(false, forKey: "developer_mode_enabled")
                    DeveloperModeController.shared.switchToLive()
                } else {
                    UserDefaults.standard.set(true, forKey: "developer_mode_enabled")
                    DeveloperModeController.shared.loginToDeveloperMode()
                }
            }
        }
        
    }
    
}

enum BundleDiagnosticSection: Int {
    case buildInformationSection = 0
    case timestampSection = 1
    case actionSection = 2
}

enum BuildInformationDiagnosticRows: Int {
    case buildDateRow = 0
}

enum BundleTimestampDiagnosticRows: Int {
    case bundleTimestampRow = 0
    case deltaTimestampRow = 1
}

enum ActionDiagnosticRows: Int {
    case deleteDeltaRow = 0
    case developerModeRow = 1
}
