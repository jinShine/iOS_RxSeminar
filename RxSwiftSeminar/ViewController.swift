//
//  ViewController.swift
//  RxSwiftSeminar
//
//  Created by buzz on 2021/07/16.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {

  let disposeBag = DisposeBag()

  enum MyError: Error {
    case error
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    publishSubject()
    behaviorSubject()
    replaySubject()
    asyncSubject()

    just()

    switchLatest()
  }
}

// MARK: - Subject

/*
 1. PublishSubject
  : subscribe된 시점 이후 부터 발생한 이벤트를 전달한다.
 2. BehaviorSubject
  : publish와 비슷하지만, 초기값을 가진다.
 3. ReplaySubject
  : create 메서드를 생성
  : n개의 이벤트를 저장하고 있다가 subscribe된 시점과 상관없이 버퍼의 마지막 이벤트를 전달한다.
  : 마지막 값이 중요할때 사용
 4. AsyncSubject
  : Complete 될때까지 이벤트는 발생되지 않고, Complete가 되면 마지막 이벤트는 발생하고 종료
 */

extension ViewController {

  func publishSubject() {
    print("\n--------------[ PublishSubject ]---------------\n")

    let subject = PublishSubject<String>()

    subject.onNext("#1 여기선 실행 안되요~")

    subject
      .subscribe(onNext: {
        print("Buzz", $0)
      }).disposed(by: disposeBag)

    subject.onNext("Hello")
    subject.onError(MyError.error)
    subject.onCompleted()

    subject.onNext("Completed가 되어서 전달되지 않아요~")
  }

  func behaviorSubject() {
    print("\n--------------[ BehaviorSubject ]---------------\n")

    let subject = BehaviorSubject<String>(value: "초기값 입니다.")

    subject
      .subscribe(onNext: {
        print("Behavior", $0)
      }).disposed(by: disposeBag)

    subject.onNext("다음 값 입니다~")
  }

  func replaySubject() {
    print("\n--------------[ ReplaySubject ]---------------\n")

    let subject = ReplaySubject<Int>.create(bufferSize: 3)

    (1...10).forEach { subject.onNext($0) }

    subject
      .subscribe(onNext: {
        print("Replay 1", $0)
      }).disposed(by: disposeBag)

    subject
      .subscribe(onNext: {
        print("Replay 2", $0)
      }).disposed(by: disposeBag)

    subject.onNext(11)
  }

  func asyncSubject() {
    print("\n--------------[ AsyncSubject ]---------------\n")

    let subject = AsyncSubject<Int>()

    subject.onNext(1)

    subject
      .subscribe(onNext: {
        print("Async", $0)
      }).disposed(by: disposeBag)

    subject.onNext(2)
    subject.onNext(3)
    subject.onCompleted()
  }
}

// MARK: - Create Operators

/*
 1. just
  : 파라미터의 element를 그대로 방출
 */

extension ViewController {

  func just() {
    print("\n--------------[ Just ]---------------\n")

    Observable.just(1)
      .subscribe(onNext: {
        print($0) // 1
      }).disposed(by: disposeBag)

    Observable.just([1, 2, 3])
      .subscribe(onNext: {
        print($0) // [1, 2, 3]
      }).disposed(by: disposeBag)
  }
}

// MARK: - Combining

/*
 1. switchLatest
  : 주로 옵저버블의 형태를 방출할때 사용하며, 가장 최근의 옵저버블이 방출하는 이벤트를 전달한다.
 */

extension ViewController {

  func switchLatest() {
    print("\n--------------[ SwitchLatest ]---------------\n")

    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()

    // Observable의 String을 방출하는 Observable
    let source = PublishSubject<Observable<String>>()

    source
      .switchLatest()
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)

    source.onNext(subject1) // subject1을 구독하겠다.

    subject1.onNext("1")
    subject1.onNext("2")
    subject2.onNext("3")
    subject2.onNext("4")

    // subject1을 구독하였으므로 1, 2가 방출 된다.

    source.onNext(subject2) // subject2을 구독하겠다.

    subject1.onNext("100")
    subject1.onNext("200")
    subject2.onNext("300")
    subject2.onNext("400")

    // subject2을 구독하였으므로 300, 400이 방출 된다.

    source.onCompleted()
  }
}
