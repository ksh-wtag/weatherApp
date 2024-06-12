import Foundation
import CoreLocation

protocol UserLocationDelegate {
    func passCurrentLocation(latitude: Double, longitude: Double)
}

class CurrentLocationManager: NSObject {
    private var currentLocationLatitude: Double = 0.0
    private var currentLocationLongitude: Double = 0.0
    private let weatherData = WeatherDataViewModel()
    private let locationManager = CLLocationManager()
    internal var userLocationDelegate: UserLocationDelegate?
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension CurrentLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        currentLocationLatitude = userLocation.coordinate.latitude
        currentLocationLongitude = userLocation.coordinate.longitude
        userLocationDelegate?.passCurrentLocation(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Wait, authorizing...")
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            print("Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown, .denied, .network:
                print("Wait for the location permission.")
            case .headingFailure:
                print("Heading request failed with error: \(clErr.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(clErr.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(clErr.localizedDescription)")
            default:
                print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
}
