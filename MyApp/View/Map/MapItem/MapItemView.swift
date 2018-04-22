//
//  MapItemView.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol MapItemViewDelegate: class {
    func mapItem(_ view: MapItemView, needsPerformAction action: MapItemView.Action)
}

final class MapItemView: UIView, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    // MARK: - Properties
    enum Action {
        case push(Int)
        case cancel
    }

    weak var delegate: MapItemViewDelegate?
    var parentNaviController: UINavigationController?
    var viewModel: MapItemViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    private func configView() {
        codeView.corner = UIView.cornerView(view: codeView)
    }

    // MARK: - Public func
    func updateView() {
        guard let viewModel = viewModel else { return }
        thumbnailImageView.image = nil
        let thumbnailUrl = viewModel.dataItem.thumImage
        thumbnailImageView.setImage(with: thumbnailUrl)
        codeLabel.text = viewModel.dataItem.code
        titleLabel.text = viewModel.dataItem.title
        addressLabel.text = viewModel.dataItem.address
    }

    // MARK: - IBActions
    @IBAction func detailButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        let id = viewModel.dataItem.id
        delegate?.mapItem(self, needsPerformAction: .push(id))
    }
}
