//
//  APIVK.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 26.06.2023.
//

import Foundation

struct APIVK {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131."
    static let newsFeed = "/method/account.getProfileInfo"
}

final class APIVKontakteManagerRequest {
    
    private let authService: VKAuthService
    
    init(authService: VKAuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    private func makeURLRequest(path: String, params: [String : String]) -> URLRequest? {
        guard let token = authService.token else { return nil }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = APIVK.version
        let url = self.makeURL(from: path, params: allParams)
        let request = URLRequest(url: url)
        return request
    }
    
    private func makeURL(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = APIVK.scheme
        components.host = APIVK.host
        components.path = APIVK.newsFeed
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
extension APIVKontakteManagerRequest: DataFetcherProtocol {
    
    public func getAuth(complition: @escaping (Result<Any>) -> Void) {
        let allParams = ["filters": "post"]
        
        makeDataTask(urlRequest: makeURLRequest(path: APIVK.newsFeed, params: allParams), type: APIVKontakteManager.self, complitionHandler: complition)}
        
}
