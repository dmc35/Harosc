//
//  DetailCollectionCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/27/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class DetailCollectionCell: UICollectionViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var headerImageView: UIImageView!

    // MARK: - Properties
    var viewModel: DetailCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Public
    func updateView() {
        headerImageView.image = nil
        guard let viewModel = viewModel else { return }
        let imageUrl = viewModel.imageUrl
        headerImageView.setImage(with: imageUrl)
    }
}
