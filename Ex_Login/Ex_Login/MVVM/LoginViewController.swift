//
//  LoginViewController.swift
//  Ex_Login
//
//  Created by buzz on 2022/01/13.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

  // MARK: - UI Properties

  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!

  // MARK: - Properties

  // DI는 설명 X
  // 데이터 주입은 각자
  let viewModel = LoginViewModel(user: User()) // 이렇게 주입 X, 어디선가 받아야된다 (viewWillAppear 사용방법)
  let disposeBag = DisposeBag()

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    inputBinding()
    outputBinding()
  }

  // MARK: - Setup

  private func setupUI() {

  }

//  private func setupConstraints() {
//
//  }

  // MARK: - Binding

  private func inputBinding() {

    rx.viewWillAppear
      .bind(to: viewModel.viewWillAppear)
//      .subscribe(onNext: {
//        self.viewModel.viewWillAppear.onNext(())
//      })
      .disposed(by: disposeBag)

    Observable.combineLatest(
      idTextField.rx.text.orEmpty.asObservable(),
      pwTextField.rx.text.orEmpty.asObservable()
    )
      .bind(to: viewModel.combineContents)
      .disposed(by: disposeBag)

    loginButton.rx.tap.asObservable()
      .bind(to: viewModel.didTapLogin)
      .disposed(by: disposeBag)
  }

  private func outputBinding() {

    viewModel.initBackgroundColor
      .drive(view.rx.backgroundColor)
      .disposed(by: disposeBag)

    viewModel.userData
      .drive(onNext: { user in
        print("초기 데이터", user)
      }).disposed(by: disposeBag)

    viewModel.isValidContents
      .drive(loginButton.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.showAlert
      .flatMap { [weak self] _ -> Driver<UIColor> in
        guard let self = self else { return .empty() }
        return self.rx.showAlert().asDriverOnErrorJustComplete()
      }
      .drive(view.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
}


extension Reactive where Base: UIViewController {

  var viewWillAppear: ControlEvent<Void> {
    let source = methodInvoked(#selector(self.base.viewWillAppear(_:)))
      .map { _ in }

    return ControlEvent(events: source)
  }

  var viewDidAppear: ControlEvent<Void> {
    let source = methodInvoked(#selector(self.base.viewDidAppear(_:))).map { _ in }

    return ControlEvent(events: source)
  }

}
