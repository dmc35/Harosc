//
//  RegisterViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/5/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

final class RegisterViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var confirmTextField: UITextField!

    // MARK: - Properties
    private var viewModel = RegisterViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        updateView()
    }

    // MARK: - Private
    private func configView() {
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self

        navigationController?.isNavigationBarHidden = true
    }

    private func textField(for field: RegisterViewModel.Field) -> UITextField {
        switch field {
        case .email:
            return emailTextField
        case .username:
            return nameTextField
        case .password:
            return passwordTextField
        case .confirm:
            return confirmTextField
        }
    }

    private func updateView() {
        nameTextField.text = viewModel.name
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
        confirmTextField.text = viewModel.confirm
    }

    // MARK: - IBActions
    @IBAction func signUpButtonTouchUpInside(_ sender: UIButton?) {
        view.endEditing(true)
        viewModel.trimString(nameTextField.string,
                             emailTextField.string,
                             passwordTextField.string,
                             confirmTextField.string
        )
        let validate = viewModel.checkValidate()
        switch validate {
        case .success:
            viewModel.processRegister(completion: { [weak self] (result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    this.viewModel.processLogin(completion: { (result) in
                        switch result {
                        case .success:
                            AppDelegate.shared.changeRootView(vc: .home)
                        case .failure(let msg):
                            this.alert(msg: msg)
                        }
                    })
                case .failure(let msg):
                    this.alert(msg: msg)
                }
                this.viewDidUpdated()
            })
        case .failure(let field, let msg):
            alert(title: App.String.kError, msg: msg, buttons: [App.String.kOk], handler: { [weak self]_ in
                guard let this = self else { return }
                let field = this.textField(for: field)
                field.becomeFirstResponder()
            })
            viewDidUpdated()
        }
    }

    @IBAction func signInButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmTextField.becomeFirstResponder()
        case confirmTextField:
            signUpButtonTouchUpInside(nil)
        default:
            break
        }
        return true
    }
}
