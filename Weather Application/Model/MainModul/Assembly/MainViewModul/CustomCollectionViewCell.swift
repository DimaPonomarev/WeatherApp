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
        labelTime.text = getCurrentDate(dateInString: model.0?.time ?? "no date")
        labelDeegree.text = model.0?.weatherTemprature
        
//        TODO: make normal code
        
        if let timeZone = TimeZone(identifier: model.2.timeZone) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = timeZone
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let vc = dateFormatter.string(from: Date()) // Sep 26, 11:22 AM
            let vcDate = dateFormatter.date(from: vc)
//            let weekDay = (vcDate!.formatted(Date.FormatStyle().weekday(.wide)))
            dateFormatter.dateStyle = .long
            dateFormatter.dateFormat = "HH:00"
            let updateDateInString = dateFormatter.string(from: vcDate!)
            if updateDateInString == getCurrentDate(dateInString: model.0?.time ?? "no data") {
                labelTime.text = "Сейчас"
                
            }
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
            $0.top.equalTo(contentView.snp.top).inset(-20)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        imageViewOfWeatherIcon.snp.makeConstraints {
            $0.top.equalTo(labelTime.snp.bottom)
            $0.height.width.equalTo(40)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        labelDeegree.snp.makeConstraints {
            $0.top.equalTo(imageViewOfWeatherIcon.snp.bottom).offset(5)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    //MARK: - getCurrentDate
    
    func getCurrentDate(dateInString: String) -> (String?) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateInDate = formatter.date(from: dateInString)!
        formatter.dateFormat = "HH:mm"
        let updateDateInString = formatter.string(from: dateInDate)
        
        
        
        return updateDateInString
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
