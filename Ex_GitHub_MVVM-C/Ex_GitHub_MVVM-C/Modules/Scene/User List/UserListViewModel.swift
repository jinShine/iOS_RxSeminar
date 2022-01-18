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

  // MARK: - Output

  let isLoading: Driver<Bool>
  let fetchUserList: Driver<[User]>

  // MARK: - Initialize && Binding

  init(userInteractor: UserInteractorable) {

    let onLoading = PublishRelay<Bool>()
    isLoading = onLoading.asDriverOnErrorJustComplete()

    let viewWillAppearShare = viewWillAppear.share()

    fetchUserList = viewWillAppearShare
      .do(onNext: { _ in onLoading.accept(true) })
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
      .flatMapLatest { userInteractor.fetchUserList(since: 1) }
      .do(onNext: { _ in onLoading.accept(false) })
      .map { $0 }
      .asDriverOnErrorJustComplete()
  }
}
