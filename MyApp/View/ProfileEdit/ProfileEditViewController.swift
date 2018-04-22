//
//  ProfileEditViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/8/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM
import SwiftUtils
import Alamofire

final class ProfileEditViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var profileEditTableView: UITableView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var datePickerView: UIView!

    // MARK: - Properties
    var viewModel = ProfileEditViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUser()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Private
    private func configView() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list"), style: .plain, target: self, action: #selector(showSideMenu))
        configBarColor()

        avatarImageView.corner = UIView.cornerView(view: avatarImageView)
        avatarImageView.image = nil
        avatarImageView.setImage(with: user.avatarUrl, placeholder: #imageLiteral(resourceName: "im_user"))
        nameTextField.text = user.name
        emailTextField.text = user.email
    }

    private func configTableView() {
        profileEditTableView.register(ProfileEditFieldCell.self)
        profileEditTableView.register(ProfileEditButtonCell.self)
        profileEditTableView.dataSource = self
        profileEditTableView.delegate = self
    }

    // MARK: - objc Private
    @objc private func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    // MARK: - IBActions
    @IBAction func changeAvatarTouchUpInside(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        if let text = nameTextField.text {
            viewModel.fieldEditingChanged(text: text)
        }
    }

    @IBAction func saveChangesTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        let validate = viewModel.checkValidate()
        switch validate {
        case .success:
            Hud.show()
            viewModel.updateProfile { [weak self](result) in
                Hud.dismiss()
                guard let this = self else { return }
                switch result {
                case .success:
                    this.viewModel.isEditingChanged = false
                case .failure(let msg):
                    this.alert(msg: msg)
                }
            }
        case .failure(let msg):
            alert(msg: msg)
        }
    }
}

// MARK: - UITableView DataSource
extension ProfileEditViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = viewModel.sectionTypes[indexPath.section]
        switch sectionType {
        case .field:
            let cell = tableView.dequeue(ProfileEditFieldCell.self)
            cell.viewModel = viewModel.viewModelForItem(at: indexPath) as? ProfileEditFieldCellViewModel
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = self
            return cell
        case .button:
            let cell = tableView.dequeue(ProfileEditButtonCell.self)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension ProfileEditViewController: UITableViewDelegate {
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: JSObject) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarImageView.image = image
        viewModel.avatarChanged(imageChoose: image)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditViewController: ProfileEditFieldCellDelegate {
    func editFieldCell(_ view: ProfileEditFieldCell, needsPerformAction action: ProfileEditFieldCell.Action, fieldType: ProfileEditViewModel.FieldType) {
        switch action {
        case .endEdit(let text):
            guard let text = text else { return }
            viewModel.fieldEditingChanged(fieldType: fieldType, text: text)
        case .cancel:
            break
        }
    }
}
