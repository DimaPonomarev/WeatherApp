//
//  CurrentWeather.swift
//  MyWeatherAPP
//
//  Created by Дмитрий Пономарев on 22.03.2023.
//

import UIKit

protocol JSONDecodable {
    init?(JSON: [String:AnyObject])
}

//MARK: - CurrentLocation

struct CurrentLocation {
    let name: String
    let country: String
    var localTime: String?
    let timeZone: String
}

extension CurrentLocation: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String,
              let country = JSON["country"] as? String,
              let timeZone = JSON["tz_id"] as? String,
              let localTime = JSON["localtime"] as? String else {
            return nil
        }
        self.name = name
        self.country = country
        self.localTime = localTime
        self.timeZone = timeZone
    }
}
extension CurrentLocation {
    private var newTime: String {
        get { localTime! }
        set { localTime?.removeLast(2)}
    }
    var news: String { return newTime }
}

//MARK: - WeatherInEachHour

struct WeatherInEachHour: Decodable {
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let time: String
    let isDay: Int
    let chanceOfRain: Double
}

extension WeatherInEachHour: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temp_c"] as? Double,
              let apparentTemperature = JSON["feelslike_c"] as? Double,
              let humidity = JSON["humidity"] as? Double,
              let pressure = JSON["pressure_mb"] as? Double,
              let windSpeed = JSON["wind_mph"] as? Double,
              let isDay = JSON["is_day"] as? Int,
              let chanceOfRain = JSON["chance_of_rain"] as? Double,
              let time = JSON["time"] as? String else {
            return nil
        }
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.isDay = isDay
        self.time = time
        self.chanceOfRain = chanceOfRain
    }
}

extension WeatherInEachHour {
    var weatherTime: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateInDate = formatter.date(from: time)!
        return dateInDate
    }
    
    var weatherTemprature: String { return "\(Int(temperature))˚C" }
    var weatherWindSpeed: String { return "Скорость ветра: \(Int(windSpeed)) м/c" }
    var weatherAppearentTemperature: String { return "Ощущается как: \(Int(apparentTemperature))˚C" }
    var weatherHumidity: String { return "Влажность воздуха: \(Int(humidity))%" }
    var weatherPressure: String { return "Атм. давление: \(Int(pressure)) mm" }
}

//MARK: - Icon

struct Icon {
    let descriptionOfWeather: String
    let iconOfWeatherAsString: String
}

extension Icon: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let icon = JSON["icon"] as? String,
              let text = JSON["text"] as? String else {
            return nil
        }
        self.iconOfWeatherAsString = icon
        self.descriptionOfWeather = text
    }
}

extension Icon {
    var image: URL? {
        guard let url = URL(string: "https:" + iconOfWeatherAsString) else {return nil}
        return url
    }
}

//MARK: - InfoAboutDayWeather

struct InfoAboutDayWeather: Decodable {
    let maxTemp: Double
    let minTemp: Double
}

extension InfoAboutDayWeather: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let maxTemp = JSON["maxtemp_c"] as? Double,
        let minTemp = JSON["mintemp_c"] as? Double else {
            return nil
        }
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}

extension InfoAboutDayWeather {
    var maxWeatherTemperature: String { return "\(Int(maxTemp))˚C" }
    var minWeatherTemperature: String { return "\(Int(minTemp))˚C" }
}

struct WeatherListDuringThreeDays {
    let forecastDay: NSArray

}






