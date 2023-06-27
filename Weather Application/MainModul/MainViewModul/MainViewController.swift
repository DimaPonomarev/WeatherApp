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
    func passDataFromPresenterToViewController(model: ModelForTopView)
    func passProfileDataFromPresenterToViewController(profileModel: ModelProfile)
}

//MARK: - Class ViewController

class MainViewController: UIViewController, MainViewControllerProtocol {

    var presenter: MainViewControllerPresenterProtocol?
    
    lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    private let viewForTableView = UIView()
    private let upperView = UIView()
    private let cityLabel = UILabel()
    private let imageViewOfCurrentWeatherInUpperView = WebImageView()
    private let atmospherePressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let degreeOfCurrentWeatherInUpperView = UILabel()
    private let feelLikeDegreeLabel = UILabel()
    private let descriptionOfWeather = UILabel()
    private let windSpeedLabel = UILabel()
    private let degreeAndImageStackViewInUpperStackView = UIStackView()
    private let degreeStackView = UIStackView()
    private let descriptionStackView = UIStackView()
    private let tableView = UITableView()
    private let forecastLabel = UILabel()
    private let nightDayImageViewInUpperView = UIImageView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let rainView = UIView()
    private let locationManager = LocationManager()
    private let searchController = UISearchController(searchResultsController: nil)
    private var tableViewHeighConstraint: Constraint!
    
    //    MARK: - ObserverOfTableViewSize
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateTableViewHeighConstraint(keyPath: keyPath, change: change)
    }
    
    //MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addViews()
        makeConstraints()
        makeViews()
        setupSearchBar()
        setupScrollView()
        setupTableView()
        setupCollectionView()
        updateSearchResults(for: searchController)
    }
}

//MARK: - Private Extension

private extension MainViewController {
    
    //MARK: - setup
    
    func setup() {
        
        let assembly = Assembly()
        assembly.createViewController(view: self)
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(upperView)
        upperView.addSubview(nightDayImageViewInUpperView)
        
        upperView.addSubview(rainView)
        rainView.addSubview(SKView(withEmitter: "ParticleScene"))
        
        degreeAndImageStackViewInUpperStackView.addArrangedSubview(degreeOfCurrentWeatherInUpperView)
        degreeAndImageStackViewInUpperStackView.addArrangedSubview(imageViewOfCurrentWeatherInUpperView)
        
        upperView.addSubview(degreeStackView)
        degreeStackView.addArrangedSubview(cityLabel)
        degreeStackView.addArrangedSubview(degreeAndImageStackViewInUpperStackView)
        degreeStackView.addArrangedSubview(descriptionOfWeather)
        degreeStackView.addArrangedSubview(feelLikeDegreeLabel)
        
        upperView.addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(windSpeedLabel)
        descriptionStackView.addArrangedSubview(humidityLabel)
        descriptionStackView.addArrangedSubview(atmospherePressureLabel)
        
        upperView.addSubview(collectionView)
        
        contentView.addSubview(viewForTableView)
        viewForTableView.addSubview(forecastLabel)
        viewForTableView.addSubview(tableView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        upperView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(collectionView)
        }
        nightDayImageViewInUpperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        degreeStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.leading.trailing.equalTo(contentView)
        }
        descriptionStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(degreeStackView.snp.bottom)
            $0.centerY.equalTo(collectionView.snp.centerY)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(degreeStackView.snp.bottom).offset(5)
            $0.left.equalTo(descriptionStackView.snp.right).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(85)
        }
        viewForTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(scrollView)
        }
        forecastLabel.snp.makeConstraints {
            $0.top.leading.equalTo(viewForTableView).inset(10)
            $0.bottom.equalTo(tableView.snp.top).offset(-10)
        }
        tableView.snp.remakeConstraints {
            tableViewHeighConstraint = $0.height.equalTo(10).constraint
            $0.bottom.equalTo(viewForTableView).inset(50)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    //MARK: - makeView
    
    func makeViews() {
        self.view.backgroundColor = .white
        
        upperView.backgroundColor = .systemBlue
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
        upperView.clipsToBounds = true
        
        rainView.isHidden = true
        
        cityLabel.font = .systemFont(ofSize: 40)
        cityLabel.minimumScaleFactor = 0.1
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        cityLabel.textColor = .white
        
        degreeOfCurrentWeatherInUpperView.font = .systemFont(ofSize: 40)
        degreeOfCurrentWeatherInUpperView.minimumScaleFactor = 0.1
        degreeOfCurrentWeatherInUpperView.adjustsFontSizeToFitWidth = true
        degreeOfCurrentWeatherInUpperView.textAlignment = .right
        degreeOfCurrentWeatherInUpperView.numberOfLines = 0
        degreeOfCurrentWeatherInUpperView.textColor = .white
        
        imageViewOfCurrentWeatherInUpperView.contentMode = .left
        
        descriptionOfWeather.font = .preferredFont(forTextStyle: .body)
        descriptionOfWeather.font = .systemFont(ofSize: 20)
        descriptionOfWeather.minimumScaleFactor = 0.1
        descriptionOfWeather.adjustsFontSizeToFitWidth = true
        descriptionOfWeather.textAlignment = .center
        descriptionOfWeather.numberOfLines = 0
        descriptionOfWeather.textColor = .white
        
        feelLikeDegreeLabel.font = .systemFont(ofSize: 19)
        feelLikeDegreeLabel.minimumScaleFactor = 0.1
        feelLikeDegreeLabel.adjustsFontSizeToFitWidth = true
        feelLikeDegreeLabel.textAlignment = .center
        feelLikeDegreeLabel.numberOfLines = 0
        feelLikeDegreeLabel.textColor = .systemGray5
        
        windSpeedLabel.textColor = .white
        windSpeedLabel.font = .systemFont(ofSize: 15)
        windSpeedLabel.minimumScaleFactor = 5
        windSpeedLabel.adjustsFontSizeToFitWidth = true
        
        humidityLabel.textColor = .white
        humidityLabel.font = .systemFont(ofSize: 15)
        humidityLabel.minimumScaleFactor = 5
        humidityLabel.adjustsFontSizeToFitWidth = true
        
        atmospherePressureLabel.textColor = .white
        atmospherePressureLabel.font = .systemFont(ofSize: 15)
        atmospherePressureLabel.minimumScaleFactor = 5
        atmospherePressureLabel.adjustsFontSizeToFitWidth = true
        
        degreeAndImageStackViewInUpperStackView.distribution = .fillEqually
        
        degreeStackView.axis = .vertical
        degreeStackView.spacing = 20
        degreeStackView.distribution = .fillProportionally
        
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .fillEqually
        
        forecastLabel.text = "Прогноз на 7 Дней"
        forecastLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    
    
    //MARK: - setupSearchBar
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.textField?.backgroundColor = .white.withAlphaComponent(0.7)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - setupScrollView
    
    func setupScrollView() {
        scrollView.resignFirstResponder()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
    }
    
    //MARK: - setupCollectionView
    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(50, 80)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    //MARK: - setupTableView
    
    func setupTableView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
}

//MARK: - Public extensions

extension MainViewController {
    
    func passProfileDataFromPresenterToViewController(profileModel: ModelProfile) {
        let profileImageView = WebImageView()
        profileImageView.set(imageUrl: profileModel.image)
        profileImageView.image = profileImageView.image?.resized(to: CGSize(width: 40, height: 40))
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    public func passDataFromPresenterToViewController(model: ModelForTopView) {
        humidityLabel.text = "\(model.weatherHumidity)"
        atmospherePressureLabel.text = "\(model.weatherPressure)"
        degreeOfCurrentWeatherInUpperView.text = "\(model.weatherTemprature)"
        feelLikeDegreeLabel.text = "\(model.weatherAppearentTemperature)"
        descriptionOfWeather.text = "\(model.description)"
        windSpeedLabel.text = "\(model.weatherWindSpeed)"
        cityLabel.text = "\(model.cityLocation)"
        imageViewOfCurrentWeatherInUpperView.set(imageUrl: model.iconURL)
        nightDayImageViewInUpperView.image = model.switchNightDay
        rainView.isHidden = model.switchRain

        tableView.reloadData()
        collectionView.reloadData()
    }
    
    public func error(error: NSError) {
        print(error.localizedDescription)
    }
    
    //    MARK: - updateTableViewHeighConstraint
    
    private func updateTableViewHeighConstraint(keyPath: String?, change: [NSKeyValueChangeKey : Any]?) {
        var newHeighConstraint: CGFloat?
        if(keyPath == "contentSize"){
            if let newValue = change?[.newKey]
            {
                let newSize = newValue as! CGSize
                newHeighConstraint = newSize.height
                tableView.snp.updateConstraints {
                    tableViewHeighConstraint = $0.height.equalTo(newHeighConstraint!).constraint
                }
                tableView.layoutIfNeeded()
            }
        }
    }
}

//MARK: - extension UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
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
            presenter?.makeRequestToInteractorToProvideWeatherData(in: city)
        }
    }
}

//MARK: - extension UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tableViewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        guard let modelForTableView = presenter?.tableViewModel?[indexPath.row] else {return UITableViewCell()}
        cell.configureView(modelForTableView)
        return cell
    }
}

//MARK: - extension UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter?.collectionViewModel?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell()}
        guard let modelForColletionView = presenter?.collectionViewModel?[indexPath.row] else {return UICollectionViewCell()}
        cell.configureView(modelForColletionView)
        return cell
    }
}
