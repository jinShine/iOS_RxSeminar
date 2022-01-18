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

  // MARK: - Output

  let isLoading: Driver<Bool>
  let fetchUserList: Driver<[User]>

  // MARK: - Initialize && Binding

  init(userInteractor: UserInteractorable) {
    let size = 30
    var perPage = 0

    let viewWillAppearShare = viewWillAppear.share()

    let onLoading = PublishRelay<Bool>()
    isLoading = onLoading.asDriverOnErrorJustComplete()

    // data
    let loadMore = prefetchRows
      .filter { $0.indexPath.row + 1 == $0.users.count }
      .mapToVoid()

    let pullToRefresh = didPullToRefresh
      .do(onNext: { reset() })

    fetchUserList = Observable.merge(viewWillAppearShare.take(1), loadMore, pullToRefresh)
      .do(onNext: { _ in onLoading.accept(true) })
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
      .map { perPage += size }
      .flatMapLatest { userInteractor.fetchUserList(page: perPage) }
      .do(onNext: { _ in onLoading.accept(false) })
      .map { $0 }
      .asDriverOnErrorJustComplete()


    //MARK: - Helper methods

    func reset() {
      perPage = 0
    }
  }
}
