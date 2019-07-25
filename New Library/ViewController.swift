//
//  ViewController.swift
//  New Library
//
//  Created by Марат Нургалиев on 24/07/2019.
//  Copyright © 2019 Марат Нургалиев. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createSequence()
//        createSequenceSecond()
//        sequenceOnlyError()
//        workWithSubjects()
        chengeBeforeStream()
    }
    
    private func createSequenceFirst() {
        let helloSequence = Observable.just("Hello Rx")
//        let fibonacciSequence = Observable.from([0,1,1,2,3,5,8])
//        let dictSequence = Observable.from([1:"Hello",2:"World"])
        
        let subscription = helloSequence.subscribe { event in
            print(event)
        }
    }
    
    /// Обработка всех событий из последовательности
    private func createSequenceSecond() {
        let helloSequence = Observable.from(["H","e","l","l","o"])
        let subscription = helloSequence.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
    }
    
    
    private func sequenceOnlyError() {
        // Creating a DisposeBag so subscribtion will be cancelled correctly
        let bag = DisposeBag()
        // Creating an Observable Sequence that emits a String value
        let observable = Observable.just("Hello Rx!")
        // Creating a subscription just for next events
        let subscription = observable.subscribe (onNext:{
            print($0)
        })
        // Adding the Subscription to a Dispose Bag
        subscription.disposed(by: bag)
    }

    
    private func workWithSubjects() {
        let bag = DisposeBag()
        var publishSubject = PublishSubject<String>()
        // PublishSubject - передаст все, что придет после подписки
        // BehaviourSubject - Последний, и все, что придет после подписки
        // ReplaySubject - N предыдущих, и все, что придет после подписки
        // Variable - обертка над BehaviourSubject
        
        
        let subs1 = publishSubject.subscribe (onNext:{
            print("sub1: \($0)")
        }).disposed(by: bag)
        publishSubject.onNext("Hello")
        
        let subs2 = publishSubject.subscribe { event in
            switch event {
            case .next(let next):
                print("sub2: \(next)")
                
            case .error(let error):
                print("sub2 error: \(error)")
                
            case .completed:
                print("sub2 complete")
            }
            
        }
//        publishSubject.dispose()
        publishSubject.onNext("World")
        publishSubject.onCompleted()
        publishSubject.onNext("i'll be back")
    }
    
    
    
    private func chengeBeforeStream() {
        
        Observable.from([1,2,3,4,5]).map({ $0 * 10 }).subscribe(onNext:{
            print($0)
        })

        Observable.from([1,2,3,4,5]).scan(0, accumulator: { seed, value in
            seed + value
        }).subscribe(onNext:{
            print($0)
        })
        
        Observable.from([1,2,3,4,5,6,7,8,9,10,11,12,13,14]).buffer(timeSpan: 100, count: 3, scheduler: MainScheduler.instance).subscribe(onNext:{
            print($0)
        })
        
//        let sequence1 = Observable.of(1, 2)
//        let sequence2 = Observable.of(3, 4)
//        let sequenceOfSequences = Observable.of(sequence1, sequence2)
//        sequenceOfSequences.flatMap{ return $0 }.subscribe(onNext:{
//            print($0)
//        })

    }

}

