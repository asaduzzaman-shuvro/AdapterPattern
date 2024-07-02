//
//  AddUserViewController.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let users = CoreDataManager.shared.getUsers()
        print(users)
    }
    
    @IBAction func createUserButtonTapped(_ sender: Any) {
        guard 
            let user = nameTextField.text?.trim(),
            let email = emailTextField.text?.trim()
        else { return }
        CoreDataManager.shared.createUser(name: user, email: email)
        navigationController?.popViewController(animated: true)
    }
}


