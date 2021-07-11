//
//  RepositoryViewController.swift
//  Training
//
//  Created by Ong Yue Huei on 09/07/2021.
//

import UIKit
import Nuke

final class RepositoryViewController: UIViewController{
    struct Dependency {
        var getRepoUseCase: GetRepoUseCase = GetRepoDefaultUseCase()
    }
    
    @IBOutlet var actorImage: UIImageView!{
        didSet {
            actorImage.layer.cornerRadius = actorImage.frame.size.width * 0.5
        }
    }
    @IBOutlet var eventBackground: UIView!{
        didSet {
            eventBackground.layer.cornerRadius = 3;
        }
    }
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var actorName: UILabel!
    @IBAction func detailButtonTouchUpInside(_ sender: Any) {
    }
    
    @IBOutlet var repoOwnerImage: UIImageView!{
        didSet {
            repoOwnerImage.layer.cornerRadius = repoOwnerImage.frame.size.width * 0.5
        }
    }
    @IBOutlet var repoName: UILabel!
    @IBOutlet var repoDescription: UILabel!
    
    @IBOutlet var stargazersView: RepositoryCountView!
    @IBOutlet var watchersView: RepositoryCountView!
    @IBOutlet var forksView: RepositoryCountView!
    
    @IBOutlet var privateView: RepositoryOtherView!
    @IBOutlet var languageView: RepositoryOtherView!
    @IBOutlet var issueView: RepositoryOtherView!
    @IBOutlet var dateView: RepositoryOtherView!

    private let dependency: Dependency
    private let event: Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Repository"
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
