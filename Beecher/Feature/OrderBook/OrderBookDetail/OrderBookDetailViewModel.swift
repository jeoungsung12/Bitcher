//
//  OrderBookDetailViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class OrderBookDetailViewModel {
    private let disposeBag = DisposeBag()
    let imageTrigger = PublishSubject<String>()
    let imageResult : PublishSubject<GetImageModel> = PublishSubject()
    
    init() {
        imageTrigger.flatMapLatest { name in
            return GetImageService.getCoin(englishName: name)
        }
        .bind(to: imageResult)
        .disposed(by: disposeBag)
    }
}
