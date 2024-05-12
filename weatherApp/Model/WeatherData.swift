import Foundation

struct WeatherInfoData: Codable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    
}

struct Main: Codable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, humidity: Int
    
}

struct Weather: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
    
}
