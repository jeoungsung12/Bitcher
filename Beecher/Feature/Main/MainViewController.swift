//
//  ViewController.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    //검색 창
    private let searchView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.keyColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        return view
    }()
    //검색 텍스트
    private let searchText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.backgroundColor = .white
        text.placeholder = "코인을 검색하세요!"
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
    //리프레시
    private let refresh : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .lightGray
        return refresh
    }()
    //테이블뷰
    private let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    private let loadingIndicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = .lightGray
        return view
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
extension MainViewController {
    private func setLayout() {
        self.title = ""
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.searchView.addSubview(searchText)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView)
        
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
        self.loadingIndicator.startAnimating()
    }
}
//MARK: - Binding
extension MainViewController {
    private func setBinding() {
        mainViewModel.inputTrigger.onNext(())
        mainViewModel.MainTable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MainTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                self.loadingIndicator.stopAnimating()
                self.refresh.endRefreshing()
                
                if index == self.mainViewModel.MainTable.value.count - 1 {
                    self.loadingIndicator.startAnimating()
                    self.mainViewModel.loadMoreData()
                }
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(CoinData.self)
            .subscribe { selectedModel in
                self.navigationController?.pushViewController(MainDetailViewController(notes: selectedModel), animated: true)
            }
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                self.mainViewModel.inputTrigger.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
