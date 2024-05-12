import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherInfoTable: UITableView!
    
    var response = [String]()
    var fetchNewData: WeatherInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib, forCellReuseIdentifier: "weatherInfoCell")
        
        let callingNetwork  = NetworkManager()
        callingNetwork.fetchData { response in
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
            weatherValue = "\(fetchNewData?.main.pressure ?? 0)"
            weatherTitle = "Pressure"
        case networkData.Humidity.rawValue:
            weatherValue = "\(fetchNewData?.main.humidity ?? 0)"
            weatherTitle = "Humidity"
        case networkData.Visibility.rawValue:
            weatherValue = "\(fetchNewData?.visibility ?? 0)"
            weatherTitle = "Visibility"
        case networkData.WindSpeed.rawValue:
            weatherValue = "\(fetchNewData?.wind.speed ?? 0) km/h"
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

