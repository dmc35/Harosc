//
//  DetailContentCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/28/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class DetailContentCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var contentLabel: UILabel!

    // MARK: - Properties
    var viewModel: DetailContentCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            guard let content = viewModel.content.stringFromHtml()?.string else {
                contentLabel.text = "Chưa có mô tả cho địa điểm"
                return
            }
            contentLabel.text = content
        }
    }
}
