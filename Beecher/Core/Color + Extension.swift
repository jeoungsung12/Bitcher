//
//  Color + Extension.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import Foundation
import UIKit

extension UIColor {
    static let keyColor : UIColor = {
        return UIColor(named: "KeyColor") ?? .white
    }()
    static let graph1 : UIColor = {
        return UIColor(named: "graph1") ?? .white
    }()
    static let graph2 : UIColor = {
        return UIColor(named: "graph2") ?? .white
    }()
    static let graph3 : UIColor = {
        return UIColor(named: "graph3") ?? .white
    }()
    static let TabColor : UIColor = {
        return UIColor(named: "TabColor") ?? .white
    }()
}
