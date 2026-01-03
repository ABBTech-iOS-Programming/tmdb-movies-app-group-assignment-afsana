//
//  SearchViewController.swift
//  Movies
//
//  Created by Afsana on 31.12.25.
//

import UIKit
import SnapKit
final class SearchViewController: UIViewController {

    private let searchView = CustomSearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        searchView.isEditable = true
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.textField.becomeFirstResponder()
    }

    private func setupUI() {
        view.addSubview(searchView)

        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
}
