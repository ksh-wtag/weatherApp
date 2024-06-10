import UIKit

enum NetworkData: Int {
    case pressure = 0
    case humidity
    case visibility
    case windSpeed
}

class WeatherInfoViewController: UIViewController {
    var weatherInfoData: WeatherInfoData?
    var currentLocationManager = CurrentLocationManager()
    let weatherData = WeatherData()
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionIcon: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherInfoTable: UITableView!
    @IBOutlet weak var weatherInfoViews: UIView!
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        currentLocationManager.getCurrentLocation()
    }
    
    @IBAction func searchLocationButtonTapped(_ sender: UIButton) {
        let locationVC = storyboard?.instantiateViewController(withIdentifier: "SearchLocationStoryboardID") as! SearchLocationViewController
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationManager.userLocationDelegate = self
        weatherData.apiDelegate = self
        currentLocationManager.getCurrentLocation()
        registerCustomWeatherCell()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        weatherInfoViews.layer.cornerRadius = weatherInfoViews.frame.size.height / 10
        weatherInfoViews.layer.masksToBounds = true
        weatherInfoViews.layer.borderWidth = 0
    }
    
    func registerCustomWeatherCell() {
        let nib = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib, forCellReuseIdentifier: "weatherInfoCell")
    }
    
    func updateWeatherDataInView(locationName: String, response: Data) {
        if let weatherInfoData = weatherInfoData {
            cityName.text = locationName
            temperatureLabel.text = "\(Int(weatherInfoData.main.temp))ºC"
            if weatherInfoData.weather.count != 0 {
                descriptionLabel.text = "\(weatherInfoData.weather[0].description)"
                let icon = UIImage(data: response)
                self.descriptionIcon.image = icon
            }
            feelsLikeLabel.text = "Feels like \(Int(weatherInfoData.main.feels_like))ºC"
            minTemp.text = "Minimum temperature \(Int(weatherInfoData.main.temp_min))ºC"
            maxTemp.text = "Maximum temperature \(Int(weatherInfoData.main.temp_max))ºC"
            view.layoutIfNeeded()
            weatherInfoTable.reloadData()
        }
    }
    
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "No Internet", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

extension WeatherInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "weatherInfoCell", for: indexPath) as! WeatherInfoCell
        
        var weatherTitle = ""
        var weatherValue = ""
        
        let networkData = NetworkData(rawValue: indexPath.row)
        
        switch networkData {
        case .pressure:
            weatherValue = "\(weatherInfoData?.main.pressure ?? 0) Pa"
            weatherTitle = "Pressure"
        case .humidity:
            weatherValue = "\(weatherInfoData?.main.humidity ?? 0) %"
            weatherTitle = "Humidity"
        case .visibility:
            weatherValue = "\(weatherInfoData?.visibility ?? 0) km"
            weatherTitle = "Visibility"
        case .windSpeed:
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

extension WeatherInfoViewController: UserLocation {
    func passCurrentLocation(latitude: Double, longitude: Double) {
        weatherData.fetchWeatherData(latitude: latitude, longitude: longitude)
    }
}

extension WeatherInfoViewController: SearchLocationDelegate {
    func getLocationInformation(latitude: Double, longitude: Double, locationName: String) {
        weatherData.fetchWeatherData(latitude: latitude, longitude: longitude,locationName: locationName)
    }
}

extension WeatherInfoViewController: WeatherDataPassing {
    func passWeatherInfoData(weatherInfoData: WeatherInfoData?) {
        self.weatherInfoData = weatherInfoData
    }
    
    func passInfoToView(locationName: String, response: Data) {
        updateWeatherDataInView(locationName: locationName, response: response)
    }
    
    func passErrorToView(error: Error?) {
        showErrorAlert(error: error!)
    }
}
