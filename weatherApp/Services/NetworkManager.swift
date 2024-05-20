import Foundation

class NetworkManager {
    func fetchWeatherData(latitude: Double, longitude: Double, completionHandler:  @escaping (WeatherInfoData?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=f7fba2a96004431c6e3b90fb0728bd89")
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    print("Error : \(error!.localizedDescription)")
                    completionHandler(nil)
                    return
                }
                var fetchedWeatherData: WeatherInfoData?
                do{
                    fetchedWeatherData = try JSONDecoder().decode(WeatherInfoData.self, from: data)
                    if let fetchedWeatherData = fetchedWeatherData {
                        completionHandler(fetchedWeatherData)
                    }
                    else {
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

