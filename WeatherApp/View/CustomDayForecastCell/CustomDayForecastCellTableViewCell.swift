//
//  CustomDayForecastCellTableViewCell.swift
//  WeatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 13/6/24.
//

import UIKit

class CustomDayForecastCellTableViewCell: UITableViewCell {

    @IBOutlet weak var upcomingDays: UILabel!
    @IBOutlet weak var upcomingDescriptionIcon: UIImageView!
    @IBOutlet weak var UpcomingTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
