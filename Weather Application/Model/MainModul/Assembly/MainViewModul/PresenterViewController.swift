//
//  PresenterViewController.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation
import UIKit

//MARK: - MainViewControllerPresenterProtocol

protocol MainViewControllerPresenterProtocol: AnyObject {
    
    var view: MainViewControllerProtocol? {get}
    var weatherArrayOfSeveralDays: [(InfoAboutDayWeather?, Icon?, String?, CurrentLocation)] {get}
    var weatherArrayToday: [(WeatherInEachHour?, Icon?, CurrentLocation)] {get}
    
    func providingDataForSetingWeather(inputedTextInSearchBar: String)
    func setCurrentLocation()
    
}

//MARK: - MainViewControllerPresenter

class MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    private let network = APIWeatherManager()
    private var setLocationFromSearchBar: CurrentLocation?
    public var weatherArrayOfSeveralDays: [(InfoAboutDayWeather?, Icon?, String?, CurrentLocation)]
    public var weatherArrayToday: [(WeatherInEachHour?, Icon?, CurrentLocation)]
    private let locationManager = LocationManager()
    
    //MARK: - Init
    
    init(weatherArrayOfThreeDays: [(InfoAboutDayWeather?, Icon?, String?, CurrentLocation)], weatherArrayOfCurrentDay: [(WeatherInEachHour?, Icon?, CurrentLocation)]) {
        self.weatherArrayOfSeveralDays = weatherArrayOfThreeDays
        self.weatherArrayToday = weatherArrayOfCurrentDay
        setCurrentLocation()
    }
    
    //MARK: - providingDataForSetingWeather
    
    func providingDataForSetingWeather(inputedTextInSearchBar: String) {
        network.getWeatherByCoordinates(coordinates: Coordinates(city: inputedTextInSearchBar)) { (result) in
            switch result {
            case .succes(let infoAboutThreeDays, let location):
                DispatchQueue.main.async { [unowned self] in
                    self.setLocationFromSearchBar = location
                    self.weatherArrayOfSeveralDays = self.makeArraysFromRequestOfSeveralDaysInEachHourAndDayInLocation(infoAboutThreeDays: infoAboutThreeDays, curentLocation: location)?.0 ?? ([])
                    self.weatherArrayToday = self.makeArraysFromRequestOfSeveralDaysInEachHourAndDayInLocation(infoAboutThreeDays: infoAboutThreeDays, curentLocation: location)?.1 ?? ([])
                    self.view?.success(displayWeatherNowInChangedLocations: weatherArrayToday, loca: location)
                }
            case.failure(let error):
                self.view?.error(error: error as NSError)
            }
        }
    }
    
    //MARK: - setCurrentLocation
    
    func setCurrentLocation() {
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("exposedLocation is nil")
            return
        }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var value = ""
            if let town = placemark.locality {
                value = "\(town)"
                value = value.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.providingDataForSetingWeather(inputedTextInSearchBar: value)
            }
        }
    }
    
    //MARK: - getCurrentDate
    
    private func getCurrentDate(chosenLocation: CurrentLocation) -> (String, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDateInDateFormat = formatter.date(from: chosenLocation.localTime ?? "No Date") ?? Date()
        formatter.dateFormat = "yyyy-MM-dd HH:00"
        let updatedcurrentDateInStringFormat = formatter.string(from: currentDateInDateFormat)
        let updatedcurrentDateInDateFormat = formatter.date(from: updatedcurrentDateInStringFormat) ?? Date()
        return (updatedcurrentDateInStringFormat, updatedcurrentDateInDateFormat)
    }
    
    //MARK: - makeArraysFromRequestOfSeveralDaysInEachHourAndDayInLocation
    
    private func makeArraysFromRequestOfSeveralDaysInEachHourAndDayInLocation(infoAboutThreeDays: WeatherListDuringThreeDays, curentLocation: CurrentLocation) ->  ([(InfoAboutDayWeather?, Icon?, String?, CurrentLocation)], [(WeatherInEachHour?, Icon?, CurrentLocation)])? {
        
        weatherArrayOfSeveralDays.removeAll()
        weatherArrayToday.removeAll()
        
        //        информация по каждому часу из целого дня
        
        for each in 0...1 {
            
            guard  let jsonToday = infoAboutThreeDays.forecastDay[each] as? [String:AnyObject],
                   let arrayOfTodayWeather = jsonToday["hour"] as? Array<[String:AnyObject]> else { return nil}
            
            for eachHour in arrayOfTodayWeather {
                guard let jsonTodayAllHoursCondition = eachHour["condition"] as? [String:AnyObject],
                      let iconOfWeatherOfEachHour = jsonTodayAllHoursCondition["icon"] as? String,
                      let descriptionOfWeatherOfEachHour = jsonTodayAllHoursCondition["text"] as? String else {return nil}
                
                let eachHourInArray = (WeatherInEachHour(JSON: eachHour))
                if eachHourInArray!.weatherTime >= getCurrentDate(chosenLocation: curentLocation).1 {
                    self.weatherArrayToday.append((eachHourInArray, Icon(descriptionOfWeather: descriptionOfWeatherOfEachHour, iconOfWeatherAsString: iconOfWeatherOfEachHour), curentLocation))
                }
            }
        }

        //        информация в целом о дне по всем дням
        
        for eachDay in infoAboutThreeDays.forecastDay {
            if let eachDayAsDictionari = eachDay as? [String:AnyObject] {
                guard let infoAboutDays = eachDayAsDictionari["day"] as? [String:AnyObject],
                      let infoAboutDaysCondition = infoAboutDays["condition"] as? [String:AnyObject],
                      let iconOfWeatherOfEachDay = infoAboutDaysCondition["icon"] as? String,
                      let descriptionOfWeatherOfEachDay = infoAboutDaysCondition["text"] as? String,
                      let dateOfEachDay = eachDayAsDictionari["date"] as? String else { return nil }

                self.weatherArrayOfSeveralDays.append((InfoAboutDayWeather(JSON: infoAboutDays), Icon(descriptionOfWeather: descriptionOfWeatherOfEachDay, iconOfWeatherAsString: iconOfWeatherOfEachDay), dateOfEachDay, curentLocation))
            }
        }
        return (weatherArrayOfSeveralDays, weatherArrayToday)
    }
}
