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
    //페이징 변수
    private let initialLoadStart = 0
    private let initialLoadLimit = 3
    private var currentPage = 0
    
    init() {
        inputTrigger
            .startWith(())
            .subscribe { _ in
                CoinService.getAllCoin(start: self.initialLoadStart, limit: self.initialLoadLimit)
                    .map { coinData -> [[CoinDataWithAdditionalInfo]] in
                        return coinData
                    }
                    .bind(to: self.MainTable)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        // 60초마다 새로운 데이터 가져오기
        Observable<Int>.interval(.seconds(60), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.inputTrigger.onNext(())
            })
            .disposed(by: disposeBag)
    }
    func loadMoreData() {
        currentPage += 1
        let start = currentPage * 3
        let limit = start + 3
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
                })
                .disposed(by: disposeBag)
        }else{
            return
        }
    }
}
