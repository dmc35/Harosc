//
//  ProfileViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/13/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

final class ProfileViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var emailLabel: UILabel!
    @IBOutlet fileprivate weak var birthLabel: UILabel!
    @IBOutlet fileprivate weak var editButton: UIButton!
    @IBOutlet fileprivate weak var profileCollectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = ProfileViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        configCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configData()
        updateView()
    }

    // MARK: - Private
    private func configData() {
        viewModel.getListFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.profileCollectionView.reloadData()
            case .failure:
                this.alert(title: App.String.kError, msg: App.String.kLoadError, buttons: [App.String.kOk], handler: nil)
            }
        }
    }

    private func configView() {
        viewModel.delegate = self
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_bin"), style: .plain, target: self, action: #selector(deleteAllFavorite))
        configBarColor()
        avatarImageView.corner = UIView.cornerView(view: avatarImageView)
    }

    private func configCollectionView() {
        profileCollectionView.register(UINib(nibName: App.String.ProfileCollectionCell, bundle: nil), forCellWithReuseIdentifier: App.String.ProfileCollectionCell)
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
    }

    private func pushToDetailView(id: Int) {
        let vc = DetailViewController()
        vc.viewModel.id = id
        navigationController?.pushViewController(vc, animated: true)
    }

    private func createAlert(type: ProfileViewModel.AlertRemove, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: type.title, message: type.msg, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Có", style: .default, handler: handler)
        let noAction = UIAlertAction(title: "Không", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }

    private func deleteOneFavorite(_ id: Int) {
        createAlert(type: .one, handler: { [weak self] _ in
            guard let this = self else { return }
            this.viewModel.id = id
            this.viewModel.deleteOneFavorite { (result) in
                switch result {
                case .success:
                    this.profileCollectionView.reloadData()
                case .failure:
                    this.alert(title: App.String.kError, msg: App.String.kDeleteError, buttons: [App.String.kOk], handler: nil)
                }
            }
        })
    }

    private func updateView() {
        avatarImageView.image = nil
        avatarImageView.setImage(with: user.avatarUrl, placeholder: #imageLiteral(resourceName: "im_user"))
        nameLabel.text = user.name
        emailLabel.text = user.email
        birthLabel.text = user.birthday
    }

    // MARK: - objc Private
    @objc private func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    @objc private func deleteAllFavorite() {
        createAlert(type: .all, handler: { [weak self] _ in
            guard let this = self else { return }
            this.viewModel.deleteListFavorite { (result) in
                switch result {
                case .success:
                    this.profileCollectionView.reloadData()
                case .failure:
                    this.alert(title: App.String.kError, msg: App.String.kDeleteError, buttons: [App.String.kOk], handler: nil)
                }
            }
        })
    }

    // MARK: - IBAction
    @IBAction func editButtonTouchUpInside(_ sender: UIButton) {
        let profileEditVC = UINavigationController(rootViewController: ProfileEditViewController())
        sideMenuController?.rootViewController = profileEditVC
    }
}

// MARK: - ViewModel Delegate
extension ProfileViewController: ViewModelDelegate {
    func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], for changeType: ChangeType) {
        updateView()
    }
}

// MARK: - UICollectionView DataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: App.String.ProfileCollectionCell, for: indexPath) as? ProfileCollectionCell else { fatalError(App.String.ErrorCell) }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? ProfileCollectionCellViewModel
        UIView.shadowView(view: cell)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.listFavorites[indexPath.row].id
        pushToDetailView(id: id)
    }
}

// MARK: - UIColletionView Delegate FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(collectionView, indexPath: indexPath)
    }
}

// MARK: - ProfileCollectionCell Delegate
extension ProfileViewController: ProfileCollectionCellDelegate {
    func profileCollection(_ view: ProfileCollectionCell, needsPerformAction action: ProfileCollectionCell.Action) {
        switch action {
        case .success(let id):
            deleteOneFavorite(id)
        case .failure:
            break
        }
    }
}
