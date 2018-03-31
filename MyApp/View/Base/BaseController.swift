//
//  BaseController.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/8/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

class BaseController: UIViewController, MVVM.View {
    override func viewDidLoad() {
        super.viewDidLoad()

        formatNavigation()
        configTitle()
    }

    func formatNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
    }

    func configTitle() {
        let fontTitle = UIFont.systemFont(ofSize: 15, weight: .bold)
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: fontTitle]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }

    func configBarColor() {
        navigationItem.leftBarButtonItem?.tintColor = App.Color.mainColor
        navigationItem.rightBarButtonItem?.tintColor = App.Color.mainColor
    }
}
