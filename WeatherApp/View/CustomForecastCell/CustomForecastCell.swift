//
//  CustomForecastCell.swift
//  WeatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 12/6/24.
//

import UIKit

class CustomForecastCell: UITableViewCell {


    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    let weatherData = WeatherDataViewModel()
    var forecastData: ForecastModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "forecastCollectionViewCell")
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    func configure(to data: ForecastModel) {
        self.forecastData = data
        forecastCollectionView.reloadData()
    }
}

extension CustomForecastCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let currentDate = dateFormatter.string(from: date)
    
        if let forecastData = forecastData {
            let str = forecastData.list[indexPath.row].dt_txt
            cell.forecastTemperature.text = "\(Int(forecastData.list[indexPath.row].main.temp))ºC"
            cell.forecastMaxMinTemp.text = "\(Int(forecastData.list[indexPath.row].main.temp_min))ºC/\(Int(forecastData.list[indexPath.row].main.temp_max)) ºC"
        }
        return cell
    }
}

