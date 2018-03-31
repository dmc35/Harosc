//
//  RegisterViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/5/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

private struct Config {
    static let scrollFrameChange: CGFloat = 130
}

final class RegisterViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var confirmTextField: UITextField!
    @IBOutlet fileprivate weak var verifyTextField: UITextField!
    @IBOutlet fileprivate weak var signUpButton: UIButton!

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
        verifyTextField.delegate = self

        navigationController?.isNavigationBarHidden = true
        signUpButton.isUserInteractionEnabled = false

        let tapGenture = UITapGestureRecognizer(target: self, action: #selector(tapGentures))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGenture)
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
        case .verify:
            return verifyTextField
        }
    }

    private func updateView() {
        nameTextField.text = viewModel.name
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
        confirmTextField.text = viewModel.confirm
    }

    // MARK: - objc Private
    @objc private func tapGentures() {
        view.endEditing(true)
        var heightSV = scrollView.contentSize.height
        heightSV = view.frame.height - Config.scrollFrameChange
        scrollView.contentSize.height = heightSV
    }

    // MARK: - IBActions
    @IBAction func verifyTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        var heightSV = scrollView.contentSize.height
        heightSV = view.frame.height - Config.scrollFrameChange
        scrollView.contentSize.height = heightSV
        viewModel.trimString(nameTextField.string,
                             emailTextField.string,
                             passwordTextField.string,
                             confirmTextField.string
        )
        let validate = viewModel.checkValidate()
        switch validate {
        case .success:
            verifyNumber = Int(arc4random_uniform(9_000) + 1_000)
            if let verifyNumber = verifyNumber {
                alert(title: App.String.kNofti, msg: App.String.kNoftiEmail, buttons: [App.String.kOk], handler: nil)
                print(verifyNumber)
            }
        case .failure(let field, let msg):
            alert(title: App.String.kError, msg: msg, buttons: [App.String.kOk], handler: { [weak self]_ in
                guard let this = self else { return }
                this.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                let field = this.textField(for: field)
                field.becomeFirstResponder()
            })
            viewDidUpdated()
        }
    }

    @IBAction func verifyTextFieldEditingChanged(_ sender: UITextField) {
        if sender.text == verifyNumber?.description {
            signUpButton.backgroundColor = App.Color.mainColor
            signUpButton.isUserInteractionEnabled = true
        } else {
            signUpButton.backgroundColor = App.Color.extraColor
            signUpButton.isUserInteractionEnabled = false
        }
    }

    @IBAction func signUpButtonTouchUpInside(_ sender: UIButton?) {
        view.endEditing(true)
        viewModel.processRegister(completion: { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.viewModel.processLogin(completion: { (result) in
                    switch result {
                    case .success:
                        AppDelegate.shared.changeRootView(vc: .home)
                    case .failure:
                        this.alert(title: App.String.kError, msg: App.String.kLoginError, buttons: [App.String.kOk], handler: nil)
                    }
                })
            case .failure:
                this.alert(title: App.String.kError, msg: App.String.kRegisterError, buttons: [App.String.kOk], handler: nil)
            }
            this.viewDidUpdated()
        })
    }

    @IBAction func signInButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var heightSV = scrollView.contentSize.height
        heightSV = view.frame.height + Config.scrollFrameChange
        scrollView.contentSize.height = heightSV
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmTextField.becomeFirstResponder()
        case confirmTextField:
            verifyTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
}
