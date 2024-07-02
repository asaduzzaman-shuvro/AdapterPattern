//
//  UsersViewController.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import UIKit

class UsersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRightBarButton()
    }
}

extension UsersViewController {
    private func setRightBarButton() {
        let barButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didPressOnAddBarButton(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func didPressOnAddBarButton(sender: Any) {
        let vc = AddUserViewController.fromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

