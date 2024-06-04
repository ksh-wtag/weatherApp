import Foundation

class NetworkManager {
    func fetchWeatherData(latitude: Double, longitude: Double, locationName: String = "", completionHandler:  @escaping (WeatherInfoData?, Error?) -> Void) {
        DispatchQueue.global().async {
            let apiAddress = WeatherInfoAddressModel()
            let weatherApiAddress: String
            weatherApiAddress = apiAddress.getApiAddressByCoordinate(latitude: latitude, longitude: longitude)
            let url = URL(string: weatherApiAddress)
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    print("Error1 : \(error!.localizedDescription)")
                    completionHandler(nil, error)
                    return
                }
                do{
                    let fetchedWeatherData: WeatherInfoData?
                    fetchedWeatherData = try JSONDecoder().decode(WeatherInfoData.self, from: data)
                    if let fetchedWeatherData = fetchedWeatherData {
                        completionHandler(fetchedWeatherData, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
                catch{
                    print("Error : \(error.localizedDescription)")
                }
            }
            dataTask.resume()
        }
    }
}
