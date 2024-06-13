import UIKit

class WeatherInfoViewController: UIViewController {
    var weatherInfoData: WeatherInfoData?
    var forecastData: ForecastModel?
    var currentLocationManager = CurrentLocationManager()
    let weatherData = WeatherDataViewModel()
    var forecastIcons = ForecastIcon()
    var icon = UIImage()
    
    @IBOutlet weak var weatherInfoTable: UITableView!

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
        self.weatherInfoTable.separatorStyle = .none
        currentLocationManager.userLocationDelegate = self
        weatherData.apiDelegate = self
        weatherData.forecastDelegate = self
        weatherData.forecastIconDelegate = self
        currentLocationManager.getCurrentLocation()
        registerCustomWeatherCell()
        
    }
    
    func registerCustomWeatherCell() {
        let nib1 = UINib(nibName: "CustomWeatherDataCell", bundle: nil)
        weatherInfoTable.register(nib1, forCellReuseIdentifier: "customWeatherDataCell")
        
        let nib2 = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib2, forCellReuseIdentifier: "weatherInfoCell")
        
        let nib3 = UINib(nibName: "CustomForecastCell", bundle: nil)
        weatherInfoTable.register(nib3, forCellReuseIdentifier: "customForecastCell")

        let nib4 = UINib(nibName: "CustomDayForecastCellTableViewCell", bundle: nil)
        weatherInfoTable.register(nib4, forCellReuseIdentifier: "customDayForecastCellTableViewCell")
    }
    
    func updateWeatherDataInView(locationName: String, response: Data) {
        icon = UIImage(data: response)!
        view.layoutIfNeeded()
        weatherInfoData?.name = locationName
        weatherInfoTable.reloadData()
    }
    
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "No Internet", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

extension WeatherInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < 1 {
            let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "customWeatherDataCell", for: indexPath) as! CustomWeatherDataCell
            cell.CityName.text = "📍\(weatherInfoData?.name ?? "")"
            cell.weatherDescription.text = weatherInfoData?.weather[0].description
            cell.weatherDescriptionIcon.image = icon
            cell.temperature.text = "\(Int(weatherInfoData?.main.temp ?? 0))ºC"
            cell.feelsLike.text = "Feels Like \(Int(weatherInfoData?.main.feels_like ?? 0))ºC"
            cell.maximumTemperature.text = "Max \(Int(weatherInfoData?.main.temp_max ?? 0))ºC"
            cell.minimumTemperature.text = "Min \(Int(weatherInfoData?.main.temp_min ?? 0))ºC"
            
            cell.backgroundColor = UIColor.black
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            
            return cell
        } else if indexPath.row < 2 {
            let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "weatherInfoCell", for: indexPath) as! WeatherInfoCell
            cell.pressureLabel.text = "Pressure"
            cell.pressureValue.text = "\(weatherInfoData?.main.pressure ?? 0) Pa"
            cell.humidityLabel.text = "Humidity"
            cell.humidityValue.text = "\(weatherInfoData?.main.humidity ?? 0) %"
            cell.visibilityLabel.text = "Visibility"
            cell.visibilityValue.text = "\(weatherInfoData?.visibility ?? 0) km"
            cell.windSpeedLabel.text = "Wind Speed"
            cell.windSpeedValue.text = "\(weatherInfoData?.wind.speed ?? 0) km/h"
            return cell
        } else if indexPath.row < 3{
            let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "customForecastCell", for: indexPath) as! CustomForecastCell
            if let forecastData = forecastData {
                cell.configure(to: forecastData, icons: forecastIcons.forecastIcons)
            }
            return cell
        }else {
            let cell = weatherInfoTable.dequeueReusableCell(withIdentifier: "customDayForecastCellTableViewCell", for: indexPath) as! CustomDayForecastCellTableViewCell
            if let forecastData = forecastData {
                let forecastDate = forecastData.list[8 * (indexPath.row - 2)].dt_txt
                let start = forecastDate.index(forecastDate.startIndex, offsetBy: 8)
                let end = forecastDate.index(forecastDate.startIndex, offsetBy: 9)
                cell.upcomingDays.text = "\(forecastDate[start...end])"
                cell.UpcomingTemperature.text = "\(Int(forecastData.list[8 * (indexPath.row - 2)].main.temp))ºC"
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 2 {
            return UITableView.automaticDimension
        } else {
            return 100
        }
    }

}

extension WeatherInfoViewController: UserLocationDelegate {
    func passCurrentLocation(latitude: Double, longitude: Double) {
        weatherData.fetchWeatherData(latitude: latitude, longitude: longitude)
        weatherData.fetchforecastData(latitude: latitude, longitude: longitude)
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

extension WeatherInfoViewController: ForecastDelegate {
    func passForecastedData(response: ForecastModel) {
        self.forecastData = response
    }
}

extension WeatherInfoViewController: ForecastIconDelegate {
    func passForecastedIcon(response: [Data]) {
        forecastIcons.forecastIcons = response
    }
}
