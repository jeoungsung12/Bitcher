//
//  ChatGPTService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Alamofire
class ChatGPTService {
    static func requestChat(searchTitle : String) -> Observable<ChatServiceModel> {
        return Observable.create { observer in
            let url = "https://api.openai.com/v1/chat/completions"
            let parameters: [String: Any] = [
                            "model": "gpt-3.5-turbo",
                            "messages": [
                                ["role": "system", "content": "I will tell you the 1-year chart, 52-week high, and 52-week low for this cryptocurrency that I gave you. Based on the articles and information you know about this cryptocurrency, 1. Approximate rise and fall probabilities (numbers) of the cryptocurrency. Let me know. 2. Please give me a rough idea of your opinion on whether it is worth investing in. Please speak politely in Korean."],
                                ["role": "user", "content": "SearchInfo : \(searchTitle)"]
                            ]
                        ]
            AF.request(url, method: .post ,parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(Bundle.main.AiAppKey)", "Content-Type" : "application/json"])
                .validate()
                .responseDecodable(of: ChatServiceModel.self){ response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
