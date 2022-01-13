//
//  UserListViewController.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import UIKit

final class UserListViewController: ViewController, ViewType {

  // MARK: - Constant

  private enum Metric {}

  // MARK: - UI Properties

  // MARK: - Properties

  let viewModel: UserListViewModel
  let navigator: Navigator

  // MARK: - Initialize

  init(viewModel: ViewModelType, navigator: Navigator) {
    self.viewModel = viewModel as! UserListViewModel
    self.navigator = navigator
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Setup

  override func setupUI() {
    super.setupUI()
  }

  override func setupConstraints() {
    super.setupConstraints()
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()
  }

  override func outputBinding() {
    super.outputBinding()
  }
}

// MARK: - Helper methods

extension UserListViewController {}
