//
//  MainDetailViewController.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DGCharts
import Kingfisher

class MainDetailViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let mainDetailViewModel = MainDetailViewModel()
    let coinData : [CoinDataWithAdditionalInfo]
    init(coinData : [CoinDataWithAdditionalInfo]) {
        self.coinData = coinData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //필기 텍스트
    private let rateText : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .gray
        text.font = UIFont.systemFont(ofSize: 13)
        text.textAlignment = .left
        text.backgroundColor = .white
        text.isScrollEnabled = false
        text.clipsToBounds = true
        return text
    }()
    private let chartTitle: UILabel = {
        let label = UILabel()
        label.text = "〽️52주 신고가, 신저가"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    //52주 차트
    private let chart : BarChartView = {
        let view = BarChartView()
        view.isUserInteractionEnabled = false
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.noDataText = ""
        view.legend.textColor = .white
        view.backgroundColor = .clear
        return view
    }()
    //캔들 뷰
    private let candelView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .keyColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    //캔들 차트
    
    //로딩 이미지
    private let loadingIndicator : AnimatedImageView = {
        let view = AnimatedImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCoinData()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
//MARK: - setLayout
extension MainDetailViewController {
    private func setLayout() {
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.view.addSubview(rateText)
        
        self.candelView.addSubview(chartTitle)
        self.candelView.addSubview(chart)
        
        self.view.addSubview(candelView)
        self.view.addSubview(loadingIndicator)
        rateText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(self.view.frame.height / 10)
            make.height.equalTo(50)
        }
        chartTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        chart.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(0)
            make.top.equalTo(chartTitle.snp.bottom).offset(0)
        }
        candelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(rateText.snp.bottom).offset(30)
            make.height.equalToSuperview().dividedBy(4)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
    private func startLoadingAnimation() {
        if let gifUrl = Bundle.main.url(forResource: "coin", withExtension: "gif") {
            self.loadingIndicator.kf.setImage(with: gifUrl)
        }
    }
    private func stopLoadingAnimation() {
        self.loadingIndicator.image = nil
    }
}
//MARK: - setBinding
extension MainDetailViewController {
    private func setBinding() {
        
    }
    private func setChart(high : Double, highDate : String, low : Double, lowDate : String) {
        var entries: [BarChartDataEntry] = []
        entries.append(BarChartDataEntry(x: 0, y: high))
        entries.append(BarChartDataEntry(x: 1, y: low))
        
        let dataSet = BarChartDataSet(entries: entries, label: "신고가 : \(highDate), 신저가 : \(lowDate)")
        dataSet.colors = [.graph1, .graph2]
        dataSet.valueTextColor = .white
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.stackLabels = [highDate, lowDate]
        let data = BarChartData(dataSet: dataSet)
        chart.animate(xAxisDuration: 0, yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        chart.data = data
    }
    private func setCoinData() {
        //코인 정보
        let coinName = coinData.compactMap{ $0.coinName }
        let coinMarket = coinData.compactMap{ $0.coinData.market }
        self.title = "\(coinName[0]) \(coinMarket[0])"
        
        //누적거래대금, 누적 거래량, 52주 신고가, 신고가 달성일, 신저가, 신저가 달성일
        let acc_trade_price_24h = coinData.compactMap{ $0.coinData.acc_trade_price_24h }
        let acc_trade_volume_24h = coinData.compactMap{ $0.coinData.acc_trade_volume_24h }
        let highest_52_week_price = coinData.compactMap{ $0.coinData.highest_52_week_price }
        let highest_52_week_date = coinData.compactMap{ $0.coinData.highest_52_week_date }
        let lowest_52_week_date = coinData.compactMap{ $0.coinData.lowest_52_week_date }
        let lowest_52_week_price = coinData.compactMap{ $0.coinData.lowest_52_week_price }
        
        setChart(high: highest_52_week_price[0], highDate: highest_52_week_date[0], low: lowest_52_week_price[0], lowDate: lowest_52_week_date[0])
        rateText.text = "24h 누적 거래대금 : \(acc_trade_price_24h[0])\n24h 누적 거래량 : \(acc_trade_volume_24h[0])"
    }
}
