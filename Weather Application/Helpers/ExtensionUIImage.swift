//
//  ExtensionUIImage.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//

import UIKit

extension UIImage {

    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

