//
//  Interactor.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 22.06.2023.
//

import UIKit

protocol MainViewControllerInteractorProtocol {
    func providingWeatherData(in inputedTextInSearchBar: String)
    func providingVKontakteData()
}

class MainViewControllerInteractor: MainViewControllerInteractorProtocol {
    
    //    MARK: - Properties
    
    var presenter: MainViewControllerPresenterProtocol?
    private let weatherManagerNetwork = APIWeatherManagerRequest()
    private let VKontakteNetwork = APIVKontakteManagerRequest()
    
    //MARK: - make request to VKontakteNetwork to get data and provide it to Presenter

    func providingVKontakteData() {
        
        VKontakteNetwork.getAuth { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .succes(let result):
                    self.presenter?.responseFromInteractorWithProfile(model: result as! APIVKontakteManager)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - make request to WeatherManagerNetwork to get data and provide it to Presenter

    func providingWeatherData(in inputedTextInSearchBar: String) {
        
        weatherManagerNetwork.getWeather(coordinates: Coordinates(city: inputedTextInSearchBar)) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .succes(let result):
                    self.presenter?.responseFromInteractor(model: result as! APIWeatherManager)
                case .failure(let error):
                    self.presenter?.getErrorFromInteractor(error: error as NSError)
                }
            }
        }
    }
}
