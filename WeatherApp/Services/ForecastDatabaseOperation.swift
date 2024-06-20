import Foundation
import RealmSwift

class ForecastDatabaseOperation {
    var forecastDatabaseModel = ForecastDatabaseModel()
    
    func createRecord(response: ForecastModel, iconResponse: Data) {
        let realm = try! Realm()
        let saveData = ForecastDatabaseModel()
        saveData.ForecastedDays = ["\(response.list[8].main.temp)"]
        do {
            try realm.write {
                realm.add(saveData, update: .all)
            }
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
//    func readRecord() -> WeatherDataModel?{
//        let realm = try! Realm()
//        weatherDataModel = realm.objects(WeatherDataModel.self).last!
//        return weatherDataModel
//    }
}
