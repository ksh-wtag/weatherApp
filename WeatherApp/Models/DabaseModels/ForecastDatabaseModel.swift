import Foundation
import RealmSwift

class ForecastDatabaseModel: Object {
    @Persisted var ForecastedDays = List<String>()
    @Persisted var ForecastedTemperatures = List<Int>()
    @Persisted var ForecastedIcons = List<Data>()
}
