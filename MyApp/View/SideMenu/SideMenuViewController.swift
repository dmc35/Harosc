//
//  SideMenuViewController.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/22/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import LGSideMenuController

final class SideMenuViewController: UIViewController, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var profileView: UIView!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var emailLabel: UILabel!

    // MARK: - Properties
    private var viewModel = SideMenuViewModel() {
        didSet {
            updateView()
        }
    }
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let mapVC = UINavigationController(rootViewController: MapViewController())
    private let profileVC = UINavigationController(rootViewController: ProfileViewController())
    private let profileEditVC = UINavigationController(rootViewController: ProfileEditViewController())

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configData()
        viewModel.fetchData()
        configView()
        configTableView()
        addGentureProfileView()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }

    // MARK: - Private
    private func configData() {
        viewModel.getProfileUser { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure:
                this.alert(title: App.String.kError, msg: App.String.kLoadError, buttons: [App.String.kOk], handler: nil)
            }
        }
    }

    private func configTableView() {
        let cellNib = UINib(nibName: App.String.SideMenuTableCell, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: App.String.SideMenuTableCell)

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func configView() {
        userImageView.corner = UIView.cornerView(view: userImageView)
        viewModel.delegate = self
    }

    private func addGentureProfileView() {
        let tapGenture = UITapGestureRecognizer(target: self, action: #selector(profileViewTouchUpInside))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGenture)
    }

    private func changeViewSideMenu(vc: UIViewController) {
        sideMenuController?.rootViewController = vc
        sideMenuController?.hideLeftViewAnimated()
    }

    func updateView() {
        userImageView.imageFromUrl(urlString: user.avatarUrl)
        nameLabel.text = user.name
        emailLabel.text = user.email
    }

    // MARK: - objc Private
    @objc private func profileViewTouchUpInside() {
        changeViewSideMenu(vc: profileEditVC)
    }

    // MARK: - IBActions
    @IBAction func logOutTouchUpInside(_ sender: UIButton) {
        viewModel.logOut()
    }
}

extension SideMenuViewController: ViewModelDelegate {
    func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], for changeType: ChangeType) {
        updateView()
    }
}

// MARK: - UITableView DataSource
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: App.String.SideMenuTableCell, for: indexPath) as? SideMenuTableCell else { fatalError(App.String.ErrorCell) }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? SideMenuCellViewModel
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

// MARK: - UITableView Delegate
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let munuVC = viewModel.menus[indexPath.row]
        let vc: UIViewController
        switch munuVC {
        case .home:
            vc = homeVC
        case .map:
            vc = mapVC
        case .profile:
            vc = profileVC
        case .compare:
            vc = profileVC
        }
        changeViewSideMenu(vc: vc)
    }
}
