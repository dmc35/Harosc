//
//  InputView.swift
//  MyApp
//
//  Created by DaoNV on 4/19/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

extension UITextView {
    var string: String { return text ?? "" }
}

extension UITextField {
    var string: String { return text ?? "" }
}
