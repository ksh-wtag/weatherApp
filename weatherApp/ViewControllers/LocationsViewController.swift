import UIKit

protocol PassCityInfo {
    func passCoordinate(latitude: Double, longitude: Double)
}

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locationList = [dhaka, rajshahi, khulna, rangpur, barishal, chattogram, sylhet]
    var searchData = [city]()
    var delegate: PassCityInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LocationTableViewCell", bundle: nil)
        locationTableView.register(nib, forCellReuseIdentifier: "locationTableViewCell")
        
        searchData = locationList
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "locationTableViewCell", for: indexPath) as! LocationTableViewCell
        cell.locationCustomCell.text = searchData[indexPath.row].name
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = []
        
        for city in locationList {
            if searchCity.text == "" {
                searchData = locationList
            }
            else {
                if city.name.lowercased().contains(searchCity.text!.lowercased()) {
                    searchData.append(city)
                }
            }
        }
        locationTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameOfCity = locationList[indexPath.row].name
        for city in locationList {
            if nameOfCity == city.name {
                delegate!.passCoordinate(latitude: city.latitude , longitude: city.longitude)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
