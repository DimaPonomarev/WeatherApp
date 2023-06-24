//
//  NewModel.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 22.06.2023.
//

import Foundation

struct ForecastWeather: Decodable {
    let location: CurrentLocation
    let forecast: ForecastDayWeather
    
    struct CurrentLocation: Decodable {
        let name: String
        let country: String
        var localtime: String
        let tzId: String
    }

    struct ForecastDayWeather: Decodable {
        let forecastday: [WeatherInEachDay]

        struct WeatherInEachDay: Decodable {
            let date: String
            let day: WeatherInEachDayAsAWhole
            let hour: [WeatherInEachHourInDay]

            struct WeatherInEachDayAsAWhole: Decodable {
                let maxtempC: Double
                let mintempC: Double
                let condition: WeatherCondition
            }
            
            struct WeatherInEachHourInDay: Decodable {
                let tempC: Double
                let time: String
                let chanceOfRain: Int
                let isDay: Int
                let pressureMb: Int
                let humidity: Int
                let feelslikeC: Double
                let windKph: Double
                let condition: WeatherCondition
            }
        }
    }
    
    struct WeatherCondition: Decodable {
        let text: String
        let icon: String
    }
}



