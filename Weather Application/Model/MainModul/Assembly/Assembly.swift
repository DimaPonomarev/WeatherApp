//
//  Assembly.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation

class Assembly {
    func createViewController(view: MainViewControllerProtocol) {
        let presenter = MainViewControllerPresenter()
        let interactor = MainViewControllerInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        view.presenter = presenter
    }
}
