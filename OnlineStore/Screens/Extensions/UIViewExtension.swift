//
//  UIViewExtension.swift
//  OnlineStore
//
//  Created by iMacbook on 9/27/25.
//

import UIKit
import DesignSystem

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = AppColors.arsenicDark.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 2
    }
}
