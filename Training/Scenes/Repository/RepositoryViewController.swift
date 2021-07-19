//
//  RepositoryViewController.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//

import UIKit
import Nuke

final class RepositoryViewController: UIViewController {
    struct Dependency {
        var getRepoUseCase: GetRepoUseCase = GetRepoDefaultUseCase()
    }
    
    @IBOutlet private var actorImageView: UIImageView! {
        didSet {
            actorImageView.layer.cornerRadius = actorImageView.frame.size.width * 0.5
        }
    }

    @IBOutlet private var eventBackgroundView: UIView! {
        didSet {
            eventBackgroundView.layer.cornerRadius = 3;
        }
    }
    @IBOutlet private var eventLabel: UILabel!
    @IBOutlet private var actorNameLabel: UILabel!
    @IBAction private func detailButtonTouchUpInside(_ sender: Any) {
        let viewController = UserViewController.instantiate(username: event.actor.login)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navigationViewController, animated: true)
    }

    @IBOutlet private var repoOwnerImageView: UIImageView! {
        didSet {
            repoOwnerImageView.layer.cornerRadius = repoOwnerImageView.frame.size.width * 0.5
        }
    }
    @IBOutlet private var repoNameLabel: UILabel!
    @IBOutlet private var repoDescriptionLabel: UILabel!
    
    @IBOutlet private var stargazersView: RepositoryCountView!
    @IBOutlet private var watchersView: RepositoryCountView!
    @IBOutlet private var forksView: RepositoryCountView!
    
    @IBOutlet private var privateView: RepositoryDataView!
    @IBOutlet private var languageView: RepositoryDataView!
    @IBOutlet private var issueView: RepositoryDataView!
    @IBOutlet private var dateView: RepositoryDataView!

    private let dependency: Dependency
    private let event: Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents()
    }
    
    // MARK: - Initializer

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private init(coder: NSCoder, dependency: Dependency, event: Event) {
        self.dependency = dependency
        self.event = event
        super.init(coder: coder)!
    }
}

// MARK: - Instantiate

extension RepositoryViewController {
    static func instantiate(dependency: Dependency = .init(), _ event: Event) -> Self {
        R.storyboard.repository().instantiateInitialViewController{ coder in
            Self(coder: coder, dependency: dependency, event: event)
        }!
    }
}

// MARK: - Private

private extension RepositoryViewController {
    func fetchEvents() {
        dependency.getRepoUseCase.perform(ownerRepo: event.repo.name) { [weak self] result in
            switch result {
            case .success(let repo):
                self?.updateRepository(repo: repo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateRepository(repo: Repo) {
        navigationItem.title = repo.fullName
        
        Nuke.loadImage(with: event.actor.avatarUrl, into: actorImageView)
        eventLabel.text = event.type
        actorNameLabel.text = event.actor.login
        
        Nuke.loadImage(with: repo.owner.avatarURL, into: repoOwnerImageView)
        repoNameLabel.text = repo.name
        repoDescriptionLabel.text = repo.description
        
        stargazersView.setInfo(type: .stargazers, count: repo.stargazersCount)
        watchersView.setInfo(type: .watchers, count: repo.watchersCount)
        forksView.setInfo(type: .forks, count: repo.forksCount)
        
        privateView.setInfo(type: .isPrivate(repo.isPrivate))
        languageView.setInfo(type: .language(repo.language))
        issueView.setInfo(type: .issue(repo.openIssuesCount))
        dateView.setInfo(type: .date(repo.updatedAt))
    }
}
