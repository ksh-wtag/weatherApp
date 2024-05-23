import UIKit
import CoreLocation

enum NetworkData: Int {
    case pressure = 0
    case humidity
    case visibility
    case windSpeed
}

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherInfoTable: UITableView!
    
    var currentLocationLatitude = Double()
    var currentLocationLongitude = Double()
    
    var weatherInfoData: WeatherInfoData?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentLocation()
        registerCustomWeatherCell()
    }
    
    func registerCustomWeatherCell() {
        let nib = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib, forCellReuseIdentifier: "weatherInfoCell")
    }
    
    func getCurrentLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        let networkManager  = NetworkManager()
        networkManager.fetchWeatherData(latitude: latitude, longitude: longitude, completionHandler: { response in
            self.weatherInfoData = response
            DispatchQueue.main.async  {
                self.updateWeatherDataInView()
            }
        })
    }
    
    func updateWeatherDataInView() {
        if let weatherInfoData = weatherInfoData {
            cityName.text = "\(weatherInfoData.name)"
            self.temperatureLabel.text = "\(Int(weatherInfoData.main.temp))ºC"
            self.descriptionLabel.text = "\(weatherInfoData.weather[0].description)"
            self.feelsLikeLabel.text = "Feels like \(Int(weatherInfoData.main.feels_like))ºC"
            self.minTemp.text = "Minimum temperaure \(Int(weatherInfoData.main.temp_min))ºC"
            self.maxTemp.text = "Maximum temperaure \(Int(weatherInfoData.main.temp_max))ºC"
            self.view.layoutIfNeeded()
            self.weatherInfoTable.reloadData()
        }
    }
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        fetchWeatherData(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
    }
    
    @IBAction func searchLocationButtonTapped(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        let locationVC = storyboard?.instantiateViewController(withIdentifier: "LocationsViewController") as! LocationsViewController
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
}

extension WeatherInfoViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        currentLocationLatitude = userLocation.coordinate.latitude
        currentLocationLongitude = userLocation.coordinate.longitude
        fetchWeatherData(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        locationManager.stopUpdatingLocation()
        if locationManager.authorizationStatus != .notDetermined {
            let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
        }
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

extension WeatherInfoViewController: PassCityInfo {
    
    func passCoordinate(latitude: Double, longitude: Double) {
        fetchWeatherData(latitude: latitude, longitude: longitude)
    }
}
