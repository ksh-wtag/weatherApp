import UIKit
import MapboxSearch
import MapboxSearchUI

protocol SearchLocationDelegate: AnyObject {
    func getLocationInformation(locationName: String, latitude: Double, longitude: Double)
}

class SearchLocationViewController: UIViewController {
    var searchController = MapboxSearchController()
    weak var delegate: SearchLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)
    }
}

extension SearchLocationViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: MapboxSearchUI.SearchCategory, results: [any MapboxSearch.SearchResult]) {
    }
    
    func categorySearchResultsReceived(results: [SearchResult]) {
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        let locationName = searchResult.name
        let location = searchResult.placemark.location!.coordinate
        let latitude = location.latitude
        let longitude = location.longitude
        delegate?.getLocationInformation(locationName: locationName,latitude: latitude, longitude: longitude)
        navigationController?.popViewController(animated: true)
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
    }
}

