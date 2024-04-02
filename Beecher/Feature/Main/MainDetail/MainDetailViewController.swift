//
//  MainDetailViewController.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainDetailViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let mainDetailViewModel = MainDetailViewModel()
    let coinData : [CoinDataWithAdditionalInfo]
    init(coinData : [CoinDataWithAdditionalInfo]) {
        self.coinData = coinData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //필기 텍스트
    private let textview : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .black
        text.font = UIFont.boldSystemFont(ofSize: 18)
        text.textAlignment = .left
        text.backgroundColor = .white
        return text
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setCoinData()
        setLayout()
        setBinding()
    }
}
//MARK: - setLayout
extension MainDetailViewController {
    private func setLayout() {
        self.view.addSubview(textview)
        textview.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 10)
            make.bottom.equalToSuperview().inset(0)
        }
    }
}
//MARK: - setBinding
extension MainDetailViewController {
    private func setBinding() {
        
    }
    private func setCoinData() {
        //코인 정보
        let coinName = coinData.compactMap{ $0.coinName }
        let coinMarket = coinData.compactMap{ $0.coinData.market }
        self.title = "\(coinName[0]) \(coinMarket[0])"
        
        
    }
}
