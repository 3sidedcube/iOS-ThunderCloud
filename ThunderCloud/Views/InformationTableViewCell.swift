//
//  InformationTableViewCell.swift
//  Baymax
//
//  Created by Matthew Cheetham on 13/11/2018.
//  Copyright © 2018 3 SIDED CUBE. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
