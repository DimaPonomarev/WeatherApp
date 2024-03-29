//
//  CustomTableViewCell.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import UIKit
import SnapKit

final class CustomTableViewCell: UITableViewCell {
    
    //MARK: - identifier
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //  MARK: - UI properties
    
    private let maxTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let dateLabel = UILabel()
    private let weekDayLabel = UILabel()
    private let imageViewOfWeatherIcon = WebImageView()
    private let dateStackView = UIStackView()
    private let weatherStackView = UIStackView()
    private let nightTemperature = UILabel()
    private let dayTemperature = UILabel()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMethods()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configureView
    
    public func configureView(_ model: ModelForTableView) {
        dateLabel.text = getCurrentDate(dateInString: model.date).0
        maxTempLabel.text = "\(model.maxWeatherTemperature)"
        minTempLabel.text = "\(model.minWeatherTemperature)"
        imageViewOfWeatherIcon.setWeatherImage(imageUrl: model.iconURL)
        if getCurrentDateInChoosenCity(currentTimeZone: model.timeZone) == getCurrentDate(dateInString: model.date).0  {
            visibleUIPropertiesOnFirstCell(visible: false)
        } else {
            visibleUIPropertiesOnFirstCell(visible: true)
        }
    }
}

//  MARK: - Private methods

private extension CustomTableViewCell {
    
    //  MARK: - setupMethods
    
    func setupMethods() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //  MARK: - addViews
    
    func addViews() {
        contentView.addSubview(dateStackView)
        contentView.addSubview(weatherStackView)
        contentView.addSubview(imageViewOfWeatherIcon)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(weekDayLabel)
        weatherStackView.addArrangedSubview(maxTempLabel)
        weatherStackView.addArrangedSubview(minTempLabel)
        contentView.addSubview(dayTemperature)
        contentView.addSubview(nightTemperature)
    }
    
    //  MARK: - makeConstraints
    
    func makeConstraints() {
        dateStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        imageViewOfWeatherIcon.snp.makeConstraints {
            $0.trailing.equalTo(weatherStackView.snp.leading).inset(-20)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        weatherStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        dayTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(maxTempLabel)
            $0.top.equalToSuperview().inset(-5)
        }
        nightTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(minTempLabel)
            $0.top.equalTo(dayTemperature)
        }
    }
    
    //  MARK: - setupViews
    
    func setupViews() {
        imageViewOfWeatherIcon.contentMode = .scaleToFill
        imageViewOfWeatherIcon.contentScaleFactor = imageViewOfWeatherIcon.alignmentRectInsets.left
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.textColor = .gray
        
        maxTempLabel.adjustsFontSizeToFitWidth = true
        maxTempLabel.font = .systemFont(ofSize: 20)
        maxTempLabel.minimumScaleFactor = 0.1
        
        minTempLabel.adjustsFontSizeToFitWidth = true
        minTempLabel.textColor = .gray
        minTempLabel.font = .systemFont(ofSize: 20)
        minTempLabel.minimumScaleFactor = 0.1
        
        dateStackView.axis = .vertical
        dateStackView.distribution = .equalCentering
        
        weatherStackView.axis = .horizontal
        weatherStackView.distribution = .fillEqually
        weatherStackView.spacing = 15
    }
    
    //  MARK: - getCurrentDateInChoosenCity
    
    func getCurrentDateInChoosenCity(currentTimeZone: String) -> String {
        guard let timeZone = TimeZone(identifier: currentTimeZone) else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd MMMM"
        let updateDateInString = dateFormatter.string(from: Date())
        return updateDateInString
    }
    
    //  MARK: - getCurrentDate
    
    func getCurrentDate(dateInString: String) -> (String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateInDate = formatter.date(from: dateInString)!
        let weekDay = (dateInDate.formatted(Date.FormatStyle().weekday(.wide))).capitalized
        formatter.dateStyle = .long
        formatter.dateFormat = "dd MMMM"
        let updateDateInString = formatter.string(from: dateInDate)
        return (updateDateInString, weekDay)
    }
    
    //  MARK: - makeFirstCell
    
    private func visibleUIPropertiesOnFirstCell(visible: Bool) {
        weekDayLabel.isHidden = visible
        dayTemperature.isHidden = visible
        nightTemperature.isHidden = visible
        
        weekDayLabel.font = .systemFont(ofSize: 16)
        weekDayLabel.textColor = .darkGray
        weekDayLabel.text = "Сегодня"
        
        dayTemperature.adjustsFontSizeToFitWidth = true
        dayTemperature.font = .systemFont(ofSize: 20)
        dayTemperature.text = "День"
        dayTemperature.minimumScaleFactor = 0.1
        dayTemperature.textAlignment = .center
        
        nightTemperature.textAlignment = .center
        nightTemperature.adjustsFontSizeToFitWidth = true
        nightTemperature.textColor = .gray
        nightTemperature.font = .systemFont(ofSize: 20)
        nightTemperature.text = "Ночь"
        nightTemperature.minimumScaleFactor = 0.1
        
        weatherStackView.snp.remakeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

