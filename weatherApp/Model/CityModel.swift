import Foundation

struct city {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

var dhaka = city(name: "Dhaka",latitude: 23.7104,longitude: 90.4074)
var rajshahi = city(name: "Rajshahi",latitude: 24.3667,longitude: 88.6)
var khulna = city(name: "Khulna",latitude: 22.8135,longitude: 89.5672)
var rangpur = city(name: "Rangpur",latitude: 25.75,longitude: 89.25)
var barishal = city(name: "Barishal",latitude: 22.5,longitude: 90.3333)
var chattogram = city(name: "Chattogram",latitude: 22.9167,longitude: 91.5)
var sylhet = city(name: "Sylhet",latitude: 24.5,longitude: 91.6667)
