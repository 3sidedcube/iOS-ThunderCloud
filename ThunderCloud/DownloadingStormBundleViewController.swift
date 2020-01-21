//
//  DownloadingStormBundleViewController.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 21/11/2016.
//  Copyright © 2016 threesidedcube. All rights reserved.
//

import UIKit
import ThunderBasics

/// A more customisable UIProgressView
@IBDesignable
class ProgressView: UIView {
    
    @IBInspectable var progress: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var trackTintColor: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //// Progress Active Drawing
        let progressActivePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: CGFloat(progress) * rect.width, height: rect.height), cornerRadius: 0)
        tintColor.setFill()
        progressActivePath.fill()
    }
}

/// A class for measuring the download process of a file or data
class DownloadProgress {
    
    /// How many seconds of data should be used in rolling average for speed
    var averageTimeWindow: TimeInterval = 4
    
    /// Roughly how often a sample should be taken of the download speed
    var sampleSpacing: TimeInterval = 0.5
    
    /// The total byte count of data to be downloaded
    var totalBytes: Int
    
    
    /// A string describing the progress of the file download in the format: "{downloaded}/{total} downloaded"
    var progressString: String {
        get {
            
            let display = ["bytes", "KB", "MB", "GB", "TB", "PB"]
            var totalValue: Double = Double(totalBytes)
            var downloadedValue: Double = Double(_bytesDownloaded)
            
            var type = 0
            
            while (totalValue > 1024) {
                totalValue /= 1024
                downloadedValue /= 1024
                type = type + 1
            }
            
            return "\(String(format:"%.2f", downloadedValue))/\(String(format:"%.2f", totalValue)) \(display[type]) downloaded"
        }
    }
    
    /// A string describing the remaining time of the download
    var remainingString: String? {
        get {
            guard let timeRemaining = timeRemaining, !timeRemaining.isNaN, !timeRemaining.isInfinite else { return nil }
            
            let secondsRemaining = Int(timeRemaining)
            
            if secondsRemaining < 60 { // Less than a minute
                return "\(secondsRemaining)s"
            } else if secondsRemaining < 3600 {
                return "\(Int(secondsRemaining/60))min \(Int(secondsRemaining)%60)s"
            } else if timeRemaining < 24*3600 {
                return "\(secondsRemaining/3600)hours \(Int((secondsRemaining % 3600) / 60))min"
            }
            
            return "A long time"
        }
    }
    
    private var _bytesDownloaded = 0
    
    /// The number of bytes that have been downloaded, set this every time you wish to update the speed of the download
    var bytesDownloaded: Int {
        set {
            
            _bytesDownloaded = newValue
            
            let t = Date().timeIntervalSince1970
            let dt = t - lastReading.timeStamp
            let db = newValue - lastReading.downloaded
            
            if dt > sampleSpacing && db > 0 {
                
                speeds.append((speed: Double(db)/dt, timeStamp: t))
                speeds = speeds.filter({ (result) -> Bool in
                    return t - result.timeStamp < averageTimeWindow
                })
                
                downloadSpeed = speeds.reduce(0.0, { (total, result) -> Double in
                    return total + result.speed
                }) / Double(speeds.count)
                
                timeRemaining = Double(totalBytes - newValue) / downloadSpeed!
                lastReading = (downloaded: newValue, timeStamp: t)
            }
            
        }
        get {
            return _bytesDownloaded
        }
    }
    
    /// The start time (since 1970) of the download
    let startTime: TimeInterval
    
    /// The remaining time of the download
    var timeRemaining: TimeInterval?
    
    /// The current download speed
    var downloadSpeed: Double?
    
    private var lastReading: (downloaded: Int, timeStamp: TimeInterval)
    
    private var speeds: [(speed: Double, timeStamp: TimeInterval)] = []
    
    
    /// Initialises a new DownloadProgress helper class
    ///
    /// - Parameter totalBytes: The total number of bytes to be downloaded
    init(totalBytes: Int) {
        
        self.totalBytes = totalBytes
        startTime = Date().timeIntervalSince1970
        self.totalBytes = totalBytes
        self.lastReading = (downloaded: 0, timeStamp: startTime)
    }
}


class DownloadingStormBundleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var retryButton: TSCButton!
    
    @IBOutlet weak var preparingIndicator: TSCView!
    @IBOutlet weak var downloadingIndicator: TSCView!
    @IBOutlet weak var unpackingIndicator: TSCView!
    @IBOutlet weak var verifyingIndicator: TSCView!
    @IBOutlet weak var copyingIndicator: TSCView!
    @IBOutlet weak var cleaningUpIndicator: TSCView!
    
    @IBOutlet weak var progressView: ProgressView!
    
    var downloadProgress: DownloadProgress?
    
    var currentStage: UpdateStage = .preparing {
        didSet {
            switch currentStage {
                
            case .downloading, .preparing, .checking:
                
                preparingIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                preparingIndicator.borderColor = UIColor(hexString: doneBorderHex)
                downloadingIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
                downloadingIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
            
            case .unpacking:
                
                downloadingIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                downloadingIndicator.borderColor = UIColor(hexString: doneBorderHex)
                unpackingIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
                unpackingIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
                
                titleLabel.text = "A few seconds remaining"
                statusLabel.text = "Unpacking dev bundle..."
                progressView.progress = 0.92
            
            case .verifying:
                
                unpackingIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                unpackingIndicator.borderColor = UIColor(hexString: doneBorderHex)
                verifyingIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
                verifyingIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
                
                statusLabel.text = "Verifying dev bundle..."
                progressView.progress = 0.94

            case .copying:
                
                verifyingIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                verifyingIndicator.borderColor = UIColor(hexString: doneBorderHex)
                copyingIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
                copyingIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
                
                statusLabel.text = "Copying dev bundle to live..."
                progressView.progress = 0.96
            
            case .cleaning:
                
                copyingIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                copyingIndicator.borderColor = UIColor(hexString: doneBorderHex)
                cleaningUpIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
                cleaningUpIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
                
                statusLabel.text = "Nearly Done!"
                progressView.progress = 0.98
            
            case .finished:
                
                cleaningUpIndicator.backgroundColor = UIColor(hexString: doneFillHex)
                cleaningUpIndicator.borderColor = UIColor(hexString: doneBorderHex)
                titleLabel.text = "Reloading App"
                statusLabel.text = "All Done!"
                progressView.progress = 1.0
            }
        }
    }
    
    var error: Error? {
        didSet {
            if error != nil {
                
                switch currentStage {
                    
                case .preparing, .checking:
                    
                    preparingIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    preparingIndicator.borderColor = UIColor(hexString: failedBorderHex)
                    
                case .downloading:
                    
                    downloadingIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    downloadingIndicator.borderColor = UIColor(hexString: failedBorderHex)
                    
                case .unpacking:
                    
                    unpackingIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    unpackingIndicator.borderColor = UIColor(hexString: failedBorderHex)
                    
                case .verifying:
                    
                    verifyingIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    verifyingIndicator.borderColor = UIColor(hexString: failedBorderHex)
                    
                case .copying:
                    
                    copyingIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    copyingIndicator.borderColor = UIColor(hexString: failedBorderHex)

                case .cleaning:
                    
                    cleaningUpIndicator.backgroundColor = UIColor(hexString: failedFillHex)
                    cleaningUpIndicator.borderColor = UIColor(hexString: failedBorderHex)
                    
                    
                default:
                    print("Failed on finish!")
                }
                
                titleLabel.text = "Dev Mode Failed ⚠️"
                retryButton.isHidden = false
                statusLabel.isHidden = true
                progressView.tintColor = UIColor(hexString: failedFillHex)
            }
        }
    }
    
    func startDownloading() {
        
        DeveloperModeController.shared.switchToDev { [weak self] (stage, amountDownloaded, totalToDownload, error) -> (Void) in
            
            if self?.downloadProgress == nil, totalToDownload > 0 {
                
                self?.downloadProgress = DownloadProgress(totalBytes: totalToDownload)
                self?.downloadProgress?.bytesDownloaded = amountDownloaded
                
            } else if let progress = self?.downloadProgress {
                
                if stage == .downloading {
                    
                    OperationQueue.main.addOperation {
                        
                        self?.progressView.progress = (Double(amountDownloaded) / Double(totalToDownload)) * 0.9

                        progress.bytesDownloaded = amountDownloaded
                        self?.statusLabel.text = progress.progressString

                        guard let remainingString = progress.remainingString else {
                            
                            self?.titleLabel.text = "Beginning Download"
                            return
                        }
                        
                        self?.titleLabel.text = "\(remainingString) remaining"
                    }
                }
            }
            
            if stage != self?.currentStage {
                
                OperationQueue.main.addOperation {
                    self?.currentStage = stage
                }
            }
            
            if let error = error {
                
                OperationQueue.main.addOperation {
                    self?.error = error
                }
            }
        }
    }
    
    @IBAction func handleRetry(_ sender: Any) {
        
        downloadingIndicator.backgroundColor = .clear
        unpackingIndicator.backgroundColor = .clear
        verifyingIndicator.backgroundColor = .clear
        copyingIndicator.backgroundColor = .clear
        cleaningUpIndicator.backgroundColor = .clear
        
        if #available(iOS 13.0, *) {
            copyingIndicator.borderColor = .opaqueSeparator
            verifyingIndicator.borderColor = .opaqueSeparator
            unpackingIndicator.borderColor = .opaqueSeparator
            downloadingIndicator.borderColor = .opaqueSeparator
            cleaningUpIndicator.borderColor = .opaqueSeparator
        } else {
            copyingIndicator.borderColor = .lightGray
            verifyingIndicator.borderColor = .lightGray
            unpackingIndicator.borderColor = .lightGray
            downloadingIndicator.borderColor = .lightGray
            cleaningUpIndicator.borderColor = .lightGray
        }
        
        
        preparingIndicator.backgroundColor = UIColor(hexString: inProgressFillHex)
        preparingIndicator.borderColor = UIColor(hexString: inProgressBorderHex)
        
        retryButton.isHidden = true
        statusLabel.isHidden = false
        titleLabel.text = "Preparing for Download"
        statusLabel.text = "Clearing existing bundles..."
        
        downloadProgress = nil
        progressView.progress = 0.0
        progressView.tintColor = UIColor(hexString: "#4A90E2")
        
        startDownloading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColours()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColours()
    }
    
    private func updateColours() {
        
        if #available(iOS 13.0, *) {
            progressView.trackTintColor = .systemGray4
            progressView.backgroundColor = .systemGray4
        } else {
            progressView.trackTintColor = .lightGray
            progressView.backgroundColor = .lightGray
        }
    }
    
    private let inProgressBorderHex = "#D6911D"
    private let inProgressFillHex = "#F5A623"
    
    private let doneBorderHex = "#61b831"
    private let doneFillHex = "#72d33a"
    
    private let failedBorderHex = "#c3201f"
    private let failedFillHex = "#ff3b39"
}
