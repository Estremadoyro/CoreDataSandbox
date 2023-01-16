//
//  HomeViewController.swift
//  CoreDataDemo
//
//  Created by Leonardo  on 15/01/23.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: State
    /// Reusable cell ID.
    private let cellId: String = "CELL_ID"

    /// # ViewModel
    private let viewModel = HomeViewModel()

    /// # UI
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        return table
    }()

    // MARK: Methods
}

// MARK: Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL_ID")

        // Get people from local
        getPeople()

        // Configure UI
        configureNavBar()
        configureView()
        viewModel.relationshipDemo()
    }
}

private extension HomeViewController {
    func getPeople() {
        viewModel.getPeople { [weak self] in
            self?.updateReload()
        }
    }
}

// MARK: Private methods
private extension HomeViewController {
    func configureNavBar() {
        navigationItem.title = "Table Core Data"
        let item = UIBarButtonItem(barButtonSystemItem: .add,
                                   target: self,
                                   action: #selector(addItem))
        navigationItem.rightBarButtonItems = [item]
    }

    @objc
    func addItem() {
        let alertComponent = AlertComponent(title: "Add Person",
                                            msg: "Enter their first name",
                                            style: .alert)
        alertComponent.addAction(.init(title: "Add", style: .default)) { [weak self] (_, inputValues) in
            guard let self = self else { return }
            let input: String = inputValues?.first ?? ""
            self.viewModel.addPerson(name: input, completion: self.updateInsertion)
        }
        alertComponent.addAction(.init(title: "Cancel", style: .destructive))
        
        alertComponent.addTextField()
        
        alertComponent.present(from: self)
    }

    func editPerson(_ person: Person, _ completion: @escaping () -> Void) {
        let alertComponent = AlertComponent(title: "Edit Person",
                                            msg: "Enter their new name:",
                                            style: .alert)
        
        alertComponent.addAction(.init(title: "Update", style: .default)) { [weak self] (_, inputValues) in
            guard let self = self else { return }
            let input: String = inputValues?.first ?? ""
            self.viewModel.updatePerson(person, newName: input) { completion() }
        }
        alertComponent.addAction(.init(title: "Cancel", style: .destructive))
        
        alertComponent.addTextField()
        alertComponent.alertController.textFields?[0].text = person.name // Previous value as placeholder
        
        alertComponent.present(from: self)
    }
}

private extension HomeViewController {
    func configureView() {
        layoutTableView()
    }

    func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UI update methods
private extension HomeViewController {
    func updateDeletion(at indexPath: IndexPath) {
        Task { @MainActor in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func updateInsertion() {
        let row = viewModel.people.count > 0 ? viewModel.people.count - 1 : 0
        let indexPath = IndexPath(row: row, section: 0)
        Task { @MainActor in
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    func updateReload() {
        Task { @MainActor in
            tableView.reloadData()
        }
    }

    func update(at indexPath: IndexPath) {
        Task { @MainActor in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = viewModel.people[indexPath.row]
        editPerson(person) { [weak self] in
            self?.update(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { completion(false); return }
            let person = self.viewModel.people[indexPath.row]
            self.viewModel.deletePerson(person) {
                self.updateDeletion(at: indexPath)
            }
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_ID") else {
            fatalError("Error dequeing cell")
        }

        let person = viewModel.people[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = person.name
        content.secondaryText = "\(person.age)"
        cell.contentConfiguration = content
        return cell
    }
}
