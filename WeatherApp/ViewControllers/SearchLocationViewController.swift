import UIKit

protocol SearchLocationDelegate: AnyObject {
    func getLocationInformation(latitude: Double, longitude: Double, locationName: String)
}

class SearchLocationViewController: UIViewController {
    @IBOutlet weak var suggestionSearchBar: UISearchBar!
    @IBOutlet weak var SuggestionTableView: UITableView!
    
    var suggestedLocation: SuggestedLocation?
    var suggestNetworkCall = SuggestNewtowrkCall()
    var retriveCoordinates: Retrive?
    var retriveNetworkCall = RetriveNetworkCall()
    weak var delegate: SearchLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SuggestionTableViewCell", bundle: nil)
        SuggestionTableView.register(nib, forCellReuseIdentifier: "cell")
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
        let cell = SuggestionTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuggestionTableViewCell
        cell.suggestionLabel.text = suggestedLocation?.suggestions[indexPath.row].name ?? ""
        return cell
    }
}
