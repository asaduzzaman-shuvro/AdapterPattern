//
//  AddUserViewController.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import UIKit

class AddOrEditUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var user: User? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user {
            nameTextField.text = user.name
            emailTextField.text = user.email
        }
    }
    
    @IBAction func createUserButtonTapped(_ sender: Any) {
        guard 
            let name = nameTextField.text?.trim(),
            let email = emailTextField.text?.trim()
        else { return }
        
        if let user = self.user {
            CoreDataManager.shared.updateUser(with: name, email: email, userId: user.userId ?? "", isActive: true)
        } else {
            CoreDataManager.shared.createUser(name: name, email: email)
        }
        navigationController?.popViewController(animated: true)
    }
}


