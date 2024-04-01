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
    static func getAllCoin(start: Int, limit: Int) -> Observable<[[CoinDataWithAdditionalInfo]]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/market/all?isDetails=False"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [GetAllCoinModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        self.getDetail(data, start: start, limit: limit) { result in
                            switch result {
                            case .success(let coinDataArray):
                                observer.onNext(coinDataArray)
                                observer.onCompleted()
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    private static func getDetail(_ Data: [GetAllCoinModel], start: Int, limit: Int, completion: @escaping (Result<[[CoinDataWithAdditionalInfo]], Error>) -> Void) {
        var coinDataArray: [[CoinDataWithAdditionalInfo]] = []
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.example.coinDataQueue")
        
        let startIndex = max(0, min(start, Data.count))
        let endIndex = min(startIndex + limit, Data.count)
        let slicedData = Data[startIndex..<endIndex]
        for data in slicedData {
            if let market = data.market{
                group.enter()
                let url = "https://api.upbit.com/v1/ticker?markets=\(market)"
                AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                    .validate()
                    .responseDecodable(of: [CoinData].self) { response in
                        defer { group.leave() }
                        switch response.result {
                        case .success(let coinData):
                            if let coinName = data.korean_name{
                                let coinDataWithAdditionalInfo = coinData.map { CoinDataWithAdditionalInfo(coinData: $0, coinName: "\(coinName) \(market)") }
                                queue.sync {
                                    coinDataArray.append(coinDataWithAdditionalInfo)
                                }
                            }
                        case .failure(let error):
                            print("\(error)")
                        }
                    }
            }
        }
        group.notify(queue: .main) {
            completion(.success(coinDataArray))
        }
    }
}
