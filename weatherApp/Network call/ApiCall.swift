import Foundation

class NetworkCall {
    
    func fetchData(completionHandler:  @escaping (WeatherInfoData) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=23.810331&lon=90.412521&units=metric&appid=f7fba2a96004431c6e3b90fb0728bd89")
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error!!!!")
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
