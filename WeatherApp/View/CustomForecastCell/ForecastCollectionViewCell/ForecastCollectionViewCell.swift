//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 12/6/24.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var forecastTemperature: UILabel!
    @IBOutlet weak var forecastMaxMinTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
