//
//  MainViewModel.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/03.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let disposeBag = DisposeBag()
    let inputTrigger = PublishSubject<Void>()
    let MainTable: BehaviorRelay<[[CoinDataWithAdditionalInfo]]> = BehaviorRelay(value: [])
    
    //검색
    let searchInputrigger = PublishSubject<String>()
    let searchResult : PublishSubject<[CoinDataWithAdditionalInfo]> = PublishSubject()
    //페이징 변수
    private let initialLoadStart = 0
    private let initialLoadLimit = 5
    private var currentPage = 0
    
    init() {
        //MARK: - GetCoinInfo
        inputTrigger
            .subscribe { _ in
                CoinService.getAllCoin(start: self.initialLoadStart, limit: self.initialLoadLimit)
                    .map { coinData -> [[CoinDataWithAdditionalInfo]] in
                        return coinData
                    }
                    .bind(to: self.MainTable)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    func loadMoreData(completion: @escaping () -> Void) {
        currentPage += 1
        let start = currentPage * 5
        let limit = start + 5
        print("첫 시작 \(start), \(limit)")
        if limit <= 100 {
            CoinService.getAllCoin(start: start, limit: limit)
                .map { coinData -> [[CoinDataWithAdditionalInfo]] in
                    return coinData
                }
                .subscribe(onNext: { [weak self] newData in
                    guard let self = self else { return }
                    var currentData = self.MainTable.value
                    currentData.append(contentsOf: newData)
                    self.MainTable.accept(currentData)
                    completion()
                })
                .disposed(by: disposeBag)
        } else {
            completion()
            return
        }
    }
}
