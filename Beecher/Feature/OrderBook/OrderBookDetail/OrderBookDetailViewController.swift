//
//  OrderBookDetailViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DGCharts
import Kingfisher
import iOSDropDown

class OrderBookDetailViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let orderBookDetailViewModel = OrderBookDetailViewModel()
    private var timer: Timer?
    
    let coinData : [AddTradesModel]
    init(coinData : [AddTradesModel]) {
        self.coinData = coinData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    //텍스트
    private let coinImage : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .keyColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = nil
        return view
    }()
    //캔들차트뷰
    private let orderBookView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .BackColor
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    //캔들텍스트
    private let orderBookText : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .black
        text.font = UIFont.boldSystemFont(ofSize: 12)
        text.textAlignment = .left
        text.backgroundColor = .BackColor
        text.isScrollEnabled = false
        text.clipsToBounds = true
        text.isUserInteractionEnabled = false
        text.layer.borderWidth = 1
        return text
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .keyColor
        self.navigationController?.navigationBar.tintColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCoinData()
        setBinding()
        setupTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}
//MARK: - UI Layout
extension OrderBookDetailViewController {
    private func setLayout() {
        self.view.clipsToBounds = true
        self.view.backgroundColor = .keyColor
        self.view.addSubview(coinImage)
        
        self.orderBookView.addSubview(orderBookText)
        self.view.addSubview(orderBookView)
        
        coinImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(self.view.frame.height / 10)
            make.height.equalToSuperview().dividedBy(4)
        }
        orderBookText.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(50)
        }
        orderBookView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(50)
            make.top.equalTo(coinImage.snp.bottom).offset(20)
        }
    }
}
//MARK: - setValue
extension OrderBookDetailViewController {
    private func setCoinData() {
        //코인 정보
        let coinName = coinData.compactMap{ $0.coinName }
        let coinMarket = coinData.compactMap{ $0.tradesData.market }
        self.titleLabel.text = "\(coinName[0]) \(coinMarket[0])"
        self.navigationItem.titleView = titleLabel
        
        
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateData() {
        
    }
}
//MARK: - SetBinding
extension OrderBookDetailViewController {
    private func setBinding() {
        guard let english_name = coinData.compactMap({ $0.englishName }).first else{return}
        orderBookDetailViewModel.imageTrigger.onNext(english_name)
        
        orderBookDetailViewModel.imageResult
            .subscribe { paprikaModel in
                let imageUrl = paprikaModel.element?.logo
                if let urlString = imageUrl {
                    if let url = URL(string: urlString) {
                        self.coinImage.kf.setImage(with: url)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
