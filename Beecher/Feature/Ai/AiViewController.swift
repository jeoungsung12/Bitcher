//
//  AiViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import DGCharts
import NVActivityIndicatorView
import Kingfisher

class AiViewController : UIViewController, UITextFieldDelegate {
    private let disposeBag = DisposeBag()
    private let ordersearchViewModel = OrderSearchViewModel()
    private var coinData : [AddTradesModel] = []
    
    //MARK: UI Components
    private lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
    }()
    //검색 창
    private let searchView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.keyColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
        return view
    }()
    //검색 텍스트
    private let searchText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.backgroundColor = .white
        text.placeholder = "코인명(한/영)"
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.frame = CGRect(x: 10, y: 3, width: 200, height: 30)
        return text
    }()
    //검색
    private let searchBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .keyColor
        return btn
    }()
    //타이틀
    private let navigationTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcher"
        label.textColor = .keyColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    private let image : AnimatedImageView = {
        let view = AnimatedImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    //코인 이름
    private let titleLabel : UITextField = {
        let label = UITextField()
        label.isEnabled = false
        label.textColor = .black
        label.text = ""
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    //거래량 총액
    private let availLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .white
        return label
    }()
    //코인 가격
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.borderWidth = 1
        return label
    }()
    //코인 상승세
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    private let MoveBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
}
//MARK: - UI Layout
extension AiViewController {
    private func setLayout() {
        self.title = "Ai"
        self.view.backgroundColor = .white
        self.navigationItem.titleView = navigationTitleLabel
        self.view.clipsToBounds = true
        self.view.addGestureRecognizer(tapGesture)
        self.searchText.delegate = self
        
        totalView.addSubview(titleLabel)
        totalView.addSubview(availLabel)
        totalView.addSubview(price)
        totalView.addSubview(arrow)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        availLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        self.view.addSubview(totalView)
        self.view.addSubview(image)
        self.view.addSubview(MoveBtn)
        
        image.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalToSuperview().dividedBy(3)
            make.top.equalToSuperview().offset(self.view.frame.height / 10)
        }
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
            make.height.equalTo(80)
        }
        MoveBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
            make.height.equalTo(80)
        }
        
        startLoadingAnimation()
    }
    private func setValue(model : [AddTradesModel]) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}
//MARK: - setBinding
extension AiViewController {
    private func setBinding() {
        
    }
    private func startLoadingAnimation() {
        if let gifUrl = Bundle.main.url(forResource: "cube", withExtension: "gif") {
            self.image.kf.setImage(with: gifUrl)
        }
    }
    private func stopLoadingAnimation() {
        self.image.image = nil
    }
}
