//
//  Color.swift
//  MyApp
//
//  Created by DaoNV on 6/19/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

/**
 This file defines all colors which are used in this application.
 Please navigate by the control as prefix.
 */

import UIKit

extension App {
    struct Color {
        static let navigationBar = UIColor.black
        static let tableHeaderView = UIColor.gray
        static let tableFooterView = UIColor.red
        static let tableCellTextLabel = UIColor.yellow

        static func button(state: UIControlState) -> UIColor {
            switch state {
            case UIControlState.normal: return .blue
            default: return .gray
            }
        }

        static let mainColor = UIColor.rgb(red: 127, green: 186, blue: 0)
        static let extraColor = UIColor.rgb(red: 81, green: 82, blue: 82)
        static let backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
    }
}
