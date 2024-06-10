//
//  CustomWeatherDataCell.swift
//  WeatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 10/6/24.
//

import UIKit

class CustomWeatherDataCell: UITableViewCell {

    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherDescriptionIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var maximumTemperature: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
