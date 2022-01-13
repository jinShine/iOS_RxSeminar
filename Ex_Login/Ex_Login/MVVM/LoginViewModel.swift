//
//  LoginViewModel.swift
//  Ex_Login
//
//  Created by buzz on 2022/01/13.
//

import RxSwift
import RxCocoa
import UIKit

struct LoginViewModel {

  // MARK: - Input

  let viewWillAppear = PublishSubject<Void>()
  let combineContents = PublishSubject<(String, String)>()
  let didTapLogin = PublishSubject<Void>()

  // MARK: - Output

  let initBackgroundColor: Driver<UIColor>
  let userData: Driver<User>
  let isValidContents: Driver<Bool>
  let showAlert: Driver<Void>

  // MARK: - Initialize & Binding

  init(user: User) {

    let viewWillAppearShare = viewWillAppear.share()

    initBackgroundColor = viewWillAppearShare
      .take(1)
      .map { UIColor.blue }
      .asDriver(onErrorJustReturn: .blue)

    userData = viewWillAppearShare
      .map { user }
      .asDriver(onErrorJustReturn: .init())

    isValidContents = combineContents
//      .map { id, pw -> Bool in
//        !id.isEmpty && id == user.id && !pw.isEmpty && pw == user.pw
//      }
      .map { isValid(id: $0.0, pw: $0.1) }
      .asDriver(onErrorJustReturn: false)

    showAlert = didTapLogin
      .asDriver(onErrorJustReturn: ())


    // MARK: - Helper methods

    func isValid(id: String, pw: String) -> Bool {
      !id.isEmpty && id == user.id && !pw.isEmpty && pw == user.pw
    }
  }
}

extension ObservableConvertibleType {

  func asDriverOnErrorJustComplete() -> Driver<Element> {
    asDriver { _ in
      Driver.empty()
    }
  }
}
