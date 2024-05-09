//
//  ViewController.swift
//  weatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 6/5/24.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

//    var weatherDataTitle = ["Pressure", "Humidity", "Visibility", "Wind"]
    var response = [String]()


    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherInfoTable: UITableView!
    
    var fetchNewData: weatherInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib, forCellReuseIdentifier: "weatherInfoCell")
        fetchData { response in
            self.fetchNewData = response
            DispatchQueue.main.async  {
                self.temperatureLabel.text = "\(Int(self.fetchNewData!.main.temp))ºC"
                self.desLabel.text = "\(self.fetchNewData!.weather[0].description)"
                self.feelsLikeLabel.text = "Feels like \(Int(self.fetchNewData!.main.feels_like))ºC"
                self.minTemp.text = "Minimum temperaure \(Int(self.fetchNewData!.main.temp_min))ºC"
                self.maxTemp.text = "Maximum temperaure \(Int(self.fetchNewData!.main.temp_max))ºC"
                self.weatherInfoTable.reloadData()
                
            }
        }
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherInfoTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "weatherInfoCell", for: indexPath) as! WeatherInfoCell
        
        if indexPath.row == 0 {
            var anything = fetchNewData?.main.pressure ?? 0
            cell.weatherInfoValue.text = "\(anything)"
            cell.weatherInfoTitle.text = "Pressure"
           
        }
          if indexPath.row == 1 {
            var anything = fetchNewData?.main.humidity ?? 0
            cell.weatherInfoValue.text = "\(anything)"
            cell.weatherInfoTitle.text = "Humidity"
           
        }
          if indexPath.row == 2 {
            var anything = fetchNewData?.visibility ?? 0
            cell.weatherInfoValue.text = "\(anything)"
            cell.weatherInfoTitle.text = "Visibility"
           
        }
          if indexPath.row == 3 {
            var anything = Int(fetchNewData?.wind.speed ?? 0)
            cell.weatherInfoValue.text = "\(anything) km/h"
            cell.weatherInfoTitle.text = "Wind Speed"
           
        }
        
        
            
            
//        cell.weatherInfoLabel.text = fetchNewData.main
//        cell.weatherInfoLabel.text = fetchNewData.main
//        cell.weatherInfoLabel.text = fetchNewData.main
//        cell.weatherValueLabel.text = weatherDataValue[indexPath.row]
        return cell
    }
    
    
    
        
}

