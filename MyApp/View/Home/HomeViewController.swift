//
//  HomeViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 11/29/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

private struct Config {
    static let heightCell: CGFloat = 237.5
}

final class HomeViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var homeCollectionView: UICollectionView!

    // MARK: - Properties
    private var viewModel = HomeViewModel()
    private var refreshControl = UIRefreshControl()
    private var footerView: FooterCollection?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configCollectionView()
        configData()
        viewModel.delegate = self
        configRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Private
    private func configNavigation() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_search"), style: .plain, target: self, action: #selector(pushToSearchView))
        configBarColor()
    }

    private func configCollectionView() {
        let cellNib = UINib(nibName: App.String.HomeCollectionCell, bundle: Bundle.main)
        homeCollectionView.register(cellNib, forCellWithReuseIdentifier: App.String.HomeCollectionCell)
        let footerNib = UINib(nibName: App.String.FooterCollection, bundle: nil)
        homeCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: App.String.FooterCollection)
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }

    private func configData() {
        Hud.show()
        viewModel.getListPromotion { [weak self](result) in
            Hud.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.homeCollectionView.reloadData()
            case .failure(let msg):
                this.alert(msg: msg)
            }
        }
    }

    private func configRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        homeCollectionView.addSubview(refreshControl)
    }

    private func updateView() {
        homeCollectionView.reloadData()
    }

    private func pushToDetailView(id: Int) {
        let vc = DetailViewController()
        vc.viewModel.id = id
        sideMenuController?.leftViewController = nil
        navigationController?.pushViewController(vc, animated: true)
    }

    private func loadMoreData() {
        guard let footerView = footerView else { return }
        if footerView.isAnimatingFinal {
            viewModel.isLoading = true
            footerView.startAnimate()
            viewModel.loadMoreData { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.homeCollectionView.reloadData()
                    this.viewModel.isLoading = false
                case .failure:
                    this.viewModel.isLoading = false
                }
            }
        }
    }

    // MARK: - objc Private
    @objc private func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    @objc private func pushToSearchView() {
        let vc = SearchViewController()
        sideMenuController?.leftViewController = nil
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func refreshData() {
        if viewModel.datas.count > 10 {
            viewModel.refreshData { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.homeCollectionView.reloadData()
                case .failure:
                    break
                }
            }
        }
        refreshControl.endRefreshing()
    }
}

// MARK: - ViewModelwDelegate
extension HomeViewController: ViewModelDelegate {
    func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], for changeType: ChangeType) {
        updateView()
    }
}

// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: App.String.HomeCollectionCell, for: indexPath) as? HomeCollectionCell else { fatalError(App.String.ErrorCell) }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? HomeCollectionCellViewModel
        UIView.shadowView(view: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.datas[indexPath.row].id
        pushToDetailView(id: id)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: App.String.FooterCollection, for: indexPath) as? FooterCollection else {
            fatalError(App.String.ErrorCell)
        }
        footerView = footer
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            footerView?.prepareInitialAnimation()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            footerView?.stopAnimate()
        }
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: Config.heightCell)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 25)
    }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold = Float((diffHeight - frameHeight)) / Float(threshold)
        triggerThreshold = min(triggerThreshold, 0.0)
        let pullRatio = min(fabs(triggerThreshold), 1.0)
        footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            footerView?.animateFinal()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight = fabs(diffHeight - frameHeight)
        if pullHeight >= 0.0 {
            loadMoreData()
        }
    }
}
