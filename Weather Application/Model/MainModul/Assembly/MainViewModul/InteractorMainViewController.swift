//
//  Interactor.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 22.06.2023.
//

import UIKit

protocol MainViewControllerInteractorProtocol {
    func providingWeatherData(in inputedTextInSearchBar: String)
}

class MainViewControllerInteractor: MainViewControllerInteractorProtocol {
    
//    MARK: - Properties
    
    var presenter: MainViewControllerPresenterProtocol?
    private let network = APIWeatherManager()
    
    //MARK: - make request to Network to get data for make reponse to Presenter
    
    func providingWeatherData(in inputedTextInSearchBar: String) {
        network.getWeatherByCoordinates(coordinates: Coordinates(city: inputedTextInSearchBar)) { (result) in
            switch result {
            case .succes(let weatherInSeveralDays):
                DispatchQueue.main.async { [unowned self] in
                    presenter?.responseFromInteractor(model: weatherInSeveralDays)
                }
            case.failure(let error):
                self.presenter?.getErrorFromInteractor(error: error as NSError)
            }
        }
    }
}
