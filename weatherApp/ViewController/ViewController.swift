import UIKit

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherInfoTable: UITableView!
    
    var weatherInfoData: WeatherInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib, forCellReuseIdentifier: "weatherInfoCell")
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        let networkManager  = NetworkManager()
        networkManager.showWeatherData { response in
            self.weatherInfoData = response
            DispatchQueue.main.async  {
                self.temperatureLabel.text = "\(Int(response.main.temp))ºC"
                self.descriptionLabel.text = "\(response.weather[0].description)"
                self.feelsLikeLabel.text = "Feels like \(Int(response.main.feels_like))ºC"
                self.minTemp.text = "Minimum temperaure \(Int(response.main.temp_min))ºC"
                self.maxTemp.text = "Maximum temperaure \(Int(response.main.temp_max))ºC"
                self.weatherInfoTable.reloadData()
            }
        }
    }
}

extension WeatherInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherInfoTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "weatherInfoCell", for: indexPath) as! WeatherInfoCell
        
        enum networkData: Int {
            case pressure = 0
            case Humidity
            case Visibility
            case WindSpeed
        }
        
        var weatherTitle = ""
        var weatherValue = ""
        
        switch indexPath.row {
        case networkData.pressure.rawValue:
            weatherValue = "\(weatherInfoData?.main.pressure ?? 0) Pa"
            weatherTitle = "Pressure"
        case networkData.Humidity.rawValue:
            weatherValue = "\(weatherInfoData?.main.humidity ?? 0) %"
            weatherTitle = "Humidity"
        case networkData.Visibility.rawValue:
            weatherValue = "\(weatherInfoData?.visibility ?? 0) km"
            weatherTitle = "Visibility"
        case networkData.WindSpeed.rawValue:
            weatherValue = "\(weatherInfoData?.wind.speed ?? 0) km/h"
            weatherTitle = "Wind Speed"
        default:
            weatherValue = ""
            weatherTitle = ""
        }
        
        cell.weatherInfoTitle.text = weatherTitle
        cell.weatherInfoValue.text = weatherValue
        
        return cell
    }
}

