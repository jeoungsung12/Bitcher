//
//  NewsSearchViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import NVActivityIndicatorView
import Kingfisher

class NewsSearchViewController : UIViewController, UITextFieldDelegate {
    private let disposeBag = DisposeBag()
    private let newsViewModel = NewsViewModel()
    //데이터 관련 변수
    private var isLoadingData = false
    
    //MARK: UI Components
    private lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
    }()
    //리프레시
    private let refresh : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .lightGray
        return refresh
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
        text.placeholder = "궁금한 기사를 검색해 보세요!"
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.frame = CGRect(x: 10, y: 3, width: 200, height: 30)
        return text
    }()
    //검색 버튼
    private let searchBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .keyColor
        return btn
    }()
    private let loadingIndicator : AnimatedImageView = {
        let view = AnimatedImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    private let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.isPagingEnabled = false
        view.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
//MARK: - UI Layout
extension NewsSearchViewController {
    private func setLayout() {
        self.title = ""
        self.view.backgroundColor = .white
        self.searchView.addSubview(searchText)
        self.navigationItem.titleView = searchView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
        self.view.addGestureRecognizer(tapGesture)
        self.searchText.delegate = self
        self.tableView.addSubview(refresh)
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        self.startLoadingAnimation()
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
extension NewsSearchViewController {
    private func setBinding() {
        newsViewModel.MainTable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: NewsTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                self.stopLoadingAnimation()
                self.refresh.endRefreshing()
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected([AddTradesModel].self)
            .subscribe { selectedModel in
                
            }
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                if self.searchText.text != "" {
                    self.newsViewModel.inputTrigger.onNext((self.searchText.text ?? ""))
                }else{ self.refresh.endRefreshing() }
            }
            .disposed(by: disposeBag)
        searchBtn.rx.tap
            .subscribe { _ in
                self.hideKeyboard()
                print("\(self.searchText.text ?? "")")
                if self.searchText.text != "" {
                    self.newsViewModel.inputTrigger.onNext((self.searchText.text ?? ""))
                }else{}
            }
            .disposed(by: disposeBag)
    }
    private func startLoadingAnimation() {
        if let gifUrl = Bundle.main.url(forResource: "coin", withExtension: "gif") {
            self.loadingIndicator.kf.setImage(with: gifUrl)
        }
    }
    private func stopLoadingAnimation() {
        self.loadingIndicator.image = nil
    }
}
