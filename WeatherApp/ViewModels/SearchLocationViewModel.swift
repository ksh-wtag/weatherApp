import Foundation

protocol SuggestedLocationDelegate: AnyObject {
    func passSuggestedLocation(response: SuggestedLocationModel)
}

protocol RetrieveLocationDelegate: AnyObject {
    func passRetrievedLocation(latitude: Double, longitude: Double, locationName: String)
}

class SearchLocationViewModel {
    weak var suggestedLocationDelegate: SuggestedLocationDelegate?
    let suggestionNewtowrkManager = SuggestNewtowrkManager()
    weak var retrieveLocationDelegate: RetrieveLocationDelegate?
    let retrieveNetworkManager = RetrieveNetworkManager()
    
    func getSuggestedLocation(searchText: String) {
        suggestionNewtowrkManager.fetchLocationSuggetion(searchText: searchText, completionHandler: { response in
            if let response = response {
                self.suggestedLocationDelegate?.passSuggestedLocation(response: response)
            }
        })
    }
    
    func getRetrievedLocation(mapboxId: String) {
        retrieveNetworkManager.fetchRetrivedData(mapboxId: mapboxId, completionHandler: { response in
            if let response = response {
                let latitude = response.features[0].properties.coordinates.latitude
                let longitude = response.features[0].properties.coordinates.longitude
                let locationName = response.features[0].properties.name
                self.retrieveLocationDelegate?.passRetrievedLocation(latitude: latitude, longitude: longitude, locationName: locationName)
            }
        })
    }
}
