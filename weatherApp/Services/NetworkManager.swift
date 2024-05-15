import Foundation

class NetworkManager {
    
    func fetchFromApi(completionHandler:  @escaping (WeatherInfoData) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=23.810331&lon=90.412521&units=metric&appid=f7fba2a96004431c6e3b90fb0728bd89")
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error : \(error!.localizedDescription)")
                    return
                }
                var fetchedWeatherData: WeatherInfoData?
                do{
                    fetchedWeatherData = try JSONDecoder().decode(WeatherInfoData.self, from: data)
                    completionHandler(fetchedWeatherData!)
                }
                catch{
                    print("Error : \(error.localizedDescription)")
                }
            }
            dataTask.resume()
        }
    }
}
