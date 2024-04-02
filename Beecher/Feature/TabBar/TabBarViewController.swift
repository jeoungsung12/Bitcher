//
//  TabBarViewController.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TabBarViewController : UITabBarController {
    private let disposeBag = DisposeBag()
    private let tabBarViewModel = TabBarViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .keyColor
        self.title = ""
        setupView()
        setBinding()
    }
}
//MARK: - setup
extension TabBarViewController {
    private func setupView() {
        let firstVC = MainViewController()
        firstVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet"), tag: 0)
        let firstNavigationVC = UINavigationController(rootViewController: firstVC)
        
        let secondVC = MainViewController()
        secondVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.circle"), tag: 1)
        let secondNavigationVC = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = MainViewController()
        thirdVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), tag: 2)
        let thirdNavigationVC = UINavigationController(rootViewController: thirdVC)
        
        self.viewControllers = [firstNavigationVC, secondNavigationVC, thirdNavigationVC]
    }
}
//MARK: - setBinding
extension TabBarViewController {
    private func setBinding() {
        self.rx.didSelect
            .subscribe(onNext: { [weak self] viewController in
                if let index = self?.viewControllers?.firstIndex(of: viewController) {
                    self?.tabBarViewModel.selectedTabIndex.onNext(index)
                }
            })
            .disposed(by: disposeBag)
        tabBarViewModel.selectedTabTitle
            .drive(onNext: { title in
                print("Selected tab title : \(title)")
            })
            .disposed(by: disposeBag)
    }
}