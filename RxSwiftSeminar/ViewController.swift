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
    deferred()
    create()
    empty()
    error()

    ignoreElements()
    element()
    filter()
    skip()
    skipWhile()
    skipUntil()
    take()
    takeWhile()
    takeUntil()

//    switchLatest()
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

 7. deferred
  : 특정 조건에 따라 옵저버블을 생성할 수 있다.
  : 옵저버블 방출

 8. create
  : 옵저버블을 직접 생성하는 방법

 9. empty
  : next element를 방출하지 않고, completed만 방출하고 끝
  : 옵저버가 아무런 동작을 안하고 종료해야할때 주로 사용.

 10 error
  : next element를 방출하지 않고, error만 방출하고 끝
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

  func deferred() {
    print("\n--------------[ Deferred ]---------------\n")

    let person1 = "SeungJin"
    let person2 = "jinShine"
    var flag = true

    let factory = Observable<String>.deferred {
      flag.toggle()

      if flag {
        return Observable<String>.just(person1)
      } else {
        return Observable<String>.just(person2)
      }
    }

    factory
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)

    let animals = ["🐶", "🐭", "🐱", "🐨", "🐯"]
    var isType = false

    Observable<[String]>.deferred {
      isType.toggle()
      return isType ? Observable.just(animals) : Observable.just([])
    }
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)
  }

  func create() {
    print("\n--------------[ Create ]---------------\n")

    Observable<String>.create { observer in
      guard let url = URL(string: "https://www.apple.co") else {
        observer.onError(MyError.error)
        return Disposables.create()
      }

      guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
      }

      observer.onNext(html)
      observer.onCompleted()

      return Disposables.create()
    }
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)
  }

  func empty() {
    print("\n--------------[ Empty ]---------------\n")

    Observable.empty()
      .debug()
      .subscribe(onNext: {
        print($0) // Completed만 방출되며 종료
      }).disposed(by: disposeBag)
  }

  func error() {
    print("\n--------------[ Error ]---------------\n")

    Observable.error(MyError.error)
      .debug()
      .subscribe(onNext: {
        print($0) // Error만 방출되며 종료
      }).disposed(by: disposeBag)
  }
}

// MARK: - Filtering Operators

/*
 1. ignoreElements
  : Observable<Never>를 방출하여 이후 스트림은 실행 안된다.

 2. element
  : 해당 index 아이템만 전달하고 Completed를 전달한다.

 3. filter
  : 시퀀스의 요소를 필터링합니다.

 4. skip
  : 지정된 수 만큼 무시하고 이후에 방출되는 요소만 전달한다.

 5. skipWhile
  : 클로저를 파라미터로 받으며,
  : ture를 리턴하는 동안 방출되는 요소를 무시한다.
  : false를 리턴하게되면 그때부터 조건에 관계없이 모든 요소를 방출하게 된다.

 6. skipUntil
  : 옵저버블을 파라미터로 받으며,
  : 옵저버블이 next 이벤트를 전달하기 전까지 무시하게된다.

 7. take
  : 정수를 파라미터로 받아서 해당 숫자 만큼만 요소를 방출한다.

 8. takeWhile
  : 클로저를 파라미터로 받으며,
  : true를 리턴하는 동안 요소를 방출하게 된다.
  : false를 리턴하게 되면 그때부터 조건에 관계 없이 모든 요소를 무시한다.
  : 첫 요소부터 false면 모든 요소를 더이상 방출하지 않는다.

 9. takeWhile
  : 옵저버블을 파라미터로 받으며,
  : 옵저버블이 next 이벤트를 전달하기 전까지 방출하게된다.
 */

extension ViewController {

  func ignoreElements() {
    print("\n--------------[ IgnoreElements ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .ignoreElements()
      .subscribe(onNext: {
        print("#", $0) // Never를 던져서 실행 print가 나오지 않는다.
      }).disposed(by: disposeBag)
  }

  func element() {
    print("\n--------------[ Element ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .element(at: 2)
      .subscribe(onNext: {
        print($0)
      })
      .disposed(by: disposeBag)
  }

  func filter() {
    print("\n--------------[ Filter ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .filter { $0.isMultiple(of: 2) }
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func skip() {
    print("\n--------------[ Skip ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .skip(3)
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func skipWhile() {
    print("\n--------------[ SkipWhile ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .skip(while: { $0 == 1 }) // 2,3,4,5,6
      //.skip(while: { $0 == 3 }) // 1,2,3,4,5,6
      .subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  }

  func skipUntil() {
    print("\n--------------[ SkipUntil ]---------------\n")

    let intSubject = PublishSubject<Int>()
    let trigger = PublishSubject<Int>()

    intSubject.skip(until: trigger)
      .subscribe(onNext: {
        print($0) // 2
      }).disposed(by: disposeBag)

    intSubject.onNext(1)
    trigger.onNext(1)
    intSubject.onNext(2)
  }

  func take() {
    print("\n--------------[ Take ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .take(2)
      .subscribe(onNext: {
        print($0) // 1, 2
      }).disposed(by: disposeBag)
  }

  func takeWhile() {
    print("\n--------------[ TakeWhile ]---------------\n")

    let intList = [1,2,3,4,5,6]

    Observable.from(intList)
      .take(while: { !$0.isMultiple(of: 2) })
      .subscribe(onNext: {
        print($0) // 1
      }).disposed(by: disposeBag)
  }

  func takeUntil() {
    print("\n--------------[ TakeUntil ]---------------\n")

    let intSubject = PublishSubject<Int>()
    let trigger = PublishSubject<Int>()

    intSubject.take(until: trigger)
      .subscribe(onNext: {
        print($0) // 1, 2, 3
      }).disposed(by: disposeBag)

    intSubject.onNext(1)
    intSubject.onNext(2)
    intSubject.onNext(3)

    trigger.onNext(4)

    intSubject.onNext(5)
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
