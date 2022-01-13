//
//  ViewController.swift
//  Ex_Login
//
//  Created by buzz on 2022/01/13.
//

import RxSwift
import RxCocoa
import UIKit

struct User {
  let id = "김승진"
  let pw = "12345"
}

class ViewController: UIViewController {

  // MARK: - UI Properties

  @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var pwTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!

  // MARK: - Properties

  let user = User()
  let disposeBag = DisposeBag()

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    bind()
  }
}

// MARK: - Binding

extension ViewController {

  private func bind() {

    /*
     1. 유저 id, pw가 validation 체크
     2. 버튼 활성화
     3. 버튼 선택시 성공 alert
       3-1: 확인 버튼시 view.background 컬러 변경
       3-2: 취소는 그냥 dismiss
     */

    let idObservable = idTextField.rx.text.orEmpty.asObservable()
    let pwObservable = pwTextField.rx.text.orEmpty.asObservable()

    Observable.combineLatest(idObservable, pwObservable)
      .map { [weak self] id, pw -> Bool in
        return !id.isEmpty && id == self?.user.id && !pw.isEmpty && pw == self?.user.pw
      }
//      .bind(to: loginButton.rx.customActiveButton)
      .subscribe(onNext: { [weak self] isValid in // bind?
        if isValid {
          self?.loginButton.isEnabled = true
          self?.loginButton.alpha = 1
          self?.loginButton.backgroundColor = .blue
        } else {
          self?.loginButton.isEnabled = false
          self?.loginButton.alpha = 0.2
          self?.loginButton.backgroundColor = .gray
        }
      })
      .disposed(by: disposeBag)

//    loginButton.rx.tap
//      .subscribe(onNext: {
//        let alertControl = UIAlertController(title: "타이틀", message: "메세지", preferredStyle: .alert)
//        let action = UIAlertAction(title: "확인", style: .default) { _ in
//          self.view.backgroundColor = .brown
//        }
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        alertControl.addAction(action)
//        alertControl.addAction(cancel)
//
//        self.present(alertControl, animated: true, completion: nil)
//      }).disposed(by: disposeBag)


    loginButton.rx.tap
      .flatMap { [weak self] _ -> Observable<UIColor> in
        guard let self = self else { return .empty() }
        return self.rx.showAlert()
      }
      .bind(to: view.rx.backgroundColor)
      .disposed(by: disposeBag)






    // share가 필요한 예제
    /*
     let oInterval = Observable<Int>
       .interval(.seconds(1), scheduler: MainScheduler.instance)
       .take(2)
       .do(onNext: {
         print("#do#", $0)
       })
       .share()

     oInterval
       .subscribe(onNext: { [weak self] in
         print("#1", $0)
       }).disposed(by: disposeBag)


     oInterval
       .subscribe(onNext: { [weak self] in
         print("#2", $0)
       }).disposed(by: disposeBag)
     */
  }
}

// 이런 방식으로 커스텀 할 수도 있다.
// 하지만 ??
extension Reactive where Base: UIButton {

  var customActiveButton: Binder<Bool> {
                                    // base, 들어온 인자
    return Binder<Bool>(self.base) { button, isValid in
      if isValid {
        button.isEnabled = true
        button.alpha = 1
        button.backgroundColor = .blue
      } else {
        button.isEnabled = false
        button.alpha = 0.2
        button.backgroundColor = .gray
      }
    }
  }
}

extension Reactive where Base: UIViewController {

  func showAlert() -> Observable<UIColor> {
    Observable.create { observer in
      let alertControl = UIAlertController(title: "타이틀", message: "메세지", preferredStyle: .alert)
      let action = UIAlertAction(title: "확인", style: .default) { _ in
        observer.onNext((.brown))
      }

      let cancel = UIAlertAction(title: "취소", style: .cancel)
      alertControl.addAction(action)
      alertControl.addAction(cancel)

      self.base.present(alertControl, animated: true, completion: nil)


//      return Disposables.create()
      return Disposables.create {
        // dispose 됬을때 실행되는 구간
        print("## dispose")
      }
    }
  }
}
