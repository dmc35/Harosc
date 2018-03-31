//
//  ProfileCollectionViewCell.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/4/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

protocol ProfileCollectionCellDelegate: class {
    func profileCollection(_ view: ProfileCollectionCell, needsPerformAction action: ProfileCollectionCell.Action)
}

final class ProfileCollectionCell: UICollectionViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var codeView: UIView!
    @IBOutlet fileprivate weak var codeLabel: UILabel!
    @IBOutlet fileprivate weak var deleteView: UIView!
    @IBOutlet fileprivate weak var deleteImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!

    // MARK: - Properties
    enum Action {
        case success(Int)
        case failure
    }

    weak var delegate: ProfileCollectionCellDelegate?

    var viewModel: ProfileCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
        addGentureRemoveView()
    }

    // MARK: - Private
    private func configCell() {
        codeView.corner = UIView.cornerView(view: codeView)
        deleteImageView.layer.cornerRadius = 4
    }

    private func addGentureRemoveView() {
        let tapGenture = UITapGestureRecognizer(target: self, action: #selector(pressRemoveView))
        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(tapGenture)
    }

    func updateView() {
        thumbnailImageView.image = nil
        guard let viewModel = viewModel else { return }
        let thumbnailUrl = viewModel.itemFavorite.thumImage
        thumbnailImageView.setImage(with: thumbnailUrl)
        codeLabel.text = viewModel.itemFavorite.code
        titleLabel.text = viewModel.itemFavorite.title
        addressLabel.text = viewModel.itemFavorite.address
    }

    // MARK: - objc Private
    @objc private func pressRemoveView() {
        guard let viewModel = viewModel else { return }
        delegate?.profileCollection(self, needsPerformAction: .success(viewModel.itemFavorite.id))
    }
}
