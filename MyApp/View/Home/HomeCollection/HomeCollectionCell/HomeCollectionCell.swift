//
//  HomeCollectionCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/26/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class HomeCollectionCell: UICollectionViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var codeView: UIView!
    @IBOutlet fileprivate weak var codeLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!

    // MARK: - Properties
    var viewModel: HomeCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    // MARK: - Private
    private func configCell() {
        codeView.corner = UIView.cornerView(view: codeView)
    }

    // MARK: - Public
    func updateView() {
        thumbnailImageView.image = nil
        guard let viewModel = viewModel else { return }
        let thumbnailUrl = viewModel.data.thumImage
        thumbnailImageView.setImage(with: thumbnailUrl)
        codeLabel.text = viewModel.data.code
        titleLabel.text = viewModel.data.title
        addressLabel.text = viewModel.data.address
    }
}
