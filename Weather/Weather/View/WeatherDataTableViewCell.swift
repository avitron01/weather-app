//
//  WeatherDataTableViewCell.swift
//  Weather
//
//  Created by Avinash P on 27/03/21.
//

import UIKit

class WeatherDataTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var labelColor: UIColor? {
        didSet {
            self.fieldLabel.textColor = labelColor
            self.valueLabel.textColor = labelColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
