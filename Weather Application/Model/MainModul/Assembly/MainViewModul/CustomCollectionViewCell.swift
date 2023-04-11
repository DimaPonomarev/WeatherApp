//
//  CustomCollectionViewCell.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - identifier
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //  MARK: - UI properties
    
    let imageViewOfWeatherIcon = UIImageView()
    let labelTime = UILabel()
    let labelDeegree = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView.addSubview(imageViewOfWeatherIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - override layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageViewOfWeatherIcon)
        contentView.addSubview(labelTime)
        contentView.addSubview(labelDeegree)
        setupConstraints()
        setupViews()
    }
    
    //MARK: - configureView
    
    public func configureView(_ model: (WeatherInEachHour?, Icon?, CurrentLocation)) {
        
        imageViewOfWeatherIcon.contentMode = .scaleAspectFill
        labelTime.text = getCurrentDateFromListOfTimes(dateInString: model.0?.time ?? "no date").0
        labelDeegree.text = model.0?.weatherTemprature

        if getCurrentTimeInChoosenCity(currentTimeZone: model.2.timeZone) == getCurrentDateFromListOfTimes(dateInString: model.0?.time ?? "no data").1 {
                labelTime.text = "Сейчас"
            }
        if let URLWeatherImage = model.1?.image {
            UIImage.loadFrom(url: URLWeatherImage, completion: {
                self.imageViewOfWeatherIcon.image = $0 })
        } else {
            return self.imageViewOfWeatherIcon.image = UIImage(named: "undefinedWeather") }
    }
}

//  MARK: - Private methods

private extension CustomCollectionViewCell {
    
    //MARK: - setupConstraints
    
    func setupConstraints() {
        
        labelTime.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        imageViewOfWeatherIcon.snp.makeConstraints {
            $0.top.equalTo(labelTime.snp.bottom)
            $0.height.width.equalTo(40)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        labelDeegree.snp.makeConstraints {
            $0.top.equalTo(imageViewOfWeatherIcon.snp.bottom)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    //MARK: - getCurrentDateFromChoosenCity

    func getCurrentTimeInChoosenCity(currentTimeZone: String) -> String {
        guard  let timeZone = TimeZone(identifier: currentTimeZone) else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd HH:00"
        let currentDate = dateFormatter.string(from: Date())
        return currentDate
    }
    
    //MARK: - getCurrentDate
    
    func getCurrentDateFromListOfTimes(dateInString: String) -> (String?, String?) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateInDate = formatter.date(from: dateInString)!
        formatter.dateFormat = "dd HH:mm"
        let updateDateInStringForCompareWithCurrentDate = formatter.string(from: dateInDate)
        formatter.dateFormat = "HH:mm"
        let updateDateInStringToSetTextOfLabel = formatter.string(from: dateInDate)
        return (updateDateInStringToSetTextOfLabel, updateDateInStringForCompareWithCurrentDate)
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        
        labelTime.font = .systemFont(ofSize: 15)
        labelTime.textColor = .white
        
        if labelTime.text == "Сейчас" {
            labelTime.font = .boldSystemFont(ofSize: 14)
        }
        
        labelDeegree.font = .systemFont(ofSize: 15)
        labelDeegree.textColor = .white
    }
}
