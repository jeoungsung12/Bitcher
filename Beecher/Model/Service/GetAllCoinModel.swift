//
//  GetAllCoinModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation
//struct GetAllCoinModel : Codable {
//    let data : [CoinData]?
//}
//struct CoinData : Codable {
//    let id : String?
//    let symbol : String?
//    let name : String?
//    let rank : Int?
//    let price_usd : String?
//    let percent_change_24h : String?
//    let percent_change_1h : String?
//    let percent_change_7d : String?
//    let price_btc : String?
//    let market_cap_usd : String?
//    let volume24 : Double?
//    let volume24a : Double?
//    let csupply : String?
//    let tsupply : String?
//    let msupply : String?
//    let info : CoinInfo?
//}
//struct CoinInfo : Codable {
//    let coins_num : Double?
//    let time : Double?
//}
struct GetAllCoinModel : Codable {
    let market : String?
    let korean_name : String?
    let english_name : String?
}
struct CoinData : Codable{
    let market : String?
    let trade_date : String?
    let trade_time : String?
    let trade_date_kst : String?
    let trade_time_kst : String?
    let trade_timestamp : Double?
    let opening_price :Double?
    let high_price : Double?
    let low_price : Double?
    let trade_price : Double?
    let prev_closing_price : Double?
    let change : String?
    let change_price : Double?
    let change_rate : Double?
    let signed_change_price : Double?
    let signed_change_rate : Double?
    let trade_volume : Double?
    let acc_trade_price : Double?
    let acc_trade_price_24h : Double?
    let acc_trade_volume : Double?
    let acc_trade_volume_24h : Double?
    let highest_52_week_price : Double?
    let highest_52_week_date : String?
    let lowest_52_week_price : Double?
    let lowest_52_week_date : String?
    let timestamp : Double?
}
struct CoinDataWithAdditionalInfo {
    let coinData: CoinData
    let coinName: String
}
