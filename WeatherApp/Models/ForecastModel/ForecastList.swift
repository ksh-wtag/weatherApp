import Foundation

struct ForecastList: Codable {
    let main: ForecastMain
    let weather: [ForecastWeather]
    let dt_txt: String
}
