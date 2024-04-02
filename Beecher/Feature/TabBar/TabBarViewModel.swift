//
//  TabBarViewModel.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/04.
//

import Foundation
import RxSwift
import RxCocoa

class TabBarViewModel {
    private let disposeBag = DisposeBag()
    let selectedTabIndex = PublishSubject<Int>()
    let selectedTabTitle: Driver<String>
    init() {
        selectedTabTitle = selectedTabIndex
            .map { index in
                switch index {
                case 0: return "메인"
                case 1: return "생성"
                case 2: return "마이페이지"
                default: return ""
                }
            }
            .asDriver(onErrorJustReturn: "")
    }
}
