//
//  LoginViewController.swift
//  FileManagerTestProj
//
//  Created by Максим Жуин on 09.01.2024.
//

import UIKit
import KeychainAccess

enum State: String {
    case haveSavedPassword
    case doesntSavePassword
}


final class LoginViewController: UIViewController {

    private var keyChain: Keychain = Keychain()

    private var state: State

    private var savedPass: String?

    private lazy var infoText: UILabel = {
        let infoText = UILabel()
        infoText.font = UIFont.boldSystemFont(ofSize: 13)
        infoText.translatesAutoresizingMaskIntoConstraints = false
        return infoText
    }()

    private lazy var passTextField: UITextField = {
        let passTextField = UITextField()
        passTextField.borderStyle = .roundedRect
        passTextField.delegate = self
        passTextField.placeholder = "Enter Password"
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        return passTextField
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("LogIn", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8.0
        loginButton.backgroundColor = .systemBlue
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
        view.backgroundColor = .systemBackground
        checkButton()
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(passTextField)
        view.addSubview(loginButton)
        view.addSubview(infoText)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([

            infoText.bottomAnchor.constraint(equalTo: passTextField.topAnchor, constant: -15),
            infoText.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            infoText.heightAnchor.constraint(equalToConstant: 44),

            passTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            passTextField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.widthAnchor.constraint(equalToConstant: 180)
        ])
    }

    private func cleanView() {
        infoText.text = ""
        passTextField.layer.borderColor = UIColor(named: "black")?.cgColor
    }

    private func createNavigation() -> [UINavigationController] {
        
        let fileService = FilemanagerService()
        let documentsVC = ViewController(fileService: fileService)
        let documentsNavigationVC = UINavigationController(rootViewController: documentsVC)
        documentsNavigationVC.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "doc.on.doc"), tag: 0)


        let settingsVC = SettingsViewController()
        let settingsNavigationVC = UINavigationController(rootViewController: settingsVC)
        settingsNavigationVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        return [documentsNavigationVC, settingsNavigationVC]
    }

    private func moveToTabBar() {
        let mainTabBarController = UITabBarController()
        mainTabBarController.viewControllers = createNavigation()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

    private func validate(pass: String) -> Bool {
        let minimumNumberOfChar = 4
        if pass.count < minimumNumberOfChar {
            passTextField.layer.borderColor = UIColor.red.cgColor
            infoText.text = "Минимальное кол-во символов: 4"
            return false
        }
        savedPass = pass
        return true
    }

    private func checkButton() {
        switch state {
        case .haveSavedPassword:
            loginButton.setTitle("Введите пароль", for: .normal)
        case .doesntSavePassword:
            loginButton.setTitle("Создать пароль", for: .normal)
        }
    }

    @objc func loginButtonTapped() {
        switch state {
        case .haveSavedPassword:
            let token = keyChain["newUser"]
            if validate(pass: passTextField.text!) && passTextField.text == token {
                moveToTabBar()
            }
        case .doesntSavePassword:
            if validate(pass: passTextField.text!) {
                cleanView()
                loginButton.setTitle("Повторите пароль", for: .normal)

                if savedPass == passTextField.text && validate(pass: passTextField.text!) {
                    keyChain["newUser"] = passTextField.text!
                    state = .haveSavedPassword
                    UserDefaults.standard.set(state.rawValue, forKey: "state")
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


