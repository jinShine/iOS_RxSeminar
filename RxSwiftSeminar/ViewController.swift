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
    of()
    from()
    range()
    generate()
    repeatElement()

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
  : 하나의 파라미터 element를 그대로 방출
 2. of
  : 가변 파라미터로, just처럼 하나의 element가 아닌 여러 element를 방출
 3. from
  : 배열을 파라미터로 받으며, 배열 요소 하나하나를 접근해서 element를 방출
 4. range
  : 정수를 지정된 수만큼 방출 ( start -> count )
  : 증가되는 수를 바꾸거나 감소하는 시퀀스는 하지 못한다.
 5. generate
  : range에서 하지 못했던 condition, iterate 조건으로 지정된 수를 조작할 수 있다.
  : initialState -> 초기값
  : condition -> 조건 (true 조건, false 조건이면 종료됨)
  : iterate -> 값을 바꾸는 코드
 6. repeatElement
  : 동일한 요소를 반복적으로 방출
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

  func of() {
    print("\n--------------[ Of ]---------------\n")

    Observable.of("apple", "kiwi")
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)

    Observable.of([1, 2], [2, 3])
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func from() {
    print("\n--------------[ From ]---------------\n")

    Observable.from([1, 2, 3])
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func range() {
    print("\n--------------[ Range ]---------------\n")

    // 꼭 정수를 입력해야 한다.
    Observable.range(start: 1, count: 5)
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func generate() {
    print("\n--------------[ Generate ]---------------\n")

    // 꼭 정수를 입력해야 한다.
    Observable.generate(
      initialState: 0, // 초기값
      condition: { $0 <= 10 }, // true 조건을 입력, false일 경우 종료됨.
      iterate: { $0 + 2 } // 값을 바꾸는 코드 (예를 들어 값의 증가, 감소 등)
    )
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)

    Observable.generate(
      initialState: 10,
      condition: { $0 >= 0 },
      iterate: { $0 - 2 }
    )
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)

    let smile = "😄"
    let angry = "😡"

    Observable.generate(
      initialState: smile,
      condition: { $0.count < 10 },
      iterate: { $0.count.isMultiple(of: 2) ? $0 + smile : $0 + angry }
    )
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)
  }

  func repeatElement() {
    print("\n--------------[ RepeatElement ]---------------\n")

    // 동일한 코드를 반복해서 실행하기 때문에 무한루프에 걸리게 된다.
    // 그래서 제한 조건을 꼭 설정 해야된다.
    Observable.repeatElement("😍")
      .take(3)
      .subscribe(onNext: {
        print($0)
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
