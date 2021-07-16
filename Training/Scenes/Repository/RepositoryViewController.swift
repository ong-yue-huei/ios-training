//
//  RepositoryViewController.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//

import UIKit
import Nuke
import Combine

final class RepositoryViewController: UIViewController {
    struct Dependency {
        var getRepoUseCase: GetRepoUseCase = GetRepoDefaultUseCase()
    }
    
    @IBOutlet private var actorImage: UIImageView! {
        didSet {
            actorImage.layer.cornerRadius = actorImage.frame.size.width * 0.5
        }
    }
    @IBOutlet private var eventBackground: UIView! {
        didSet {
            eventBackground.layer.cornerRadius = 3;
        }
    }
    @IBOutlet private var eventLabel: UILabel!
    @IBOutlet private var actorName: UILabel!
    @IBAction private func detailButtonTouchUpInside(_ sender: Any) {
        let viewController = UserViewController.instantiate(username: event.actor.login)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navigationViewController, animated: true)
    }
    
    @IBOutlet private var repoOwnerImage: UIImageView! {
        didSet {
            repoOwnerImage.layer.cornerRadius = repoOwnerImage.frame.size.width * 0.5
        }
    }
    @IBOutlet private var repoName: UILabel!
    @IBOutlet private var repoDescription: UILabel!
    
    @IBOutlet private var stargazersView: RepositoryCountView!
    @IBOutlet private var watchersView: RepositoryCountView!
    @IBOutlet private var forksView: RepositoryCountView!
    
    @IBOutlet private var privateView: RepositoryOtherView!
    @IBOutlet private var languageView: RepositoryOtherView!
    @IBOutlet private var issueView: RepositoryOtherView!
    @IBOutlet private var dateView: RepositoryOtherView!

    private let dependency: Dependency
    private let event: Event
    private var cancellables: Set<AnyCancellable> = []
    
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
        dependency.getRepoUseCase.perform(ownerRepo: event.repo.name)
            .sink(receiveCompletion: { completion in
                switch completion{
                    case .failure(let error):
                        print(error)
                    case .finished:
                        print("Success")
                }
            }, receiveValue: { [weak self] result in
                self?.updateRepository(repo: result)
            })
            .store(in: &cancellables)
    }
    
    func updateRepository(repo: Repo) {
        navigationItem.title = repo.fullName
        
        Nuke.loadImage(with: event.actor.avatarUrl, into: actorImage)
        eventLabel.text = event.type
        actorName.text = event.actor.login
        
        Nuke.loadImage(with: repo.owner.avatarURL, into: repoOwnerImage)
        repoName.text = repo.name
        repoDescription.text = repo.description
        
        stargazersView.setInfo(type: .stargazers, count: repo.stargazersCount)
        watchersView.setInfo(type: .watchers, count: repo.watchersCount)
        forksView.setInfo(type: .forks, count: repo.forksCount)
        
        privateView.setInfo(type: .isPrivate(repo.isPrivate))
        languageView.setInfo(type: .language(repo.language))
        issueView.setInfo(type: .issue(repo.openIssuesCount))
        dateView.setInfo(type: .date(repo.updatedAt))
    }
}
