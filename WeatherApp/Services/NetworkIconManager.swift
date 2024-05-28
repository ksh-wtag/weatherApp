import UIKit

class NetworkIconManager: UIImage {
    func fetchWeatherDescriptionIcon(url: URL, completionHandler: @escaping(Data?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }).resume()
    }
}
