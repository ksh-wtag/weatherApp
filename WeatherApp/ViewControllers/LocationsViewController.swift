import UIKit

protocol PassCityInfo: AnyObject {
    func passCoordinate(latitude: Double, longitude: Double)
}

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    let locationList = [dhaka, rajshahi, khulna, rangpur, barishal, chattogram, sylhet]
    var searchData = [City]()
    weak var delegate: PassCityInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomLocationCell()
        searchData = locationList
    }
    
    func registerCustomLocationCell() {
        let nib = UINib(nibName: "LocationTableViewCell", bundle: nil)
        locationTableView.register(nib, forCellReuseIdentifier: "locationTableViewCell")
    }
}

extension LocationsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = []
    
        guard let searchInput = searchCity.text else {
            return
        }
        if searchInput.isEmpty {
            searchData = locationList
        }
        else {
            searchData = locationList.filter({
                $0.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        locationTableView.reloadData()
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "locationTableViewCell", for: indexPath) as! LocationTableViewCell
        cell.locationCustomCell.text = searchData[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let city = searchData.first(where: {$0.name == searchData[indexPath.row].name}) {
            delegate?.passCoordinate(latitude: city.latitude, longitude: city.longitude)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
