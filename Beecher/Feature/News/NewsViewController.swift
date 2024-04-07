//
//  NewsViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView
import Kingfisher

class NewsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let newsViewModel = NewsViewModel()
    
    //데이터 관련 변수
    private var isLoadingData = false
    
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
    //뉴스 타이틀
    private let newsLabel : UILabel = {
        let label = UILabel()
        label.text = "News"
        label.textColor = .black
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
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.isPagingEnabled = false
        view.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    private let loadingIndicator : AnimatedImageView = {
        let view = AnimatedImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
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
extension NewsViewController {
    private func setLayout() {
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: newsLabel)
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.title = "뉴스"
        
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
}
//MARK: - Binding
extension NewsViewController {
    private func setBinding() {
        newsViewModel.inputTrigger.onNext(("암호화폐"))
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
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let screenHeight = self.tableView.frame.height
                guard !self.isLoadingData else { return }
                if offsetY > contentHeight - screenHeight {
                    self.isLoadingData = true
                    self.startLoadingAnimation()
                    self.newsViewModel.loadMoreData(query: "암호화폐") {
                        self.isLoadingData = false
                        self.stopLoadingAnimation()
                    }
                }
            })
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                self.newsViewModel.inputTrigger.onNext(("암호화폐"))
            }
            .disposed(by: disposeBag)
        searchBtn.rx.tap
            .subscribe { _ in
                self.navigationController?.pushViewController(NewsSearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func startLoadingAnimation() {
        if let gifUrl = Bundle.main.url(forResource: "Coin", withExtension: "gif") {
            self.loadingIndicator.kf.setImage(with: gifUrl)
        }
    }
    private func stopLoadingAnimation() {
        self.loadingIndicator.image = nil
    }
}