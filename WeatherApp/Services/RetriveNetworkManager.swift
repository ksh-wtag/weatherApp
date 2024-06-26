import Foundation

class RetriveNetworkManager {
    func fetchRetrivedData(mapboxId: String, completionHandler:  @escaping (Retrieve?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://api.mapbox.com/search/searchbox/v1/retrieve/\(mapboxId)?session_token=&access_token=pk.eyJ1IjoiLXJhdHVsLSIsImEiOiJjbHdvbnhkbHQybTIwMmttajdmeHEyNXh1In0.m4VC17opYXOoFeRo5jyKXg")
            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error)  in
                guard let data = data, error == nil else {
                    print("Error : \(error!.localizedDescription)")
                    completionHandler(nil)
                    return
                }
                do{
                    let fetchedRetrivedData: Retrieve?
                    fetchedRetrivedData = try JSONDecoder().decode(Retrieve.self, from: data)
                    if let fetchedRetrivedData = fetchedRetrivedData {
                        completionHandler(fetchedRetrivedData)
                    } else {
                        completionHandler(nil)
                    }
                }
                catch{
                    print("Error : \(error.localizedDescription)2")
                }
            }
            dataTask.resume()
        }
    }
}
