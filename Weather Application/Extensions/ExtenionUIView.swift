//
//  ExtenionUIView.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 11.04.2023.
//

import SwiftUI

extension UIView{
    
    enum RoundCornersAt{
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
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
}
