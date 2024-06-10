import Foundation
import RealmSwift

class WeatherDataModel: Object{
    @Persisted(primaryKey: true) var locationName: String?
    @Persisted var weatherDescription: String?
    @Persisted var descriptionIcon = Data()
    @Persisted var temperature: Double?
    @Persisted var feelsLike: Double?
    @Persisted var maximumTemperature: Double?
    @Persisted var minimumTemperature: Double?
    @Persisted var pressure: Int?
    @Persisted var humidity: Int?
    @Persisted var visibility: Int?
    @Persisted var windSpeed: Double?
}
