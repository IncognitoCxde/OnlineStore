//
//  OnboardingViewModel.swift
//  OnlineStore
//
//  Created by Aziza Azizova on 03/10/25.
//

import UIKit

final class OnboardingViewModel {
    private(set) var slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "New market \nplace in your \nsmartphone",
            description: nil,
            image: UIImage(named: "Onboarding1")!
        ),
        OnboardingSlide(
            title: "Shop from \neverywhere",
            description: "clothes, gadgets and more",
            image: UIImage(named: "Onboarding2")!
        ),
        OnboardingSlide(
            title: "Get the best \nsales offers",
            description: "up to 20% on every item",
            image: UIImage(named: "Onboarding3")!
        )
    ]
    
    var currentPage: Int = 0
}
