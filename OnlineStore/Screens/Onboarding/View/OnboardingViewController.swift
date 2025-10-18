//
//  OnboardingViewController.swift
//  OnlineStore
//
//  Created by Aziza Azizova on 03/10/25.
//

import UIKit
import DesignSystem
import SnapKit

final class OnboardingViewController: UIViewController {
    
    var onFinish: (() -> Void)?
    
    private let viewModel = OnboardingViewModel()
    
    private lazy var pageVC: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.backgroundColor = .clear
        pc.currentPageIndicatorTintColor = AppColors.customBlue
        pc.pageIndicatorTintColor = AppColors.lightBlue
        return pc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let firstVC = contentVC(for: 0) {
            firstVC.isLastSlide = viewModel.currentPage == viewModel.slides.count - 1
            firstVC.onNextTapped = { [weak self] in self?.goToNextSlide() }
            firstVC.onGetStartedTapped = { [weak self] in self?.finishOnboarding() }
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColors.lightGrey
        
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        
        view.addSubview(pageControl)
        
        pageVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        pageControl.numberOfPages = viewModel.slides.count
        pageControl.currentPage = 0
        
        applyCustomPageControlImages(for: 0)
    }
    
    private func applyCustomPageControlImages(for currentIndex: Int) {
        guard #available(iOS 14.0, *) else { return }

        // Сброс всех изображений
        for i in 0..<viewModel.slides.count {
            pageControl.setIndicatorImage(nil, forPage: i)
        }

        // Установка изображений заново
        for i in 0..<viewModel.slides.count {
            let image = i == currentIndex
                ? UIImage(named: "dotActive")
                : UIImage(named: "dotInactive")
            pageControl.setIndicatorImage(image, forPage: i)
        }

        pageControl.currentPage = currentIndex
    }


    private func contentVC(for index: Int) -> OnboardingContentViewController? {
        guard index >= 0, index < viewModel.slides.count else { return nil }
        let vc = OnboardingContentViewController(slide: viewModel.slides[index])
        vc.isLastSlide = index == viewModel.slides.count - 1
        vc.onNextTapped = { [weak self] in self?.goToNextSlide() }
        vc.onGetStartedTapped = { [weak self] in self?.finishOnboarding() }
        return vc
    }
    
    private func goToNextSlide() {
        viewModel.currentPage += 1
        guard let vc = contentVC(for: viewModel.currentPage) else { return }
        pageVC.setViewControllers([vc], direction: .forward, animated: true)
        pageControl.currentPage = viewModel.currentPage
        applyCustomPageControlImages(for: viewModel.currentPage)
    }
    
    private func finishOnboarding() {
        onFinish?()
    }
}

// MARK: - PageVC Delegates
extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingContentViewController else { return nil }
        guard let index = viewModel.slides.firstIndex(where: { $0.title == currentVC.slideTitle }) else { return nil }
        return contentVC(for: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingContentViewController else { return nil }
        guard let index = viewModel.slides.firstIndex(where: { $0.title == currentVC.slideTitle }) else { return nil }
        return contentVC(for: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? OnboardingContentViewController,
           let index = viewModel.slides.firstIndex(where: { $0.title == currentVC.slideTitle }) {
            viewModel.currentPage = index
            pageControl.currentPage = index
            applyCustomPageControlImages(for: index)
        }
    }
}
