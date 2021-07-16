//
//  UserRepoTableViewCell.swift
//  Training
//
//  Created by Ong Yue Huei on 12/07/2021.
//

import UIKit

final class UserRepoTableViewCell: UITableViewCell {
    @IBOutlet private var repoName: UILabel!
    @IBOutlet private var repoDescription: UILabel!
    @IBOutlet private var stargazersValue: UILabel!
    
    func userRepo(_ repo: Repo) {
        repoName.text = repo.name
        repoDescription.text = repo.description
        stargazersValue.text = String(repo.stargazersCount)
    }
}

