import UIKit

protocol SearchCityDelegate: AnyObject {
    func passCoordinate(latitude: Double, longitude: Double)
}

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locationList: [CityModel]?
    var searchData = [CityModel]()
    weak var delegate: SearchCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCityList()
        registerCustomLocationCell()
        searchData = locationList ?? []
    }
    
    func registerCustomLocationCell() {
        let nib = UINib(nibName: "LocationTableViewCell", bundle: nil)
        locationTableView.register(nib, forCellReuseIdentifier: "locationTableViewCell")
    }
    
    func prepareCityList() {
        let dhaka = CityModel(name: "Dhaka",latitude: 23.7104,longitude: 90.4074)
        let rajshahi = CityModel(name: "Rajshahi",latitude: 24.3667,longitude: 88.6)
        let khulna = CityModel(name: "Khulna",latitude: 22.8135,longitude: 89.5672)
        let rangpur = CityModel(name: "Rangpur",latitude: 25.75,longitude: 89.25)
        let barishal = CityModel(name: "Barishal",latitude: 22.5,longitude: 90.3333)
        let chattogram = CityModel(name: "Chattogram",latitude: 22.9167,longitude: 91.5)
        let sylhet = CityModel(name: "Sylhet",latitude: 24.5,longitude: 91.6667)
        
        locationList = [dhaka, rajshahi, khulna, rangpur, barishal, chattogram, sylhet]
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = []
        
        guard let searchInput = searchCity.text, let locationList = locationList else {
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

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
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
