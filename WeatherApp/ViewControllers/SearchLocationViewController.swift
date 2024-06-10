import UIKit
import MapboxMaps

protocol SearchLocationDelegate: AnyObject {
    func getLocationInformation(latitude: Double, longitude: Double, locationName: String)
}

class SearchLocationViewController: UIViewController {
    @IBOutlet weak var suggestionSearchBar: UISearchBar!
    @IBOutlet weak var SuggestionTableView: UITableView!
    @IBOutlet weak var mapViewController: UIView!
    
    var suggestedLocation: SuggestedLocation?
    let suggestNetworkCall = SuggestNewtowrkManager()
    var retriveCoordinates: Retrieve?
    let retriveNetworkCall = RetriveNetworkManager()
    weak var delegate: SearchLocationDelegate?
    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        SuggestionTableView.isUserInteractionEnabled = false
        setMapAndGestureAction()
    }
    
    func registerNibFile() {
        let nib = UINib(nibName: "SuggestionTableViewCell", bundle: nil)
        SuggestionTableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    func setMapAndGestureAction() {
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 23.763565654470767, longitude: 90.38946110570834), zoom: 12)
        let mapInitOptions = MapInitOptions(cameraOptions: cameraOptions, styleURI: .light)
        mapView = MapView(frame: mapViewController.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapViewController.addSubview(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: tapPoint)
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        delegate?.getLocationInformation(latitude: latitude, longitude: longitude, locationName: "")
        navigationController!.popViewController(animated: true)
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 4 {
            suggestNetworkCall.fetchLocationSuggetion(searchText: searchText, completionHandler: { response in
                DispatchQueue.main.async {
                    self.suggestedLocation = response
                    self.SuggestionTableView.reloadData()
                }
            })
        }
    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        retriveNetworkCall.fetchRetrivedData(mapboxId: suggestedLocation?.suggestions[indexPath.row].mapbox_id ?? "", completionHandler: { response in
            self.retriveCoordinates = response
            let latitude = self.retriveCoordinates!.features[0].properties.coordinates.latitude
            let longitude = self.retriveCoordinates!.features[0].properties.coordinates.longitude
            let locationName = self.retriveCoordinates!.features[0].properties.name
            self.delegate?.getLocationInformation(latitude: latitude, longitude: longitude, locationName: locationName)
        })
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedLocation?.suggestions.count ?? 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 0 {
            updateTableViewInteraction()
        }
        let cell = SuggestionTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuggestionTableViewCell
        cell.suggestionLabel.text = suggestedLocation?.suggestions[indexPath.row].name ?? ""
        return cell
    }
    
    func updateTableViewInteraction() {
        SuggestionTableView.isUserInteractionEnabled = true
    }
}
