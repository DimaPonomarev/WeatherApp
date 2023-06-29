//
//  APIWM.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 24.06.2023.
//https://api.weatherapi.com/v1/forecast.json?key=69e2f72efad44bd59b623004230604&q=SanFrancisco&days=14&aqi=no&lang=ru --

import Foundation

struct  APIWM {
    static let baseURL = "https://api.weatherapi.com/"
    private let apiKey = "69e2f72efad44bd59b623004230604"
    private var city: String
    var path: String
    
    init(city: String) {
        self.city = city
        self.path = "v1/forecast.json?key=\(self.apiKey)&q=\(city))&days=14&aqi=no&lang=ru"
    }
}

struct Coordinates  {
    let city: String
}

final class APIWeatherManagerRequest: DataFetcherProtocol {
    
    public func getWeather(coordinates:Coordinates, complition: @escaping ((Result<Any>) -> Void)) {
        makeDataTask(urlRequest: makeURLRequest(coordinates: coordinates), type: APIWeatherManager.self, complitionHandler: complition)
    }
}

private extension APIWeatherManagerRequest {
    
    func makeURL(coordinates: Coordinates) -> URL? {
        let urlString = "\(APIWM.baseURL)\(APIWM(city: coordinates.city).path)"
        let url = URL(string: urlString)
        return url
    }
    
    func makeURLRequest(coordinates: Coordinates) -> URLRequest? {
        guard let url = makeURL(coordinates: coordinates) else { return nil }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}



