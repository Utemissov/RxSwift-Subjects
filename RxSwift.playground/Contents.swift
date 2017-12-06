import RxSwift

example(of: "PublishSubject") {
    let publish = PublishSubject<Int>()
    let subscription1 = publish.asObservable().subscribe {print("Subscription 1: \($0)")}
    publish.onNext(10)
    let subscription2 = publish.asObservable().subscribe {print("Subscription 2: \($0)")}
    publish.onNext(20)
    let subscription3 = publish.asObservable().subscribe {print("Subscription 3: \($0)")}
    publish.onNext(30)
}

example(of: "BehaviorSubject") {
    let behavior = BehaviorSubject<String>(value: "Hi")
    let subscription1 = behavior.asObservable().subscribe {print("Subscription 1: \($0)")}
    behavior.onNext("How are you?")
    let subscription2 = behavior.asObservable().subscribe {print("Subscription 2: \($0)")}
    behavior.onCompleted()
    let subscription3 = behavior.asObservable().subscribe {print("Subscription 3: \($0)")}
    behavior.onNext("Hey")
}

example(of: "Variable") {
    let variable = Variable<Bool>(false)
    let subscription1 = variable.asObservable().subscribe {print("Subscription 1: \($0)")}
    variable.value = true
    print("I just printed that variable is \(variable.value)")
}

example(of: "ReplaySubject") {
    let replay = ReplaySubject<Int>.create(bufferSize: 3)
    let subscription1 = replay.asObservable().subscribe {print("Subscription1: \($0)")}
    replay.onNext(0)
    replay.onNext(5)
    replay.onNext(9)
    replay.onNext(8)
    let subscription2 = replay.asObservable().subscribe {print("Subscription2: \($0)")}
}

example(of: "Dispose") {
    let behavior = BehaviorSubject<Int>(value: 0)
    let subscription = behavior.asObservable().subscribe { print($0) }
    behavior.onNext(5)
    subscription.dispose()
    behavior.onNext(10)
}

example(of: "OnDispose") {
    let publish = PublishSubject<String>()
    let subscription = publish.asObservable().subscribe(onNext: { (value) in
        print(value)
    }, onDisposed: {
        print("The subscription was disposed")
    })
    publish.onNext("Hi")
    subscription.dispose()
    publish.onNext("How are you?")
}
example(of: "Regular") {
    class Cat {
        init() {
            Person.shared.onEnter {[weak self] in
                guard let cat = self else { return false }
                print("Meaw")
                return true
            }
            Person.shared.entered = false
        }
    }
    
    class Person {
        static let shared = Person()
        typealias Callback = () -> Bool
        private var enterCallbacks: [Callback] = []
        var entered: Bool = false {
            didSet {
                for i in (0 ..< enterCallbacks.count).reversed() {
                    if !enterCallbacks[i]() {
                        enterCallbacks.remove(at: i)
                    }
                }
            }
        }
        
        func onEnter(callback: @escaping Callback) {
            enterCallbacks.append(callback)
        }
    }
    
    if true {
        let cat = Cat()
    }
    Person.shared.entered = false
}

example(of: "DisposeBag") {
    
    class Cat {
        let bag = DisposeBag()
        init() {
            Person.shared.entered.asObservable().subscribe(onNext: {[weak self] (value) in
                print("Meaw")
            }).disposed(by: bag)
        }
    }
    
    class Person {
        static let shared = Person()
        let entered = Variable<Bool>(false)
    }
    
    if true {
        let cat = Cat()
    }
    Person.shared.entered.value = true
    
    
    
    
}
