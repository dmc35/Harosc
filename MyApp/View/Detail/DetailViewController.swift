//
//  DetailViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/19/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM
import SKPhotoBrowser

private struct Config {
    static let mapWidth = UIScreen.main.bounds.width
}

final class DetailViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var detailCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var detailTableView: UITableView!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var codeView: UIView!
    @IBOutlet fileprivate weak var codeLabel: UILabel!
    @IBOutlet fileprivate weak var commentTextView: UITextView!

    // MARK: - Properties
    var viewModel = DetailViewModel()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        configCollectionView()
        configTableView()
        configData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopMap"), object: nil)
        getListFavorite()
    }

    // MARK: - Private
    private func configData() {
        viewModel.getDataDetail { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.viewModel.getListFavorite({ (result) in
                    switch result {
                    case .success:
                        this.updateView()
                        this.configRightBarButton()
                    case .failure(let msg):
                        this.alert(msg: msg)
                    }
                })
            case .failure(let msg):
                this.alert(msg: msg)
            }
        }
    }

    private func configView() {
        title = viewModel.title
        codeView.corner = UIView.cornerView(view: codeView)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_leftBar"), style: .plain, target: self, action: #selector(backButtonTouchUpInside))
        navigationItem.leftBarButtonItem?.tintColor = App.Color.mainColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_unwish"), style: .plain, target: self, action: #selector(favoriteTouchUpInside))
        navigationItem.rightBarButtonItem?.tintColor = App.Color.extraColor
    }

    private func configCollectionView() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)

        let cellNib = UINib(nibName: App.String.DetailCollectionCell, bundle: Bundle.main)
        detailCollectionView.register(cellNib, forCellWithReuseIdentifier: App.String.DetailCollectionCell)
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
    }

    private func configTableView() {
        detailTableView.register(UINib(nibName: App.String.DetailContentCell, bundle: nil), forCellReuseIdentifier: App.String.DetailContentCell)
        detailTableView.register(UINib(nibName: App.String.DetailMapCell, bundle: nil), forCellReuseIdentifier: App.String.DetailMapCell)
        detailTableView.register(UINib(nibName: App.String.DetailImageCell, bundle: nil), forCellReuseIdentifier: App.String.DetailImageCell)
        detailTableView.register(UINib(nibName: App.String.DetailCommentCell, bundle: nil), forCellReuseIdentifier: App.String.DetailCommentCell)

        detailTableView.dataSource = self
        detailTableView.delegate = self
    }

    private func getListFavorite() {
        viewModel.getListFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.configRightBarButton()
            case .failure(let msg):
                this.alert(msg: msg)
            }
        }
    }

    private func configRightBarButton() {
        viewModel.checkFavorite()
        if viewModel.isFavorite {
            navigationItem.rightBarButtonItem?.tintColor = App.Color.mainColor
        } else {
            navigationItem.rightBarButtonItem?.tintColor = App.Color.extraColor
        }
    }

    private func showSKPhoto(photos: [SKPhoto]) {
        let photoBrowser = SKPhotoBrowser(photos: photos)
        present(photoBrowser, animated: true, completion: nil)
    }

    private func updateView() {
        navigationItem.rightBarButtonItem?.tintColor = App.Color.extraColor
        codeLabel.text = viewModel.detailPromotion.code
        detailCollectionView.reloadData()
        detailTableView.reloadData()
    }

    private func hiddenCommentView() {
        for row in 0..<viewModel.comments.count {
            let indexPath = IndexPath(row: row, section: 1)
            guard let cell = detailTableView.cellForRow(at: indexPath) as? DetailCommentCell else { return }
            cell.hiddenCommentView()
        }
    }

    // MARK: - objc Private
    @objc private func backButtonTouchUpInside() {
        sideMenuController?.leftViewController = SideMenuViewController()
        navigationController?.popViewController(animated: true)
    }

    @objc private func favoriteTouchUpInside() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        if !viewModel.isFavorite {
            viewModel.addOneFavorite { [weak self](result) in
                guard let this = self else { return }
                this.navigationItem.rightBarButtonItem?.isEnabled = true
                switch result {
                case .success:
                    this.viewModel.isFavorite = true
                    this.navigationItem.rightBarButtonItem?.tintColor = App.Color.mainColor
                case .failure(let msg):
                    this.alert(msg: msg)
                }
            }
        } else {
            viewModel.deleteOneFavorite { [weak self](result) in
                guard let this = self else { return }
                this.navigationItem.rightBarButtonItem?.isEnabled = true
                switch result {
                case .success:
                    this.viewModel.isFavorite = false
                    this.navigationItem.rightBarButtonItem?.tintColor = App.Color.extraColor
                case .failure(let msg):
                    this.alert(msg: msg)
                }
            }
        }
    }

    @objc private func scrollToNextCell() {
        let cellSize = CGSize(width: detailCollectionView.frame.width, height: detailCollectionView.frame.height)
        let contentOffset = detailCollectionView.contentOffset
        if detailCollectionView.contentSize.width <= contentOffset.x + cellSize.width {
            detailCollectionView.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
        } else {
            detailCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }

    // MARK: - IBActions
    @IBAction func sendCommentTouchUpInside(_ sender: UIButton) {
        commentTextView.resignFirstResponder()
        viewModel.contentText = commentTextView.text
        Hud.show()
        viewModel.sendComment { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.viewModel.getDataDetail({ (result) in
                    switch result {
                    case .success:
                        this.commentTextView.text = ""
                        this.alert(title: "Thành công", msg: "Bình luận thành công", buttons: [App.String.kOk], handler: nil)
                        this.updateView()
                    case .failure(let msg):
                        this.alert(msg: msg)
                    }
                })
            case .failure(let msg):
                this.alert(msg: msg)
                this.commentTextView.becomeFirstResponder()
            }
            Hud.dismiss()
        }
    }

    @IBAction func cancelTouchUpInside(_ sender: UIButton) {
        hiddenCommentView()
        commentTextView.text = ""
        commentTextView.resignFirstResponder()
        viewModel.contentText = ""
        viewModel.isUpgrade = false
    }
}

// MARK: - UICollectionView DataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.numberOfItems(inSection: section, viewType: .collection)
        pageControl.numberOfPages = numberOfItems
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: App.String.DetailCollectionCell, for: indexPath) as? DetailCollectionCell else { fatalError(App.String.ErrorCell) }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .collection) as? DetailCollectionCellViewModel
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UITableView DataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section, viewType: .table)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .other:
            let rowType = viewModel.rows[indexPath.row]
            switch rowType {
            case .content:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailContentCell, for: indexPath) as? DetailContentCell else { fatalError(App.String.ErrorCell) }
                cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailContentCellViewModel
                cell.selectionStyle = .none
                return cell
            case .image:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailImageCell, for: indexPath) as? DetailImageCell else { fatalError(App.String.ErrorCell) }
                cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailImageCellViewModel
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            case .map:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailMapCell, for: indexPath) as? DetailMapCell else { fatalError(App.String.ErrorCell) }
                cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailMapCellViewModel
                cell.selectionStyle = .none
                return cell
            }
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailCommentCell, for: indexPath) as? DetailCommentCell else { fatalError(App.String.ErrorCell) }
            cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailCommentCellViewModel
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hiddenCommentView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .other:
            let rowType = viewModel.rows[indexPath.row]
            switch rowType {
            case .map:
                return 2 * Config.mapWidth / 3
            default:
                return UITableViewAutomaticDimension
            }
        case .comment:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - DetailImageCell Delegate
extension DetailViewController: DetailImageCellDelegate {
    func detailImage(_ view: DetailImageCell, needsPerformType type: DetailImageCell.ImageType) {
        switch type {
        case .launch:
            let photos = viewModel.getPhotoBrowser(type: .launch)
            showSKPhoto(photos: photos)
        case .menu:
            let photos = viewModel.getPhotoBrowser(type: .menu)
            showSKPhoto(photos: photos)
        }
    }
}

// MARK: - DetailCommentCell Delegate
extension DetailViewController: DetailCommentCellDelegate {
    func editComment(_ view: DetailCommentCell, needsPerformAction action: DetailCommentCell.Action) {
        switch action {
        case .fix(let id, let userId):
            viewModel.checkComment(id: id, userId: userId, completion: { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.commentTextView.text = this.viewModel.contentText
                    this.commentTextView.becomeFirstResponder()
                case .failure(let msg):
                    this.alert(msg: msg)
                }
            })
        case .delete(let id, let userId):
            Hud.show()
            viewModel.deleteComment(commentId: id, userId: userId, { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.viewModel.getDataDetail({ (result) in
                        switch result {
                        case .success:
                            this.alert(title: "Thành công", msg: "Xoá bình luận thành công", buttons: [App.String.kOk], handler: nil)
                            this.updateView()
                        case .failure(let msg):
                            this.alert(msg: msg)
                        }
                    })
                case .failure(let msg):
                    this.alert(msg: msg)
                }
            })
            Hud.dismiss()
        }
    }
}
