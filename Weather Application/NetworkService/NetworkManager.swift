//
//  AllNetworking.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 24.06.2023.
//

import Foundation

enum Result<ParsedModel> {
    case succes(result: ParsedModel)
    case failure(Error)
}

protocol DataFetcherProtocol {
    
    func makeDataTask(urlRequest: URLRequest?, type: Decodable.Type, complitionHandler: @escaping(Result<Any>) -> Void)
}

extension DataFetcherProtocol {

    //  MARK: - In this block getting URLRequest and URLSessionDataTask to make response(no matter which model will come)
    
    public func makeDataTask(urlRequest: URLRequest?, type: Decodable.Type, complitionHandler: @escaping(Result<Any>) -> Void) {
        guard let request = urlRequest else {
            let error = NSError(domain: "Invalid URL", code: 522)
            complitionHandler(.failure(error))
            return
        }
        let task = JSONDataTask(type: type, request: request) { (data, response, error)  in
            guard let data = data  else {
                let error = NSError(domain: "Can't parse JSON", code: 101)
                complitionHandler(.failure(error))
                return
            }
            complitionHandler(.succes(result: data))
        }
        task.resume()
    }
    
    //  MARK: - In this block making data, response, error from network and JSONDecoder
    
    private func JSONDataTask(type: Decodable.Type, request: URLRequest, complition: @escaping (Any?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
            
            DispatchQueue.global().async {
                guard let HTTPResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "Missed HTTPURLResponse", code: 100)
                    complition(nil, nil, error)
                    return
                }
                if let error = error {
                        complition(nil, HTTPResponse, error)
                } else if let data = data {
                    switch HTTPResponse.statusCode {
                    case 200:
                        let json = self.decodeJson(type: type, from: data)
                        if json != nil {
                            complition(json, HTTPResponse, nil)
                        } else {
                            let error = NSError(domain: "Invalid data; couldn't parse JSON object, array, or value. Perhaps you're using invalid characters in your key names.", code: 204)
                            complition(nil, HTTPResponse, error)
                        }
                    default:
                        complition(nil, HTTPResponse, error)
                    }
                }
            }
        }
        return dataTask
    }
    
    //  MARK: - in this block parsing JSONData
    
    private func decodeJson<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data else {return nil}
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            return nil
        }
    }
}
