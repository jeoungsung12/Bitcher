//
//  NewsService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class NewsService {
    static func getNews(query : String, start : Int) -> Observable<[NewsItems]> {
        return Observable.create { observer in
            let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = "https://openapi.naver.com/v1/search/news.json?query=\(queryEncoded)&display=15&start=\(start)&sort=sim"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: NewsServiceModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data.item ?? [])
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
