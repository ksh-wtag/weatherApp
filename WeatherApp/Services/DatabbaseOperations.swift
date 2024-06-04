import UIKit
import RealmSwift

class DatabaseOperations {
    var weatherDataModel = WeatherDataModel()
    
    func createRecord(response: WeatherInfoData, iconResponse: Data) {
        let realm = try! Realm()
        let saveData = WeatherDataModel()
        saveData.locationName = response.name
        saveData.weatherDescription = response.weather[0].description
        saveData.descriptionIcon = iconResponse
        saveData.temperature = response.main.temp
        saveData.maximumTemperature = response.main.temp_max
        saveData.minimumTemperature = response.main.temp_min
        saveData.feelsLike = response.main.feels_like
        saveData.pressure = response.main.pressure
        saveData.humidity = response.main.humidity
        saveData.visibility = response.visibility
        saveData.windSpeed = response.wind.speed
        do {
            try realm.write {
                realm.add(saveData, update: .all)
            }
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func readRecord() -> WeatherDataModel?{
        let realm = try! Realm()
        do{
            try realm.write {
                weatherDataModel = realm.objects(WeatherDataModel.self).last!
            }
        }catch {
            return nil
        }
        return weatherDataModel
    }
}
