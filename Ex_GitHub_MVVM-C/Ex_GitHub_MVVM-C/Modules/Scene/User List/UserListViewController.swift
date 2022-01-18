//
//  UserListViewController.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import RxCocoa
import RxSwift
import UIKit

final class UserListViewController: ViewController, ViewType {

  // MARK: - Constant

  typealias DataSource = UITableViewDiffableDataSource<Section, User>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User>

  private enum Metric {}

  // MARK: - UI Properties

  let tableView = UITableView(frame: .zero, style: .grouped)

  let indicatorView = UIActivityIndicatorView().then {
    $0.style = .large
    $0.tintColor = App.color.main
  }

  // MARK: - Properties

  let viewModel: UserListViewModel
  let navigator: Navigator
  let disposeBag = DisposeBag()
  lazy var datasource = createDataSource()
  lazy var snapshot = Snapshot()

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
    view.addSubviews([tableView, indicatorView])
    super.setupUI()
    setupTableView()
  }

  override func setupConstraints() {
    super.setupConstraints()

    indicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = datasource
    tableView.rowHeight = App.TableView.rowHeight
    tableView.register(UserInfoTableViewCell.nib(), forCellReuseIdentifier: UserInfoTableViewCell.reuseIdentifier)
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()

    rx.viewWillAppear.mapToVoid()
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)
  }

  override func outputBinding() {
    super.outputBinding()

    viewModel.isLoading
      .drive(indicatorView.rx.isAnimating)
      .disposed(by: disposeBag)

    viewModel.fetchUserList
      .drive(onNext: { [weak self] in
        self?.updateSnaptshot(items: $0)
      }).disposed(by: disposeBag)
  }
}

// MARK: - Helper methods

extension UserListViewController {}

extension UserListViewController: UITableViewDelegate {

  private func createDataSource() -> DataSource {
    return DataSource(tableView: tableView) { tableView, indexPath, item in

      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: UserInfoTableViewCell.reuseIdentifier, for: indexPath
      ) as? UserInfoTableViewCell else {
        return .init()
      }

      let cellViewModel = UserInfoTableViewCellViewModel(user: item)
      cell.bind(viewModel: cellViewModel)

      return cell
    }
  }

  private func updateSnaptshot(items: [User]) {
    defer {
      datasource.apply(snapshot, animatingDifferences: false)
    }

    snapshot.appendSections([.main])
    snapshot.appendItems(items)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
