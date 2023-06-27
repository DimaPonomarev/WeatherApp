//
//  File.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 23.06.2023.
//

import UIKit

class WebImageView: UIImageView {
    
    func set(imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {return}
        if let cashedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cashedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data, let response = response else { return }
                self?.image = UIImage(data: data)
                self?.handleLoadImage(data: data, response: response)
            }
        }
        dataTask.resume()
    }
    
    func setim(imageUrl: String?, complition: @escaping (UIImage?) -> Void) -> UIImage? {
//        var ima = UIImage()
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {return nil}
        if let cashedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cashedResponse.data)!
            return self.image
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let data = data, let response = response else { return }
                self.image = UIImage(data: data)
                self.handleLoadImage(data: data, response: response)
                complition(self.image)
            }
        }
        dataTask.resume()
        return self.image
    }
    
    
    
    func handleLoadImage(data: Data, response: URLResponse) {
        guard let respnseUrl = response.url else { return }
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: URLRequest(url: respnseUrl))
    }
}
