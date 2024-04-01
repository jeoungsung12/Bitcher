//
//  CoinService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class CoinService {
    static func getAllCoin(start : Int, limit : Int) -> Observable<GetAllCoinModel> {
        return Observable.create { observer in
            let url = "https://api.coinlore.net/api/tickers/?start=\(start)&limit=\(limit)"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/json"])
                .validate()
                .responseDecodable(of: GetAllCoinModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
}
