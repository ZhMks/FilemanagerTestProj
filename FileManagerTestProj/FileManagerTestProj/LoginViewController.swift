//
//  LoginViewController.swift
//  FileManagerTestProj
//
//  Created by Максим Жуин on 09.01.2024.
//

import UIKit
import FDKeychain

final class LoginViewController: UIViewController {

    enum State {
        case haveSavedPassword
        case doesntSavePassword
    }

   private var state: State

    private lazy var passTextField: UITextField = {
        let passTextField = UITextField()
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        return passTextField
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("LogIn", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()

    init(state: State) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(passTextField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            passTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            loginButton.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
