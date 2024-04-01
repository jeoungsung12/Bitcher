//
//  MainTableViewCell.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/03.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit

class MainTableViewCell : UITableViewCell {
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    //코인 이름
    private let titleLabel : UITextField = {
        let label = UITextField()
        label.isEnabled = false
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    //코인 시가 총액
    private let availLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .white
        return label
    }()
    //코인 가격
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    //코인 상승세
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    private func setupUI() {
        let contentView = self.contentView
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        totalView.addSubview(titleLabel)
        totalView.addSubview(availLabel)
        totalView.addSubview(price)
        totalView.addSubview(arrow)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        availLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        contentView.addSubview(totalView)
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    func configure(with model: CoinData) {
        titleLabel.text = model.name
        availLabel.text = "시가 총액 기준 순위 : \(model.rank ?? 0)위"
        price.text = "$\(model.price_usd ?? "")"
        if let percent = Double(model.percent_change_1h ?? "0") {
            if percent >= 0 {
                arrow.textColor = .systemRed
                arrow.text = "+\(percent)% 📈"
            }else {
                arrow.textColor = .systemBlue
                arrow.text = "\(percent)% 📉"
            }
        }else{}
    }
}
