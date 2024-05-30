import Foundation

class NetworkManager {
    func fetchWeatherData(latitude: Double, longitude: Double, locationName: String = "", completionHandler:  @escaping (WeatherInfoData?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let apiAddress = ApiAddressModel()
            let weatherApiAddress: String
            weatherApiAddress = apiAddress.getApiAddressByCoordinate(latitude: latitude, longitude: longitude)
            let url = URL(string: weatherApiAddress)
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    print("Error : \(error!.localizedDescription)")
                    completionHandler(nil)
                    return
                }
                do{
                    let fetchedWeatherData: WeatherInfoData?
                    fetchedWeatherData = try JSONDecoder().decode(WeatherInfoData.self, from: data)
                    if let fetchedWeatherData = fetchedWeatherData {
                        completionHandler(fetchedWeatherData)
                    } else {
                        completionHandler(nil)
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
