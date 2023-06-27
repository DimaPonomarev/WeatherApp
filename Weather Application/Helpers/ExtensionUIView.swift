//
//  Extension UIView.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 27.06.2023.
//

import UIKit

extension UIView {
    
    enum RoundCornersAt {
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init() ]
    }
}
