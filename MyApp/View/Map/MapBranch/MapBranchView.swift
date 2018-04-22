//
//  MapBranch.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import SwiftUtils
import Koloda

protocol MapBranchViewDelegate: class {
    func mapBranch(_ view: MapBranchView, needsPerformAction action: MapBranchView.Action)
}

final class MapBranchView: UIView, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet weak var kolodaView: KolodaView!

    // MARK: - Properties
    enum Action {
        case remove
        case push(Int)
    }

    weak var delegate: MapBranchViewDelegate?
    var viewModel = MapBranchViewModel() {
        didSet {
            kolodaView.reloadData()
        }
    }

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    // MARK: - Private func
    private func configView() {
        kolodaView.delegate = self
        kolodaView.dataSource = self
    }

    // MARK: - IBActions
    @IBAction func removeButtonTouchUpInside(_ sender: UIButton) {
        removeFromSuperview()
        delegate?.mapBranch(self, needsPerformAction: .remove)
    }
}

// MARK: - KolodaView DataSource
extension MapBranchView: KolodaViewDataSource {
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let itemView: MapItemView = MapItemView.loadNib()
        itemView.frame = kolodaView.frame
        itemView.viewModel = viewModel.viewModelForItem(at: index)
        itemView.delegate = self
        return itemView
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return viewModel.numberOfItems()
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed.fast
    }
}

// MARK: - KolodaView Delegate
extension MapBranchView: KolodaViewDelegate {
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        removeFromSuperview()
        delegate?.mapBranch(self, needsPerformAction: .remove)
    }
}

// MARK: - MapItemView Delegate
extension MapBranchView: MapItemViewDelegate {
    func mapItem(_ view: MapItemView, needsPerformAction action: MapItemView.Action) {
        switch action {
        case .push(let id):
            delegate?.mapBranch(self, needsPerformAction: .push(id))
        case .cancel:
            break
        }
    }
}
