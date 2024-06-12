import Foundation

class ForecastNetworkManager {
    func fetchForecastWeatherData(latitude: Double, longitude: Double, completionHandler: @escaping(ForecastModel?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=f7fba2a96004431c6e3b90fb0728bd89")
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else{
                completionHandler(nil)
                return
            }
            do{
                let forecastData: ForecastModel?
                forecastData = try JSONDecoder().decode(ForecastModel.self, from: data)
                guard let forecastData = forecastData else {
                    completionHandler(nil)
                    return
                }
                completionHandler(forecastData)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }).resume()
    }
}
