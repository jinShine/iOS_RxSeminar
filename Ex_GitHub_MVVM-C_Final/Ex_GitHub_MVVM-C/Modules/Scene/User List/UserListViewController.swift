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
    tableView.refreshControl = UIRefreshControl()
    tableView.rowHeight = App.TableView.rowHeight
    tableView.register(UserInfoTableViewCell.nib(), forCellReuseIdentifier: UserInfoTableViewCell.reuseIdentifier)
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()

    rx.viewWillAppear.mapToVoid()
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)

    tableView.rx.prefetchRows
      .compactMap { $0.last }
      .map { indexPath in (indexPath, self.datasource.snapshot().itemIdentifiers) }
      .bind(to: viewModel.prefetchRows)
      .disposed(by: disposeBag)

    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .bind(to: viewModel.didPullToRefresh)
      .disposed(by: disposeBag)
  }

  override func outputBinding() {
    super.outputBinding()

    viewModel.isLoading
      .drive(onNext: { [weak self] in
        self?.showLoading($0)
      })
      .disposed(by: disposeBag)

    viewModel.showAlert
      .drive(onNext: { [weak self] in
        self?.showAlert(title: "에러", message: $0)
      }).disposed(by: disposeBag)

    viewModel.fetchUserList
      .drive(onNext: { [weak self] in
        self?.updateSnaptshot(items: $0)
      }).disposed(by: disposeBag)
  }
}

// MARK: - Helper methods

extension UserListViewController {

  private func showLoading(_ isLoading: Bool) {
    if !isLoading {
      indicatorView.stopAnimating()
      tableView.refreshControl?.endRefreshing()
    } else if !tableView.refreshControl!.isRefreshing {
      indicatorView.startAnimating()
    }
  }

  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "확인", style: .default)
    alertController.addAction(alertAction)
    present(alertController, animated: true)
  }
}

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
    var snapshot = datasource.snapshot()

    if snapshot.sectionIdentifiers.isEmpty {
      snapshot.appendSections([.main])
    }

    snapshot.appendItems(items)
    datasource.apply(snapshot, animatingDifferences: false)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
