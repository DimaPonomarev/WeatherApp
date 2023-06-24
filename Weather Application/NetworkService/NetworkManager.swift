//
//  NetworkManager.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import Foundation

enum Result<Forecast> {
    case succes(forecastWeather: Forecast)
    case failure(Error)
}

protocol URLPathProtocol {
    var baseURL: URL {get}
    var path: String {get}
    var APIKey: String {get}
    var requestWithFullURL: URLRequest {get}
}

protocol NetworkManageProtocol {
    
    func JSONDataTask(request: URLRequest, complition: @escaping (Any?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask
    func fetch<forecast>(request: URLRequest, parse: @escaping((Any?) -> (forecast)?), complitionHandler: @escaping(Result<forecast>) -> Void)
}

extension NetworkManageProtocol {
    
    //MARK: - JSONDataTask

    func JSONDataTask(request: URLRequest, complition: @escaping (Any?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "Missed HTTPURLResponse", code: 100)
                complition(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    complition(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        let json = try jsonDecoder.decode(ForecastWeather.self, from: data!)
                        complition(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        complition(nil, HTTPResponse, error)
                    }
                    
                default:
                    complition(nil, HTTPResponse, error)
                }
            }
        }
        return dataTask
    }
    
    //MARK: - fetch

    func fetch<Forecast>(request: URLRequest, parse: @escaping((Any?) -> (Forecast)?), complitionHandler: @escaping(Result<Forecast>) -> Void) {

        let dataTask = JSONDataTask(request: request) { all, request, error in
            guard all != nil else {
                if let error = error {
                    complitionHandler(.failure(error))
                }
                return
            }
            if let value = parse(all) {
                complitionHandler(.succes(forecastWeather: value))
            } else {
                let error = NSError(domain: "Can't parse JSON", code: 101)
                complitionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
}


