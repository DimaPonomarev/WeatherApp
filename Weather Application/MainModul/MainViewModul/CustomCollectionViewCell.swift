//
//  CustomCollectionViewCell.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import UIKit
import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - identifier
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //  MARK: - UI properties
    
    private let imageViewOfWeatherIcon = WebImageView()
    private let labelTime = UILabel()
    private let labelDeegree = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMethods()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - configureView
    
    public func configureView(_ model: ModelForCollectionView) {
        labelDeegree.text = "\(model.temperature)"
        labelTime.text = getCurrentDateFromListOfTimes(dateInString: model.time).0
        imageViewOfWeatherIcon.setWeatherImage(imageUrl: model.iconURL)
        if getCurrentTimeInChoosenCity(currentTimeZone: model.timeZone) == getCurrentDateFromListOfTimes(dateInString: model.time).1 {
            labelTime.text = "Сейчас"
        }
    }
}

//  MARK: - Private methods

private extension CustomCollectionViewCell {
    
    //MARK: - setup
    
    func setupMethods() {
        contentView.addSubview(imageViewOfWeatherIcon)
        contentView.addSubview(labelTime)
        contentView.addSubview(labelDeegree)
        setupConstraints()
        setupViews()
    }
    
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
        
        imageViewOfWeatherIcon.contentMode = .scaleAspectFill
        
        if labelTime.text == "Сейчас" {
            labelTime.font = .boldSystemFont(ofSize: 14)
        }
        
        labelDeegree.font = .systemFont(ofSize: 15)
        labelDeegree.textColor = .white
    }
}
