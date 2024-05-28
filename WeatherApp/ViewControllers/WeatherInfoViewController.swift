import UIKit
import CoreLocation

enum NetworkData: Int {
    case pressure = 0
    case humidity
    case visibility
    case windSpeed
}

class WeatherInfoViewController: UIViewController {
    var currentLocationLatitude: Double = 0.0
    var currentLocationLongitude: Double = 0.0
    
    var weatherInfoData: WeatherInfoData?
    let locationManager = CLLocationManager()
    
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
        fetchWeatherData(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
    }
    
    @IBAction func searchLocationButtonTapped(_ sender: UIButton) {
        let locationVC = storyboard?.instantiateViewController(withIdentifier: "SearchLocationStoryboardID") as! SearchLocationViewController
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
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
    
    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, locationName: String = "") {
        let networkManager  = NetworkManager()
        let networkIconManager = NetworkIconManager()
        
        networkManager.fetchWeatherData(latitude: latitude, longitude: longitude, completionHandler: { response in
            self.weatherInfoData = response
            networkIconManager.fetchWeatherDescriptionIcon(icon: self.weatherInfoData?.weather[0].icon ?? "", completionHandler: { response in
                let icon = UIImage(data: response!)
                DispatchQueue.main.async {
                    self.descriptionIcon.image = icon
                }
            })
            DispatchQueue.main.async  {
                if locationName != "" {
                    self.updateWeatherDataInView(locationName: locationName)
                } else {
                    self.updateWeatherDataInView(locationName: self.weatherInfoData?.name ?? "")
                }
            }
        })
    }
    
    func updateWeatherDataInView(locationName: String) {
        if let weatherInfoData = weatherInfoData {
            cityName.text = locationName
            temperatureLabel.text = "\(Int(weatherInfoData.main.temp))ºC"
            if weatherInfoData.weather.count != 0 {
                descriptionLabel.text = "\(weatherInfoData.weather[0].description)"
            }
            feelsLikeLabel.text = "Feels like \(Int(weatherInfoData.main.feels_like))ºC"
            minTemp.text = "Minimum temperature \(Int(weatherInfoData.main.temp_min))ºC"
            maxTemp.text = "Maximum temperature \(Int(weatherInfoData.main.temp_max))ºC"
            view.layoutIfNeeded()
            weatherInfoTable.reloadData()
        }
    }
}

extension WeatherInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        currentLocationLatitude = userLocation.coordinate.latitude
        currentLocationLongitude = userLocation.coordinate.longitude
        fetchWeatherData(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Wait, authorizing...")
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            print("Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown, .denied, .network:
                print("Wait for the location permission.")
            case .headingFailure:
                print("Heading request failed with error: \(clErr.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(clErr.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(clErr.localizedDescription)")
            default:
                print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
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

extension WeatherInfoViewController: SearchLocationDelegate {
    func getLocationInformation(locationName: String, latitude: Double, longitude: Double) {
        fetchWeatherData(latitude: latitude, longitude: longitude, locationName: locationName)
    }
}
