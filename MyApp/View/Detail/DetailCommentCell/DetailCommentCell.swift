//
//  DetailCommentCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/16/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol DetailCommentCellDelegate: class {
    func editComment(_ view: DetailCommentCell, needsPerformAction action: DetailCommentCell.Action)
}

final class DetailCommentCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var avartarImage: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var timeAgoLabel: UILabel!
    @IBOutlet fileprivate weak var contentLabel: UILabel!
    @IBOutlet fileprivate weak var editCommentView: UIView!

    // MARK: - Properties
    enum Action {
        case fix(id: Int, userId: Int)
        case delete(id: Int, userId: Int)
    }

    weak var delegate: DetailCommentCellDelegate?
    var viewModel: DetailCommentCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        configView()
    }

    // MARK: - Private func
    private func configView() {
        avartarImage.corner = UIView.cornerView(view: avartarImage)
    }

    // MARK: - Public func
    func updateView() {
        guard let viewModel = viewModel else { return }
        avartarImage.image = nil
        let imageUrl = viewModel.imageUrl
        avartarImage.setImage(with: imageUrl)
        nameLabel.text = viewModel.name
        timeAgoLabel.text = viewModel.calculateTimeAgo(dateString: viewModel.date)
        contentLabel.text = viewModel.content
    }

    func hiddenCommentView() {
        editCommentView.isHidden = true
    }

    // MARK: - IBActions
    @IBAction func editCommentTouchUpInside(_ sender: UIButton) {
        editCommentView.isHidden = false
    }

    @IBAction func fixCommentTouchUpInside(_ sender: UIButton) {
        hiddenCommentView()
        guard let viewModel = viewModel else { return }
        delegate?.editComment(self, needsPerformAction: .fix(id: viewModel.id, userId: viewModel.userId))
    }

    @IBAction func deleteCommentTouchUpInside(_ sender: UIButton) {
        hiddenCommentView()
        guard let viewModel = viewModel else { return }
        delegate?.editComment(self, needsPerformAction: .delete(id: viewModel.id, userId: viewModel.userId))
    }
}
