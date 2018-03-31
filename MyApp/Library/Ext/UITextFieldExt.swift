//
//  UITextFieldExt.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/7/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

extension UITextField {
    override open func awakeFromNib() {
        super.awakeFromNib()
        changeStyleTextField()
        addPaddingLeft(10)
    }

    func changeStyleTextField() {
        layer.backgroundColor = App.Color.backgroundColor.cgColor
    }

    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
