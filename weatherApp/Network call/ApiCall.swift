//
//  ApiCall.swift
//  weatherApp
//
//  Created by Kazi Shakawat Hossain Ratul on 7/5/24.
//

import Foundation

func fetchData(completionHandler:  @escaping (weatherInfoData) -> Void) {
    
    
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=23.810331&lon=90.412521&units=metric&appid=f7fba2a96004431c6e3b90fb0728bd89")
    let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        guard let data = data, error == nil else {
            print("error!!!!")
            return
        }
        var fetchedWeatherData: weatherInfoData?
        do{
            fetchedWeatherData = try JSONDecoder().decode(weatherInfoData.self, from: data)
            completionHandler(fetchedWeatherData!)
        }
        catch{
            print("Error : \(error.localizedDescription)")
        }
    }
    
    dataTask.resume()
}
