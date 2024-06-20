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
        selectionStyle = .none
        forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "forecastCollectionViewCell")
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    func configure(to data: ForecastModel, icons: [Data]) {
        DispatchQueue.main.async {
            self.forecastData = data
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
        
        if let forecastData = forecastData {
            let forecastDate = forecastData.list[indexPath.row].dt_txt
            let start = forecastDate.index(forecastDate.startIndex, offsetBy: 11)
            let end = forecastDate.index(forecastDate.startIndex, offsetBy: 16)
            cell.time.text = String(forecastDate[start..<end])
            cell.forecastIcon?.loadNetworkImage(url: "https://openweathermap.org/img/wn/\(forecastData.list[indexPath.row].weather[0].icon)@2x.png")
            cell.forecastDescription.text = forecastData.list[indexPath.row].weather[0].description
            cell.forecastTemperature.text = "\(Int(forecastData.list[indexPath.row].main.temp))ºC"
            
        }
        cell.layer.backgroundColor = UIColor.separator.cgColor
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10.0
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

