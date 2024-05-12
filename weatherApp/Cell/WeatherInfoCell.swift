//
//  WeatherInfoCell.swift
//  weatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 9/5/24.
//

import UIKit

class WeatherInfoCell: UITableViewCell {

    @IBOutlet weak var weatherInfoTitle: UILabel!
    @IBOutlet weak var weatherInfoValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
