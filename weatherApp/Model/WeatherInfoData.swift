import Foundation

struct WeatherInfoData: Codable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
}
//test branch
