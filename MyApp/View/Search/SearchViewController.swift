//
//  SearchViewController.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/6/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class SearchViewController: UIViewController, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var searchCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var notificationLabel: UILabel!

    // MARK: - Properties
    private let viewModel = SearchViewModel()
    private var refreshControl = UIRefreshControl()
    private var loadMoreIndicatorView: UIActivityIndicatorView?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sideMenuController?.leftViewController = nil
        configView()
        configCollectionView()
        searchBar.delegate = self
    }

    // MARK: - Private
    private func configView() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
    }

    private func configCollectionView() {
        let cellNib = UINib(nibName: App.String.HomeCollectionCell, bundle: Bundle.main)
        searchCollectionView.register(cellNib, forCellWithReuseIdentifier: App.String.HomeCollectionCell)
        searchCollectionView.register(footer: UICollectionViewCell.self)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
    }

    private func pushToDetailView(id: Int) {
        let vc = DetailViewController()
        vc.viewModel.id = id
        navigationController?.pushViewController(vc, animated: true)
    }

    private func loadMoreData() {
        loadMoreIndicatorView?.startAnimating()
        viewModel.loadMoreData { [weak self](result) in
            guard let this = self else { return }
            this.loadMoreIndicatorView?.stopAnimating()
            switch result {
            case .success:
                this.searchCollectionView.reloadData()
            case .empty:
                break
            }
        }
    }

    private func configRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        searchCollectionView.addSubview(refreshControl)
    }

// MARK: - objc Private
    @objc private func requestServer(keyword: String) {
        viewModel.keyword = keyword
        viewModel.searchData { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.notificationLabel.isHidden = true
            case .empty:
                this.notificationLabel.isHidden = false
            }
            this.searchCollectionView.reloadData()
        }
    }

    @objc func refreshData() {
        if viewModel.datas.count > 10 {
            viewModel.currentPage = 0
            requestServer(keyword: viewModel.keyword)
            searchCollectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }

// MARK: - IBActions
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        sideMenuController?.leftViewController = SideMenuViewController()
    }
}

// MARK: - UICollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
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
        let footer = collectionView.dequeue(footer: UICollectionViewCell.self, forIndexPath: indexPath)
        let indicatorView = UIActivityIndicatorView()
        indicatorView.frame = footer.bounds
        indicatorView.hidesWhenStopped = true
        indicatorView.color = App.Color.extraColor
        loadMoreIndicatorView = indicatorView
        footer.addSubview(indicatorView)
        return footer
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 20)
    }
}

// MARK: - UICollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        if distanceFromBottom <= height {
            loadMoreData()
        }
    }
}

// MARK: - UISearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        perform(#selector(requestServer(keyword:)), with: searchText, afterDelay: 0.25)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
