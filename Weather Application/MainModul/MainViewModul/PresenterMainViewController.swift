//
//  PresenterViewController.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation
import UIKit
import CoreLocation

//MARK: - MainViewControllerPresenterProtocol

protocol MainViewControllerPresenterProtocol: AnyObject {
    
    var view: MainViewControllerProtocol? {get}
    var tableViewModel: [ModelForTableView]? {get}
    var collectionViewModel: [ModelForCollectionView]? {get}
    func makeRequestToInteractorToProvideWeatherData(in specifiedCityEnteredInSearchBar: String)
    func responseFromInteractor(model: APIWeatherManager)
    func responseFromInteractorWithProfile(model: APIVKontakteManager)
    func getErrorFromInteractor(error: Error)
}

//MARK: - MainViewControllerPresenter

final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    
    var interactor: MainViewControllerInteractorProtocol?
    weak var view: MainViewControllerProtocol?
    private let locationManager = LocationManager()
    public var topViewModel: ModelForTopView?
    public var tableViewModel: [ModelForTableView]?
    public var collectionViewModel: [ModelForCollectionView]?
    
    
    //MARK: - Init for present weather at the begginig of using app in users position
    
    init()  {
        setCurrentLocation()
    }
    
    //MARK: - get press from view when user edit country and now presenter send request to interactor with choosen city to show result in view
    
    public func makeRequestToInteractorToProvideWeatherData(in inputedTextInSearchBar: String) {
        interactor?.providingWeatherData(in: inputedTextInSearchBar)
        interactor?.providingVKontakteData()
    }
    
    //    MARK: - interactor couldnt response and provide error
    
    public func getErrorFromInteractor(error: Error) {
        print("GetErrorFromInteractor")
    }
    
    //MARK: - response from interactor and transfer ready to use models to MainViewController
    
    public func responseFromInteractor(model: APIWeatherManager) {
        topViewModel = convertDataToTopViewModel(dataSource: model)
        tableViewModel = convertDataToTableViewModel(dataSource: model)
        collectionViewModel = convertDataToCollectionViewModel(dataSource: model)
        view?.passDataFromPresenterToViewController(model: topViewModel!)
    }
    
    public func responseFromInteractorWithProfile(model: APIVKontakteManager) {
        let profileModel = ModelProfile(image: model.response.photo200)
        view?.passProfileDataFromPresenterToViewController(profileModel: profileModel)
    }
}

//MARK: - extension to convert response from Interactor to needed to use models

private extension MainViewControllerPresenter {
    
    //MARK: - convert response from interactor to model, used on topView of MainViewController
    
    func convertDataToTopViewModel(dataSource: APIWeatherManager) -> ModelForTopView {
        guard let todaysWeatherPerEachHour = dataSource.forecast.forecastday[0].hour.first(where: {
            $0.time == getCurrentLocalDate(in: dataSource.location) }) else {
            return ModelForTopView(temperature: 0,
                                   isDay: 0,
                                   pressure: 0,
                                   humidity: 0,
                                   apparentTemperature: 0,
                                   windSpeed: 0,
                                   description: "",
                                   icon: "",
                                   isRain: 0,
                                   cityLocation: "") }
        
        return ModelForTopView(temperature: todaysWeatherPerEachHour.tempC,
                               isDay: todaysWeatherPerEachHour.isDay,
                               pressure: todaysWeatherPerEachHour.pressureMb,
                               humidity: todaysWeatherPerEachHour.humidity,
                               apparentTemperature: todaysWeatherPerEachHour.feelslikeC,
                               windSpeed: todaysWeatherPerEachHour.windKph,
                               description: todaysWeatherPerEachHour.condition.text,
                               icon: todaysWeatherPerEachHour.condition.icon,
                               isRain: todaysWeatherPerEachHour.chanceOfRain,
                               cityLocation: "\(dataSource.location.name), \(dataSource.location.country)")
    }
    
    //MARK: - convert response from interactor to model, used in CollectionView on MainViewController
    
    func convertDataToCollectionViewModel(dataSource: APIWeatherManager?) -> [ModelForCollectionView] {
        guard let model = dataSource else {
            return [ModelForCollectionView(time: "",
                                           tempC: 0,
                                           icon: "",
                                           timeZone: "")] }
        
        var arrayOfCollectionViewModel: [ModelForCollectionView] = []
        let todaysWeatherInEachHour = model.forecast.forecastday[0].hour
        let tomorrowsWeatherInEachHour = model.forecast.forecastday[1].hour
        let todaysAndTomorrowsWeatherInEachHour = todaysWeatherInEachHour + tomorrowsWeatherInEachHour
        for weatherInEachHour in todaysAndTomorrowsWeatherInEachHour {
            if  weatherInEachHour.time >= getCurrentLocalDate(in: model.location) {
                arrayOfCollectionViewModel.append(ModelForCollectionView(time: weatherInEachHour.time,
                                                                         tempC: weatherInEachHour.tempC,
                                                                         icon: weatherInEachHour.condition.icon,
                                                                         timeZone: model.location.tzId))
            }
        }
        return arrayOfCollectionViewModel
    }
    
    //MARK: - convert response from interactor to model, used in TableView on MainViewController
    
    func convertDataToTableViewModel(dataSource: APIWeatherManager?) -> [ModelForTableView] {
        guard let model = dataSource else { return [ModelForTableView(maxtempC: 0,
                                                                      mintempC: 0,
                                                                      date: "",
                                                                      icon: "",
                                                                      timeZone: "")] }
        var arrayOfTableViewModel: [ModelForTableView] = []
        for eachDay in model.forecast.forecastday {
            arrayOfTableViewModel.append(ModelForTableView(maxtempC: eachDay.day.maxtempC,
                                                           mintempC: eachDay.day.mintempC,
                                                           date: eachDay.date,
                                                           icon: eachDay.day.condition.icon,
                                                           timeZone: model.location.tzId)) }
        return arrayOfTableViewModel
    }
    
    //MARK: - getCurrentDate
    
    func getCurrentLocalDate(in chosenLocation: APIWeatherManager.CurrentLocation) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentLocalDateInDateFormat = formatter.date(from: chosenLocation.localtime ) ?? Date()
        formatter.dateFormat = "yyyy-MM-dd HH:00"
        let currentLocalDateInStringFormat = formatter.string(from: currentLocalDateInDateFormat)
        return currentLocalDateInStringFormat
    }
    
    //MARK: - setCurrentLocation
    
    func setCurrentLocation() {
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("exposedLocation is nil")
            return
        }
        self.locationManager.getPlace(for: exposedLocation) { [weak self] placemark in
            guard let self = self else { return }
            guard let placemark = placemark else { return }
            if let town = placemark.locality {
                var value = "\(town)"
                value = value.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.makeRequestToInteractorToProvideWeatherData(in: value)
            }
        }
    }
}
