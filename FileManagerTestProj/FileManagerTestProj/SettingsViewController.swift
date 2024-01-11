//
//  SettingsViewController.swift
//  FileManagerTestProj
//
//  Created by Максим Жуин on 10.01.2024.
//

import UIKit

final class SettingsViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    @objc func filterButtonTapped() {
//        let vc = ViewController()
//        let filteredArray = vc.itemsArray?.sorted()
//        vc.action?(filteredArray!)
    }


}
