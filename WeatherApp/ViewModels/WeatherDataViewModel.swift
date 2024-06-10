import Foundation

protocol WeatherDataDelegate: AnyObject {
    func passWeatherDataToView(locationName: String, response: Data)
    func passErrorToView(error: Error?)
    func passWeatherInfoData(weatherInfoData: WeatherInfoData?)
}

class WeatherDataViewModel {
    var weatherInfoData: WeatherInfoData?
    var databaseOperation = DatabaseOperations()
    var weatherDataModel = WeatherDataModel()
    weak var apiDelegate: WeatherDataDelegate?

    func fetchWeatherData(latitude: Double, longitude: Double, locationName: String = "") {
        let networkManager  = NetworkManager()
        networkManager.fetchWeatherData(latitude: latitude, longitude: longitude, locationName: locationName, completionHandler: { response, error in
            if error == nil {
                self.weatherInfoData = response
                self.apiDelegate?.passWeatherInfoData(weatherInfoData: response)
                if !locationName.isEmpty {
                    self.fetchIconAndUpdateView(locationName: locationName)
                }else {
                    self.fetchIconAndUpdateView(locationName: self.weatherInfoData?.name ?? "")
                }
            }else {
                if let readData = self.databaseOperation.readRecord() {
                    self.weatherDataModel = readData
                }
                self.useDataInDatabase()
                let iconData = self.weatherDataModel.descriptionIcon
                DispatchQueue.main.async {
                    self.apiDelegate?.passErrorToView(error: error)
                    self.apiDelegate?.passWeatherDataToView(locationName: self.weatherInfoData?.name ?? "", response: iconData)
                }
            }
        })
    }
    
    func fetchIconAndUpdateView(locationName: String) {
        let networkIconManager = NetworkIconManager()
        networkIconManager.fetchWeatherDescriptionIcon(icon: self.weatherInfoData?.weather[0].icon ?? "", completionHandler: { response in
            if let weatherInfoData = self.weatherInfoData, let response = response {
                self.databaseOperation.createRecord(response: weatherInfoData, iconResponse: response)
                DispatchQueue.main.async {
                    self.apiDelegate?.passWeatherDataToView(locationName: locationName, response: response)
                }
            }
        })
    }
    
    func useDataInDatabase() {
        let main = Main(temp: self.weatherDataModel.temperature ?? 0, feels_like: self.weatherDataModel.feelsLike ?? 0, temp_min: self.weatherDataModel.minimumTemperature ?? 0, temp_max: self.weatherDataModel.maximumTemperature ?? 0, pressure: self.weatherDataModel.pressure ?? 0, humidity: self.weatherDataModel.humidity ?? 0)
        let wind = Wind(speed: self.weatherDataModel.windSpeed ?? 0)
        let weather = Weather(description: self.weatherDataModel.weatherDescription ?? "", icon: String(decoding: self.weatherDataModel.descriptionIcon, as: UTF8.self))
        let weatherDatabaseData = WeatherInfoData(weather: [weather], main: main, visibility: self.weatherDataModel.visibility ?? 0, wind: wind, name: self.weatherDataModel.locationName ?? "")
        self.weatherInfoData = weatherDatabaseData
        self.apiDelegate?.passWeatherInfoData(weatherInfoData: weatherDatabaseData)
    }
}
