import UIKit

class NetworkIconManager: UIImage {
    func fetchWeatherDescriptionIcon(icon: String, completionHandler: @escaping(Data?) -> ()) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }).resume()
    }
}
