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
    typealias ViewModel = RepositoryViewModel.TypeErased
    
    @IBOutlet private var actorImageView: UIImageView!
    @IBOutlet private var eventBackgroundView: UIView!
    @IBOutlet private var eventLabel: UILabel!
    @IBOutlet private var actorNameLabel: UILabel!
    @IBAction private func detailButtonTouchUpInside(_ sender: Any) {
        let viewController = UserViewController.instantiate(argument: .init(username: viewModel.argument.event.actor.login))
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navigationViewController, animated: true)
    }

    @IBOutlet private var repoOwnerImageView: UIImageView!
    @IBOutlet private var repoNameLabel: UILabel!
    @IBOutlet private var repoDescriptionLabel: UILabel!
  
    @IBOutlet private var stargazersView: RepositoryCountView!
    @IBOutlet private var watchersView: RepositoryCountView!
    @IBOutlet private var forksView: RepositoryCountView!
    
    @IBOutlet private var privateView: RepositoryDataView!
    @IBOutlet private var languageView: RepositoryDataView!
    @IBOutlet private var issueView: RepositoryDataView!
    @IBOutlet private var dateView: RepositoryDataView!

    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.send(action: .fetch)
    }
    
    // MARK: - Initializer

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private init(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)!
    }
}

// MARK: - Instantiate

extension RepositoryViewController {
    static func instantiate(argument: ViewModel.Argument) -> Self {
       let viewModel = RepositoryViewModel(argument: argument)
       return instantiate(viewModel: viewModel.eraseToAnyViewModel())
    }
    
    static func instantiate(viewModel: ViewModel) -> Self {
            R.storyboard.repository().instantiateInitialViewController {
                Self(coder: $0, viewModel: viewModel)
            }!
        }
}

// MARK: - Setup

private extension RepositoryViewController {
    func setupUI() {
        actorImageView.layer.cornerRadius = actorImageView.frame.size.width * 0.5
        eventBackgroundView.layer.cornerRadius = 3;
        repoOwnerImageView.layer.cornerRadius = repoOwnerImageView.frame.size.width * 0.5
    }
    
    func bind() {
        viewModel.statePublisher.compactMap(\.repo)
            .sink{ [weak self] repo in
                self?.updateRepository(repo: repo)
            }
            .store(in: &cancellables)
    }
    
    func updateRepository(repo: Repo) {
        navigationItem.title = repo.fullName
        

        Nuke.loadImage(with: viewModel.argument.event.actor.avatarUrl, into: actorImageView)
        eventLabel.text = viewModel.argument.event.type
        actorNameLabel.text = viewModel.argument.event.actor.login
        
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
