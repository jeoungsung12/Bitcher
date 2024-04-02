//
//  ViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import UIKit
import SnapKit
class SplashViewController: UIViewController {
    //MARK: - UIComponents
    private let Splash : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "Splash")
        view.contentMode = .scaleAspectFill
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        DispatchNavigation()
    }
}
//MARK: - UI Layout
extension SplashViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(Splash)
        Splash.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
    }
}
//MARK: - UI Navigation
extension SplashViewController {
    private func DispatchNavigation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.pushViewController(TabBarViewController(), animated: false)
        }
    }
}
