//
//  APIWeatherManager.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation

struct Coordinates {
    let city: String
}

//MARK: - Enum Forecast

enum Forecast: URLPathProtocol {
    
    case current (coordinates: Coordinates)
    
    var baseURL: URL {
        return URL(string: "https://api.weatherapi.com/")!
    }
    var APIKey: String {
        return "69e2f72efad44bd59b623004230604"
    }
    var path: String {
        switch self {
        case .current(let coordinates):
            return "v1/forecast.json?key=\(self.APIKey)&q=\(coordinates.city)&days=14&aqi=no&lang=ru"
        }
    }
    var requestWithFullURL: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        return URLRequest(url: url)
    }
}

//MARK: - APIWeatherManager

class APIWeatherManager: NetworkManageProtocol {
    
    var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func getWeatherByCoordinates(coordinates:Coordinates, complition: @escaping (Result<WeatherListDuringThreeDays, CurrentLocation>) -> Void) {
        let request = Forecast.current(coordinates: coordinates).requestWithFullURL
        fetch(request: request, parse: { (json) -> (WeatherListDuringThreeDays, CurrentLocation)? in

            if let dictionaryLocation = (json as AnyObject)["location"] as? [String: AnyObject],
               let JSONforecast = (json as AnyObject)["forecast"] as? [String: AnyObject],
               let weatherListinEachDate = JSONforecast["forecastday"] as? NSArray
            {
                return (WeatherListDuringThreeDays(forecastDay: weatherListinEachDate), CurrentLocation(JSON: dictionaryLocation)) as? (WeatherListDuringThreeDays, CurrentLocation)
            } else {
                return nil
            }
        }, complitionHandler: complition)
    }
}
