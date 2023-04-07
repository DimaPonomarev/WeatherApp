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
    private let imageViewOfWeatherIcon = UIImageView()
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
    
    func configureView(_ model: (InfoAboutDayWeather?, Icon?, String?, CurrentLocation)) {
        
        dateLabel.text = getCurrentDate(dateInString: model.2 ?? "no data").0
        weekDayLabel.text = getCurrentDate(dateInString: model.2 ?? "no data").2
        maxTempLabel.text = "\(model.0?.maxWeatherTemperature ?? "no data")"
        minTempLabel.text = "\(model.0?.minWeatherTemperature ?? "no data")"
        setupWeekDayLabel(dateString: getCurrentDate(dateInString: model.2 ?? "no data").1, location: model.3)
        
        //        TODO: - make normal code
        
        
        if let timeZone = TimeZone(identifier: model.3.timeZone) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = timeZone
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let vc = dateFormatter.string(from: Date()) // Sep 26, 11:22 AM
            let vcDate = dateFormatter.date(from: vc)
//            let weekDay = (vcDate!.formatted(Date.FormatStyle().weekday(.wide)))
            dateFormatter.dateStyle = .long
            dateFormatter.dateFormat = "dd MMMM"
            let updateDateInString = dateFormatter.string(from: vcDate!)
            if updateDateInString == getCurrentDate(dateInString: model.2 ?? "no data").0 {
                weekDayLabel.text = "Сегодня"
                makeFirstCell()
                
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
            $0.left.equalTo(dateStackView.snp.right)
            $0.right.equalTo(weatherStackView.snp.left)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        weatherStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview()
            $0.left.equalTo(imageViewOfWeatherIcon.snp.right)
        }
        dayTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(maxTempLabel)
            $0.top.equalToSuperview()
        }
        nightTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(minTempLabel)
            $0.top.equalTo(dayTemperature)
        }
        
    }
    
    //  MARK: - setupViews
    
    func setupViews() {
        
        imageViewOfWeatherIcon.contentMode = .right
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
        weatherStackView.distribution = .fillProportionally
        weatherStackView.spacing = 10
        
        
    }
    
    //  MARK: - getCurrentDate
    
    func getCurrentDate(dateInString: String) -> (String, Date, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateInDate = formatter.date(from: dateInString)!
        let weekDay = (dateInDate.formatted(Date.FormatStyle().weekday(.wide))).capitalized
        formatter.dateStyle = .long
        formatter.dateFormat = "dd MMMM"
        let updateDateInString = formatter.string(from: dateInDate)
        return (updateDateInString, dateInDate, weekDay)
    }
    
    //  MARK: - setupWeekDayLabel
    
    func setupWeekDayLabel(dateString: Date, location: CurrentLocation) {
        
        //        print(location.timeZone)
        
        
        
        
        var calendar = Calendar(identifier: .gregorian)
        calendar = Calendar.autoupdatingCurrent
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = TimeZone(identifier: location.timeZone)!
        let isDateWeekend = calendar.isDateInWeekend
//        let isDateToday = calendar.isDateInToday
        
        if isDateWeekend(dateString) {
            weekDayLabel.textColor = .red
        } else {
            weekDayLabel.textColor = .black
        }
    }
    
    private func makeFirstCell() {
        
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
        
    }
}

