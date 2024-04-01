//
//  GetAllCoinModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation
struct GetAllCoinModel : Codable {
    let data : [CoinData]?
}
struct CoinData : Codable {
    let id : String?
    let symbol : String?
    let name : String?
    let rank : Int?
    let price_usd : String?
    let percent_change_24h : String?
    let percent_change_1h : String?
    let percent_change_7d : String?
    let price_btc : String?
    let market_cap_usd : String?
    let volume24 : Double?
    let volume24a : Double?
    let csupply : String?
    let tsupply : String?
    let msupply : String?
    let info : CoinInfo?
}
struct CoinInfo : Codable {
    let coins_num : Double?
    let time : Double?
}
