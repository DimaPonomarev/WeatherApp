//
//  ModelForVC.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 23.06.2023.
//

import UIKit


struct ModelForTopView {
    let temperature: Double
    let isDay: Int
    let pressure: Int
    let humidity: Int
    let apparentTemperature: Double
    let windSpeed: Double
    let description: String
    let icon: String
    let isRain: Int
    let cityLocation: String
}

extension ModelForTopView {
    
    var weatherTemprature: String { return "\(Int(temperature))˚C" }
    var weatherWindSpeed: String { return "Скорость ветра: \(Int(windSpeed)) м/c" }
    var weatherAppearentTemperature: String { return "Ощущается как: \(Int(apparentTemperature))˚C" }
    var weatherHumidity: String { return "Влажность воздуха: \(Int(humidity))%" }
    var weatherPressure: String { return "Атм. давление: \(Int(pressure)) mm" }
    var iconURL:String { return "https:\(icon)" }
    var switchNightDay: UIImage? {
        switch isDay {
        case 0: return UIImage(named: "night")
        default: return UIImage(named: "day")
        }
    }
    var switchRain: Bool {
        switch isRain {
        case 60...100: return false
        default: return true
        }
    }
}
struct ModelForTableView {
    let maxtempC: Double
    let mintempC: Double
    let date: String
    let icon: String
    let timeZone: String
    
}

extension ModelForTableView {
    var maxWeatherTemperature: String { return "\(Int(maxtempC))˚C" }
    var minWeatherTemperature: String { return "\(Int(mintempC))˚C" }
    var iconURL: String { return "https:\(icon)" }
}

struct ModelForCollectionView {
    let time: String
    let tempC: Double
    var icon: String
    let timeZone: String
    
}

extension ModelForCollectionView {
    var weatherTime: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateInDate = formatter.date(from: time)!
        return dateInDate
    }
    var temperature: String { return "\(Int(tempC))˚C" }
    var iconURL: String { return "https:\(icon)" }
}



