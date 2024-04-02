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
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcher"
        label.textColor = .keyColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
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
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.title = ""
        
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
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected([CoinDataWithAdditionalInfo].self)
            .subscribe { selectedModel in
                self.navigationController?.pushViewController(MainDetailViewController(coinData: selectedModel), animated: true)
            }
            .disposed(by: disposeBag)
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let screenHeight = self.tableView.frame.height
                if offsetY > contentHeight - screenHeight {
                    self.mainViewModel.loadMoreData()
                }
            })
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                self.mainViewModel.inputTrigger.onNext(())
            }
            .disposed(by: disposeBag)
//        searchBtn.rx.controlEvent(.valueChanged)
//            .subscribe { _ in
//                <#code#>
//            }
//            .disposed(by: disposeBag)
    }
}
