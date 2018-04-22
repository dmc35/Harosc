//
//  LoginViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 11/30/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

// Define
private struct Config {
    static let frameChange: CGFloat = 64
}

final class LoginViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var signInButton: UIButton!

    // MARK: - Properties
    private var viewModel = LoginViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        updateView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        var frame = view.frame
        frame.origin.y = Config.frameChange
        view.frame = frame

        view.endEditing(true)
    }

    // MARK: - Private
    private func textField(for field: LoginViewModel.Field) -> UITextField {
        switch field {
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        }
    }

    private func configView() {
        emailTextField.delegate = self
        passwordTextField.delegate = self

        view.backgroundColor = App.Color.backgroundColor
        navigationItem.title = viewModel.title
    }

    private func updateView() {
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
    }

    private func changeFrame(y: CGFloat) {
        var frame = view.frame
        frame.origin.y = y
        view.frame = frame
    }

    // MARK: - IBActions
    @IBAction func signInButtonTouchUpInside(_ sender: UIButton?) {
        viewModel.trimString(emailTextField.string, passwordTextField.string)
        let validate = viewModel.checkValidate()
        switch validate {
        case .success:
            viewModel.processLogin(completion: { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    AppDelegate.shared.changeRootView(vc: .home)
                case .failure(let msg):
                    this.changeFrame(y: Config.frameChange)
                    this.alert(msg: msg)
                }
            })
        case .failure(field: let field, msg: let msg):
            changeFrame(y: Config.frameChange)
            alert(title: App.String.kError, msg: msg, buttons: [App.String.kOk], handler: { [weak self]_ in
                guard let this = self else { return }
                let field = this.textField(for: field)
                field.becomeFirstResponder()
            })
        }
    }

    @IBAction func signUpButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        let registerVC = RegisterViewController()
        present(registerVC, animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            signInButtonTouchUpInside(nil)
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeFrame(y: 0)
    }
}
