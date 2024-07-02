//
//  UsersViewController.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import UIKit
import MagicalRecord

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRightBarButton()
        setupTableView()
        
        fetchResultController = CoreDataManager.shared.userFetchController(delegate: self)
    }
}

extension UsersViewController {
    private func setRightBarButton() {
        let barButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didPressOnAddBarButton(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func didPressOnAddBarButton(sender: Any) {
        navigateToAddOrEditVC(with: nil)
    }
    
    private func navigateToAddOrEditVC(with user: User?) {
        let vc = AddOrEditUserViewController.fromNib()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
        tableView.tableFooterView = UIView()
    }
    
    private func getUserFor(indexPath: IndexPath) -> User? {
        if let sections = fetchResultController?.sections {
            let section = sections[indexPath.section]
            let user = section.objects?[indexPath.row] as? User
            return user
        }
        return nil
    }
    
    private func configure(
        cell: UITableViewCell,
        at indexPath: IndexPath
    ) {
        if let user = getUserFor(indexPath: indexPath) {
            cell.textLabel?.text =  "\(user.name ?? "") with products of \(user.products?.count ?? 0)"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController?.sections {
            return sections[section].numberOfObjects
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let user = getUserFor(indexPath: indexPath)
        navigateToAddOrEditVC(with: user)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension UsersViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) {
                    configure(cell: cell, at: indexPath)
                }
            }
        @unknown default:
            print("Unknown error")
        }
        
    }
}
