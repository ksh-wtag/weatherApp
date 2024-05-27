import Foundation
 
struct ApiAddress {
    let appId = "f7fba2a96004431c6e3b90fb0728bd89"
    
    func getApiAddress(latitude: Double, longitude: Double) -> String{
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(appId)"
        return baseUrl
    }
}
