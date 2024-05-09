// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct weatherInfoData: Codable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind

}



// MARK: - Main
struct Main: Codable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, humidity: Int

}

// MARK: - Weather
struct Weather: Codable {
    let description: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double

}
