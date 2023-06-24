//
//  ExtensionSearchBar.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import Foundation
import UIKit

extension UISearchBar {
    var textField: UITextField? {
        guard let text = self.value(forKey: "searchField") as? UITextField else {
            return nil
        }

        return text
    }
}
