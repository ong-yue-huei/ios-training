//
//  UserViewController.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import UIKit
import Combine

final class UserViewController: UIViewController{
    struct Dependency {
        var getUserUseCase: GetUserUseCase = GetUserDefaultUseCase()
        var getUserReposUseCase: GetUserReposUseCase = GetUserReposDefaultUseCase()
    }
    
    private enum Const {
        static let sectionIdentifier = "repos"
    }
    
    private typealias TableViewDataSource = UITableViewDiffableDataSource<String, Repo>
    private typealias TableViewSnapShot = NSDiffableDataSourceSnapshot<String, Repo>
    
    @IBOutlet var userTableHeaderView: UserTableHeaderView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.userRepoTableViewCell)
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    private lazy var dataSource = TableViewDataSource(tableView: tableView) { tableView, indexPath, element in
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userRepoTableViewCell, for: indexPath)!
        cell.userRepo(element)
        return cell
    }
    
    private let dependency: Dependency
    private let username: String
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(username)'s Repository List"
        fetchUserAndUserRepos()
    }
    
    // MARK: - Initializer

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private init(coder: NSCoder, dependency: Dependency, username: String) {
        self.dependency = dependency
        self.username = username
        super.init(coder: coder)!
    }
}

// MARK: - Instantiate

extension UserViewController {
    static func instantiate(dependency: Dependency = .init(), username: String) -> Self {
        R.storyboard.user().instantiateInitialViewController { coder in
            Self(coder: coder, dependency: dependency, username: username)
        }!
    }
}

// MARK: - Private

private extension UserViewController {
    func fetchUserAndUserRepos() {
        dependency.getUserUseCase.perform(username: username)
            .zip(dependency.getUserReposUseCase.perform(username: username))
            .sink(receiveCompletion: { completion in
                switch completion{
                    case .failure(let error):
                        print(error)
                    case .finished:
                        print("Success")
                }
            }, receiveValue: { [weak self] result in
                self?.userTableHeaderView.setUser(result.0)
                self?.updateTableViewDataSet(repos: result.1)
            })
            .store(in: &cancellables)
    }
    
    func updateTableViewDataSet(repos: [Repo]) {
        var snapshot = TableViewSnapShot()
        snapshot.appendSections([Const.sectionIdentifier])
        snapshot.appendItems(repos, toSection: Const.sectionIdentifier)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
