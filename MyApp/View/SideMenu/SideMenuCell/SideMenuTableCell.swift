//
//  SideMenuTableCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/23/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class SideMenuTableCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: SideMenuCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
        }
    }
}
