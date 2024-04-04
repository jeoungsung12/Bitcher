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
import iOSDropDown

class MainDetailViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let mainDetailViewModel = MainDetailViewModel()
    private let dropdown = DropDown()
    let coinData : [CoinDataWithAdditionalInfo]
    init(coinData : [CoinDataWithAdditionalInfo]) {
        self.coinData = coinData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
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
    //차트 뷰
    private let chartView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .keyColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
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
    //캔들차트
    private let candleChart : CandleStickChartView = {
        let view = CandleStickChartView()
        view.isUserInteractionEnabled = false
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.drawLabelsEnabled = true
        view.rightAxis.drawLabelsEnabled = false
        view.noDataText = ""
        view.legend.textColor = .black
        view.backgroundColor = .clear
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
        setDropDown()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
//MARK: - UI Layout
extension MainDetailViewController {
    private func setLayout() {
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.view.addSubview(rateText)
        
        self.chartView.addSubview(chartTitle)
        self.chartView.addSubview(chart)
        
        self.view.addSubview(chartView)
        
        self.view.addSubview(dropdown)
        self.view.addSubview(candleChart)
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
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(rateText.snp.bottom).offset(30)
            make.height.equalToSuperview().dividedBy(4)
        }
        dropdown.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(chartView.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        candleChart.snp.makeConstraints { make in
            make.top.equalTo(dropdown.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(30)
        }
    }
}
//MARK: - setValue
extension MainDetailViewController {
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
    private func setCandleMinute(data : [CandleMinuteModel]) {
        var entries: [CandleChartDataEntry] = []
        for (index, candleData) in data.enumerated() {
            entries.append(CandleChartDataEntry(x: Double(index), shadowH: candleData.high_price ?? 0, shadowL: candleData.low_price ?? 0, open: candleData.opening_price ?? 0, close: candleData.trade_price ?? 0))
        }
        let dataSet = CandleChartDataSet(entries: entries, label: "캔들 차트")
        dataSet.colors = [.systemRed, .systemBlue]
        dataSet.drawValuesEnabled = false
        let data = CandleChartData(dataSet: dataSet)
        
        candleChart.data = data
    }
    private func setCandleDay(data : [CandleDayModel]) {
        var entries: [CandleChartDataEntry] = []
        for (index, candleData) in data.enumerated() {
            entries.append(CandleChartDataEntry(x: Double(index), shadowH: candleData.high_price ?? 0, shadowL: candleData.low_price ?? 0, open: candleData.opening_price ?? 0, close: candleData.trade_price ?? 0))
        }
        let dataSet = CandleChartDataSet(entries: entries, label: "캔들 차트")
        dataSet.colors = [.systemRed, .systemBlue]
        dataSet.drawValuesEnabled = false
        let data = CandleChartData(dataSet: dataSet)
        candleChart.animate(xAxisDuration: 2, yAxisDuration: 0, easingOption: .easeInQuad)
        candleChart.data = data
    }
    private func setCandleWM(data : [CandleWMModel]) {
        var entries: [CandleChartDataEntry] = []
        for (index, candleData) in data.enumerated() {
            entries.append(CandleChartDataEntry(x: Double(index), shadowH: candleData.high_price ?? 0, shadowL: candleData.low_price ?? 0, open: candleData.opening_price ?? 0, close: candleData.trade_price ?? 0))
        }
        let dataSet = CandleChartDataSet(entries: entries, label: "캔들 차트")
        dataSet.colors = [.systemRed, .systemBlue]
        dataSet.drawValuesEnabled = false
        let data = CandleChartData(dataSet: dataSet)
        candleChart.animate(xAxisDuration: 2, yAxisDuration: 0, easingOption: .easeInQuad)
        candleChart.data = data
    }
    private func setDropDown() {
        let coinData = self.coinData.compactMap{ $0.coinData.market }
        dropdown.optionArray = ["분", "일", "주", "월"]
        dropdown.isSearchEnable = false
        dropdown.text = "일"
        dropdown.font = UIFont.systemFont(ofSize: 14)
        dropdown.textColor = UIColor.black
        dropdown.selectedRowColor = UIColor.keyColor
        dropdown.arrowSize = 10
        dropdown.checkMarkEnabled = false
        dropdown.backgroundColor = UIColor.white
        // 선택한 항목에 대한 이벤트 처리
        dropdown.didSelect { (selectedItem, index, id) in
            if index == 0 {
                self.mainDetailViewModel.MinuteTrigger.onNext([coinData[0], "minutes"])
            }else if index == 1 {
                self.mainDetailViewModel.DayTrigger.onNext([coinData[0], "days"])
            }else if index == 2 {
                self.mainDetailViewModel.WMTrigger.onNext([coinData[0], "weeks"])
            }else if index == 3 {
                self.mainDetailViewModel.WMTrigger.onNext([coinData[0], "months"])
            }
        }
    }
}
//MARK: - SetBinding
extension MainDetailViewController {
    private func setBinding() {
        let coinData = self.coinData.compactMap{ $0.coinData.market }
        self.mainDetailViewModel.DayTrigger.onNext([coinData[0], "days"])
        self.mainDetailViewModel.DayResult
            .subscribe { candleData in
                self.setCandleDay(data: candleData)
            }
            .disposed(by: disposeBag)
        self.mainDetailViewModel.MinuteResult
            .subscribe { candleData in
                self.setCandleMinute(data: candleData)
            }
            .disposed(by: disposeBag)
        self.mainDetailViewModel.WMResult
            .subscribe { candleData in
                self.setCandleWM(data: candleData)
            }
            .disposed(by: disposeBag)
    }
}
