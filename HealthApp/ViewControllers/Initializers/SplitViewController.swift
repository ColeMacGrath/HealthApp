//
//  SplitViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import UIKit


class SplitViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create the split view controller
        let splitViewController = UISplitViewController(style: .tripleColumn)
        splitViewController.preferredDisplayMode = .twoBesideSecondary
        
        // Set up the view controllers
        let primaryViewController = PrimaryTableViewController()
        let secondaryViewController = SecondaryViewController()
        let supplementaryViewController = SupplementaryViewController()
        
        splitViewController.setViewController(primaryViewController, for: .primary)
        splitViewController.setViewController(secondaryViewController, for: .secondary)
        splitViewController.setViewController(supplementaryViewController, for: .supplementary)
        splitViewController.modalPresentationStyle = .fullScreen
        self.present(splitViewController, animated: false)
    }
}

class SecondaryViewController: UIViewController {
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showLabel(withText text: String) {
        label.text = text
    }
}

class SupplementaryViewController: UITableViewController {
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectionHandler: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctors"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler?(indexPath.row + 1)
        guard  let splitViewController = splitViewController,
               let secondaryViewController = splitViewController.viewController(for: .secondary) as? SecondaryViewController else { return }
        splitViewController.hide(.primary)
        secondaryViewController.showLabel(withText: "Secondary Row \(indexPath.row + 1)")
        
    }
}
