//
//  DetailViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/19/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

final class DetailViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var detailCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var detailTableView: UITableView!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var codeView: UIView!
    @IBOutlet fileprivate weak var codeLabel: UILabel!

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
                this.updateView()
            case .failure:
                this.alert(title: App.String.kError, msg: App.String.kLoadError, buttons: [App.String.kOk], handler: nil)
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
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }

    private func getListFavorite() {
        viewModel.getListFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.configRightBarButton()
            case .failure:
                this.alert(title: App.String.kError, msg: App.String.kLoadError, buttons: [App.String.kOk], handler: nil)
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

    private func updateView() {
        navigationItem.rightBarButtonItem?.tintColor = App.Color.extraColor
        codeLabel.text = viewModel.detailPromotion.code
        detailCollectionView.reloadData()
        detailTableView.reloadData()
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
                case .failure:
                    this.alert(title: App.String.kError, msg: App.String.kAddError, buttons: [App.String.kOk], handler: nil)
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
                case .failure:
                    this.alert(title: App.String.kError, msg: App.String.kDeleteError, buttons: [App.String.kOk], handler: nil)
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
        return viewModel.sizeForItemAt(collectionView)
    }
}

// MARK: - UITableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section, viewType: .table)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = viewModel.rows[indexPath.row]
        switch rowType {
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailContentCell, for: indexPath) as? DetailContentCell else { fatalError(App.String.ErrorCell) }
            cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailContentCellViewModel
            cell.selectionStyle = .none
            return cell
        case .map:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.DetailMapCell, for: indexPath) as? DetailMapCell else { fatalError(App.String.ErrorCell) }
            cell.viewModel = viewModel.viewModelForItem(at: indexPath, viewType: .table) as? DetailMapCellViewModel
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
}
