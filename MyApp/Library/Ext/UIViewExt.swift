//
//  ImageExt.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/29/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: Public
    public class func cornerView(view: UIView) -> CGFloat {
        return view.frame.height / 2
    }

    public class func shadowView(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
    }
}
