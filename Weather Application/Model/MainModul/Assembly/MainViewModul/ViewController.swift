//
//  ViewController.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import UIKit
import SnapKit
import SpriteKit


protocol MainViewControllerProtocol: UIViewController {
    
    var presenter: MainViewControllerPresenterProtocol? {get set}
    func error(error: NSError)
    func success(displayWeatherNowInChangedLocations: [(WeatherInEachHour?, Icon?, CurrentLocation)], loca: CurrentLocation)
}

//MARK: - Class ViewController

class ViewController: UIViewController, MainViewControllerProtocol {
    
    var presenter: MainViewControllerPresenterProtocol?
    
    lazy var scrollView = UIScrollView()

    private let upperView = UIView()
    private let cityLabel = UILabel()
    private let imageViewOfWeatherinCurrentHour = UIImageView()
    private let atmospherePressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let degreelabel = UILabel()
    private let feelLikeDegreeLabel = UILabel()
    private let refreshButton = UIButton()
    private let descriptionOfWeather = UILabel()
    private let windSpeedLabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let upperStackView = UIStackView()
    private let degreeStackView = UIStackView()
    private let descriptionStackView = UIStackView()
    private let lastRefreshLabel = UILabel()
    private let tableView = UITableView()
    private let nightTemperature = UILabel()
    private let dayTemperature = UILabel()
    private let nightDayDegreeStackView = UIStackView()
    private let forecastLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let nightDayUpperView = UIImageView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let activityIndicator = UIActivityIndicatorView()
    private let rainView = UIView()
    private let locationManager = LocationManager()
    private let locationLabel = UILabel()
    
    //MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addViews()
        makeConstraints()
        makeViews()
        setupSearchBar()
        setupTableView()
        setupCollectionView()
        updateSearchResults(for: searchController)
    }
}

//MARK: - Private Extension

private extension ViewController {
    
    //MARK: - setup
    
    func setup() {
        
        let assembly = Assembly()
        assembly.createViewController(view: self)
    }
    
    //MARK: - addViews
    
    func addViews() {
        
        view.addSubview(upperView)
        upperView.addSubview(locationLabel)
        upperView.addSubview(nightDayUpperView)
        upperView.addSubview(rainView)
        upperView.addSubview(backgroundImageView)
        upperView.addSubview(upperStackView)
        upperView.addSubview(degreeStackView)
        upperView.addSubview(descriptionStackView)
        upperView.addSubview(collectionView)
        rainView.addSubview(SKView(withEmitter: "ParticleScene"))
        upperStackView.addArrangedSubview(degreelabel)
        upperStackView.addArrangedSubview(imageViewOfWeatherinCurrentHour)
        degreeStackView.addArrangedSubview(cityLabel)
        degreeStackView.addArrangedSubview(upperStackView)
        degreeStackView.addArrangedSubview(descriptionOfWeather)
        degreeStackView.addArrangedSubview(feelLikeDegreeLabel)
        descriptionStackView.addArrangedSubview(windSpeedLabel)
        descriptionStackView.addArrangedSubview(humidityLabel)
        descriptionStackView.addArrangedSubview(atmospherePressureLabel)
        upperView.addSubview(lastRefreshLabel)
        view.addSubview(refreshButton)
        view.addSubview(tableView)
        view.addSubview(nightDayDegreeStackView)
        view.addSubview(forecastLabel)
        nightDayDegreeStackView.addArrangedSubview(dayTemperature)
        nightDayDegreeStackView.addArrangedSubview(nightTemperature)
        view.addSubview(activityIndicator)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        upperView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-30)
            $0.leading.trailing.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        degreeStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(-5)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(degreeStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(200)
        }
        lastRefreshLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
        forecastLabel.snp.makeConstraints {
            $0.top.equalTo(upperView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
        }
        nightDayDegreeStackView.snp.makeConstraints {
            $0.top.equalTo(forecastLabel.snp.bottom)
            $0.right.equalToSuperview().offset(3)
            $0.width.equalToSuperview().inset(151)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(nightDayDegreeStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.left.equalTo(descriptionStackView.snp.right)
            $0.right.bottom.equalToSuperview()
            $0.top.equalTo(degreeStackView.snp.bottom)
        }
        nightDayUpperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - makeView
    
    func makeViews() {
        
        self.view.backgroundColor = .white
        rainView.isHidden = true
        
        upperView.backgroundColor = .systemBlue
        upperView.layer.cornerRadius = 20
        upperView.clipsToBounds = true
        
        backgroundImageView.contentMode = .scaleAspectFill
        
        cityLabel.font = .systemFont(ofSize: 40)
        cityLabel.minimumScaleFactor = 0.1
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        cityLabel.textColor = .white
        
        degreelabel.font = .systemFont(ofSize: 45)
        degreelabel.minimumScaleFactor = 0.1
        degreelabel.adjustsFontSizeToFitWidth = true
        degreelabel.textAlignment = .right
        degreelabel.numberOfLines = 0
        degreelabel.textColor = .white
        
        imageViewOfWeatherinCurrentHour.contentMode = .left
        
        descriptionOfWeather.font = .preferredFont(forTextStyle: .body)
        descriptionOfWeather.font = .systemFont(ofSize: 20)
        descriptionOfWeather.minimumScaleFactor = 0.1
        descriptionOfWeather.adjustsFontSizeToFitWidth = true
        descriptionOfWeather.textAlignment = .center
        descriptionOfWeather.numberOfLines = 0
        descriptionOfWeather.textColor = .white
        
        feelLikeDegreeLabel.textColor = .white
        feelLikeDegreeLabel.font = .systemFont(ofSize: 19)
        feelLikeDegreeLabel.minimumScaleFactor = 0.1
        feelLikeDegreeLabel.adjustsFontSizeToFitWidth = true
        feelLikeDegreeLabel.textAlignment = .center
        feelLikeDegreeLabel.numberOfLines = 0
        feelLikeDegreeLabel.textColor = .systemGray4
        
        windSpeedLabel.textColor = .white
        windSpeedLabel.font = .systemFont(ofSize: 15)
        windSpeedLabel.minimumScaleFactor = 0.1
        windSpeedLabel.adjustsFontSizeToFitWidth = true
        
        humidityLabel.textColor = .white
        humidityLabel.font = .systemFont(ofSize: 15)
        humidityLabel.minimumScaleFactor = 0.1
        humidityLabel.adjustsFontSizeToFitWidth = true
        
        atmospherePressureLabel.textColor = .white
        atmospherePressureLabel.font = .systemFont(ofSize: 15)
        atmospherePressureLabel.minimumScaleFactor = 0.1
        atmospherePressureLabel.adjustsFontSizeToFitWidth = true
        
        lastRefreshLabel.textColor = .white
        lastRefreshLabel.font = .systemFont(ofSize: 15)
        lastRefreshLabel.minimumScaleFactor = 0.1
        lastRefreshLabel.adjustsFontSizeToFitWidth = true
        lastRefreshLabel.textAlignment = .center
        
        upperStackView.distribution = .fillEqually
        
        degreeStackView.axis = .vertical
        degreeStackView.spacing = 5
        degreeStackView.distribution = .fillProportionally
        
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 5
        
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.font = .systemFont(ofSize: 30)
        
//        dayTemperature.adjustsFontSizeToFitWidth = true
//        dayTemperature.font = .systemFont(ofSize: 20)
//        dayTemperature.text = "День"
//        dayTemperature.minimumScaleFactor = 0.1
//
//        nightTemperature.adjustsFontSizeToFitWidth = true
//        nightTemperature.textColor = .gray
//        nightTemperature.font = .systemFont(ofSize: 20)
//        nightTemperature.text = "Ночь"
//        nightTemperature.minimumScaleFactor = 0.1
//
//        nightDayDegreeStackView.axis = .horizontal
//        nightDayDegreeStackView.distribution = .fillEqually
        
        forecastLabel.text = "Прогноз на 7 Дней"
        forecastLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    //MARK: - setupSearchBar
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.textField?.backgroundColor = .white.withAlphaComponent(0.7)
    }
    
    //MARK: - setupCollectionView
    
    func setupCollectionView() {
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(50, 50)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    //MARK: - setupTableView
    
    func setupTableView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.dataSource = self
    }
}

//MARK: - Public extensions

extension ViewController {
    
    func success(displayWeatherNowInChangedLocations: [(WeatherInEachHour?, Icon?, CurrentLocation)], loca: CurrentLocation) {
        let model = displayWeatherNowInChangedLocations[0]
        self.view.alpha = 1
        activityIndicator.stopAnimating()
        humidityLabel.text = "\(model.0?.weatherHumidity ?? "noData")"
        atmospherePressureLabel.text = "\(model.0?.weatherPressure ?? "noData")"
        degreelabel.text = "\(model.0?.weatherTemprature ?? "noData")"
        feelLikeDegreeLabel.text = "\(model.0?.weatherAppearentTemperature ?? "noData")"
        descriptionOfWeather.text = "\(model.1?.descriptionOfWeather ?? "noData")"
        windSpeedLabel.text = "\(model.0?.weatherWindSpeed ?? "noData")"
        cityLabel.text = "\(loca.name), \(loca.country)"
        
        if let URLWeatherNowImage = model.1?.image {
            UIImage.loadFrom(url: URLWeatherNowImage, completion: {
                self.imageViewOfWeatherinCurrentHour.image = $0 })
        } else {
            self.imageViewOfWeatherinCurrentHour.image = UIImage(named: "unknown")
        }
        
        if model.0?.isDay == 1 {
            nightDayUpperView.image = UIImage(named: "day")
        } else {
            nightDayUpperView.image = UIImage(named: "night")
        }
        
        if model.0?.chanceOfRain ?? 0 < 60 {
            rainView.isHidden = true
        } else {
            rainView.isHidden = false
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func error(error: NSError) {
        print(error.localizedDescription)
    }
}

//MARK: - extension UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        updateSearch(searchController: searchController)
    }
    
    func updateSearch(searchController: UISearchController) {
        guard var city = searchController.searchBar.text else { return }
        city = city.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
        if searchController.isActive == true {
            self.view.alpha = 0.5
        } else {
            self.view.alpha = 1
        }
        if city.count > 3 {
            presenter?.providingDataForSetingWeather(inputedTextInSearchBar: city)
        }
    }
}

//MARK: - extension UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.weatherArrayOfSeveralDays.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        guard let modelForTableView = presenter?.weatherArrayOfSeveralDays[indexPath.row] else {return UITableViewCell()}
        cell.configureView(modelForTableView)
        return cell
    }
}

//MARK: - extension UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter?.weatherArrayToday.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell()}
        guard let modelForColletionView = presenter?.weatherArrayToday[indexPath.row] else {return UICollectionViewCell()}
        cell.configureView(modelForColletionView)
        return cell
    }
}



//TODO:
// сменить констрейнты для день ночь и градусы
// оптимизировать код
// сделать сглыживание углов на погоде
// сделать изменяющийся шрифт с night day
// c min max temp
// change day photo
//


