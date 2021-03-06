//
//  UserListViewModel.swift
//  Ex_GitHub_MVVM-C
//
//  Created by buzz on 2022/01/14.
//

import UIKit
import RxSwift
import RxCocoa

struct UserListViewModel: ViewModelType {

  // MARK: - Input

  let viewWillAppear = PublishSubject<Void>()
  let prefetchRows = PublishSubject<(indexPath: IndexPath, users: [User])>()
  let didPullToRefresh = PublishSubject<Void>()
  let didTapCell = PublishSubject<User>()

  // MARK: - Output

  let isLoading: Driver<Bool>
  let showAlert: Driver<(title: String, message: String)>
  let fetchUserList: Driver<[User]>

  // MARK: - Initialize && Binding

  init(userInteractor: UserInteractorable) {
    let size = 30
    var perPage = 0

    let onLoading = PublishRelay<Bool>()
    isLoading = onLoading.asDriverOnErrorJustComplete()

    let onError = PublishSubject<Error>()
    showAlert = Observable.merge(
      onError.map { ("에러", $0.localizedDescription) },
      didTapCell.map { ("알림", $0.name) }
    )
    .asDriverOnErrorJustComplete()

    let loadMore = prefetchRows
      .filter { $0.indexPath.row + 1 == $0.users.count }
      .mapToVoid()

    let pullToRefresh = didPullToRefresh
      .do(onNext: { reset() })

    fetchUserList = Observable.merge(viewWillAppear.take(1), loadMore, pullToRefresh)
      .do(onNext: { _ in onLoading.accept(true) })
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
      .map { perPage += size }
      .flatMapLatest {
        userInteractor.fetchUserList(page: perPage)
          .catch { error in
            onError.onNext(error)
            return .empty()
          }
      }
      .do(onNext: { _ in onLoading.accept(false) })
      .map { $0 }
      .asDriverOnErrorJustComplete()

    //MARK: - Helper methods

    func reset() {
      perPage = 0
    }
  }
}
