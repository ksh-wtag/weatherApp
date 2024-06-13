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
    var forecastIcons = ForecastIcon()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "forecastCollectionViewCell")
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    func configure(to data: ForecastModel, icons: [Data]) {
        DispatchQueue.main.async {
            self.forecastData = data
//            self.forecastIcons.forecastIcons = icons
            self.forecastCollectionView.reloadData()
        }
    }
}

extension CustomForecastCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        
//        cell.backgroundColor = UIColor.clear
//        cell.contentView.layer.cornerRadius = 50.0
//        cell.contentView.layer.borderWidth = 100.0
//        cell.contentView.layer.borderColor = UIColor.black.cgColor
//        cell.contentView.layer.masksToBounds = false
//        cell.backgroundColor = .black
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let currentDate = dateFormatter.string(from: date)
        
        if let forecastData = forecastData {
            let forecastDate = forecastData.list[indexPath.row].dt_txt
            let start = forecastDate.index(forecastDate.startIndex, offsetBy: 8)
            let end = forecastDate.index(forecastDate.startIndex, offsetBy: 9)
            if currentDate == forecastDate[start...end] {
                cell.day.text = "today"
            }else {
                cell.day.text = "tommorow"
            }
   
                cell.forecastIcon?.loadNetworkImage(url: "https://openweathermap.org/img/wn/\(forecastData.list[indexPath.row].weather[0].icon)@2x.png")
                cell.forecastTemperature.text = "\(Int(forecastData.list[indexPath.row].main.temp))ºC"
                cell.forecastMaxMinTemp.text = "\(Int(forecastData.list[indexPath.row].main.temp_min))ºC/\(Int(forecastData.list[indexPath.row].main.temp_max)) ºC"
            
        }
        cell.layer.backgroundColor = UIColor.black.cgColor
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
}

extension UIImageView {
    func loadNetworkImage(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}


