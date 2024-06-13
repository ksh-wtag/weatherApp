import Foundation

class SuggestNetworkManager {
    func fetchLocationSuggetion(searchText: String, completionHandler: @escaping(SuggestedLocationModel?) -> Void) {
        let url = URL(string: "https://api.mapbox.com/search/searchbox/v1/suggest?q=\(searchText)&language=en&session_token=&access_token=pk.eyJ1IjoiLXJhdHVsLSIsImEiOiJjbHdvbnhkbHQybTIwMmttajdmeHEyNXh1In0.m4VC17opYXOoFeRo5jyKXg")
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let fetchSuggestionList: SuggestedLocationModel?
                fetchSuggestionList = try JSONDecoder().decode(SuggestedLocationModel.self, from: data)
                if let fetchSuggestionList = fetchSuggestionList {
                    completionHandler(fetchSuggestionList)
                }else {
                    completionHandler(nil)
                }
            }
            catch{
                print("Error : \(error.localizedDescription)1")
            }
        }).resume()
    }
}
