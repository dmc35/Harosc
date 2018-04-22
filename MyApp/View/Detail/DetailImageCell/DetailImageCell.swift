//
//  DetailImageCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol DetailImageCellDelegate: class {
    func detailImage(_ view: DetailImageCell, needsPerformType type: DetailImageCell.ImageType)
}

final class DetailImageCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var launchView: UIView!
    @IBOutlet fileprivate weak var launchImage: UIImageView!
    @IBOutlet fileprivate weak var launchNumberLabel: UILabel!
    @IBOutlet fileprivate weak var menuView: UIView!
    @IBOutlet fileprivate weak var menuImage: UIImageView!
    @IBOutlet fileprivate weak var menuNumberLabel: UILabel!

    // MARK: - Properties
    enum ImageType {
        case launch
        case menu
    }

    weak var delegate: DetailImageCellDelegate?
    var viewModel: DetailImageCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        addGentureView()
    }

    // MARK: - Private func
    private func addGentureView() {
        let launchTapGenture = UITapGestureRecognizer(target: self, action: #selector(launchViewTouchUpInside))
        launchView.isUserInteractionEnabled = true
        launchView.addGestureRecognizer(launchTapGenture)

        let menuTapGenture = UITapGestureRecognizer(target: self, action: #selector(menuViewTouchUpInside))
        menuView.isUserInteractionEnabled = true
        menuView.addGestureRecognizer(menuTapGenture)
    }

    // MARK: - Private objc func
    @objc private func launchViewTouchUpInside() {
        delegate?.detailImage(self, needsPerformType: .launch)
    }

    @objc private func menuViewTouchUpInside() {
        delegate?.detailImage(self, needsPerformType: .menu)
    }

    // MARK: - Public func
    func updateView() {
        guard let viewModel = viewModel else { return }
        launchImage.image = nil
        menuImage.image = nil
        launchNumberLabel.text = "(" + "\(viewModel.launchNumber)" + " hình)"
        let launchUrl = viewModel.launchUrl
        launchImage.setImage(with: launchUrl)

        menuNumberLabel.text = "(" + "\(viewModel.menuNumber)" + " hình)"
        let menuUrl = viewModel.menuUrl
        menuImage.setImage(with: menuUrl)
    }
}
