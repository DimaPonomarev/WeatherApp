//
//  File.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 23.06.2023.
//

import UIKit

class WebImageView: UIImageView {
    
    func setWeatherImage(imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {return}
        if let cashedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cashedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let data = data, let response = response else { return }
                
                self.image = UIImage(data: data)
                self.handleLoadImage(data: data, response: response)
            }
        }
        dataTask.resume()
    }
    
    func setProfileImage(imageUrl: String?, complition: @escaping ((UIImage) -> Void)) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let data = data else { return }
                self.image = UIImage(data: data)
                guard let readyToUseImage = self.image else { return }
                complition(readyToUseImage)
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadImage(data: Data, response: URLResponse) {
        guard let respnseUrl = response.url else { return }
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: URLRequest(url: respnseUrl))
    }
}
