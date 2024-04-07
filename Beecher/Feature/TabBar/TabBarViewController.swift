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
        self.title = ""
        setupView()
        setBinding()
    }
}
//MARK: - setup
extension TabBarViewController {
    private func setupView() {
        self.tabBar.backgroundColor = .keyColor
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .keyColor
        self.tabBar.unselectedItemTintColor = .lightGray
        //탭바 설정
        let firstVC = MainViewController()
        firstVC.tabBarItem = UITabBarItem(title: "차트", image: UIImage(systemName: "list.bullet"), tag: 0)
        let firstNavigationVC = UINavigationController(rootViewController: firstVC)
        
        let secondVC = OrderBookViewController()
        secondVC.tabBarItem = UITabBarItem(title: "호가", image: UIImage(systemName: "creditcard.fill"), tag: 1)
        let secondNavigationVC = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = MainViewController()
        thirdVC.tabBarItem = UITabBarItem(title: "Ai", image: UIImage(systemName: "target"), tag: 2)
        let thirdNavigationVC = UINavigationController(rootViewController: thirdVC)
        
        let forthVC = NewsViewController()
        forthVC.tabBarItem = UITabBarItem(title: "뉴스", image: UIImage(systemName: "globe"), tag: 3)
        let forthNavigationVC = UINavigationController(rootViewController: forthVC)
        
        self.viewControllers = [firstNavigationVC, secondNavigationVC, thirdNavigationVC, forthNavigationVC]
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
