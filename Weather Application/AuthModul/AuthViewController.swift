//
//  AuthViewController.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 24.06.2023.
//

import UIKit
import VK_ios_sdk
import CoreLocation

class AuthViewController: UIViewController {
    
    private var presenter: MainViewControllerPresenterProtocol?
    
    private var appde: AppDelegate!
    private let locationManager = LocationManager()
    private let button = UIButton()
    private var authService: VKAuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(button)
        makeButton()
        makeLocation()
        appde = UIApplication.shared.delegate as? AppDelegate
        appde?.delegateAppDelegate = self
        authService = AppDelegate.shared().authService
    }
}

private extension AuthViewController {
    
    func makeButton() {
        button.center = view.center
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        button.bounds.size = CGSize(width: 200, height: 100)
        button.setTitle("VKApplication", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
    }
    
    @objc func click() {
        authService.wakeUpSession()
    }
}

extension AuthViewController: CLLocationManagerDelegate {
    
    func makeLocation() {
        locationManager.determineMyCurrentLocation()
    }
}

extension AuthViewController: AppDelegateProtool {
    
    func openVKAuthViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openMainViewController() {
        let nextVC = MainViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func openError() {
        let alertController = UIAlertController(title: "Warning", message: "Check your internet conntection", preferredStyle: .alert)
        let tryAgain = UIAlertAction (title: "Try Again", style: .cancel, handler: { [weak self] action in
            guard let self = self else { return }
            self.authService.wakeUpSession()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(tryAgain)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}



