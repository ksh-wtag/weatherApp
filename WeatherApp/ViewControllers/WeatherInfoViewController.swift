import UIKit

class WeatherInfoViewController: UIViewController {
    var weatherInfoData: WeatherInfoData?
    var currentLocationManager = CurrentLocationManager()
    let weatherData = WeatherDataViewModel()
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
        currentLocationManager.getCurrentLocation()
        registerCustomWeatherCell()
        
    }
    
    func registerCustomWeatherCell() {
        let nib1 = UINib(nibName: "CustomWeatherDataCell", bundle: nil)
        weatherInfoTable.register(nib1, forCellReuseIdentifier: "customWeatherDataCell")
        
        let nib2 = UINib(nibName: "WeatherInfoCell", bundle: nil)
        weatherInfoTable.register(nib2, forCellReuseIdentifier: "weatherInfoCell")
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
        return 2
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
            return cell
        } else {
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 500
    }
}

extension WeatherInfoViewController: UserLocationDelegate {
    func passCurrentLocation(latitude: Double, longitude: Double) {
        weatherData.fetchWeatherData(latitude: latitude, longitude: longitude)
    }
}

extension WeatherInfoViewController: SearchLocationDelegate {
    func getLocationInformation(latitude: Double, longitude: Double, locationName: String) {
        weatherData.fetchWeatherData(latitude: latitude, longitude: longitude,locationName: locationName)
    }
}

extension WeatherInfoViewController: WeatherDataDelegate {
    func passWeatherInfoData(weatherInfoData: WeatherInfoData?) {
        self.weatherInfoData = weatherInfoData
    }
    
    func passWeatherDataToView(locationName: String, response: Data) {
        updateWeatherDataInView(locationName: locationName, response: response)
    }
    
    func passErrorToView(error: Error?) {
        showErrorAlert(error: error!)
    }
}
