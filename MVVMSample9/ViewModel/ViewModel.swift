//
//  ViewModel.swift
//  MVVMSample9
//
//  Created by 鈴木楓香 on 2023/02/08.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    
    init(idTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         model: ModelProtocol) {
        let event = Observable
            .combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                return model.validate(idText: idText, passwordText: passwordText)
                    .materialize()
            }
            .share()
        
        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next: return .just("OK")
                    // errorの場合で、ModelErrorでキャスト後にnilでない
                case let .error(error as ModelError):
                    return .just(error.errorText)
                    // errorの場合で、引数がnil
                case .error, .completed: return .empty()
                }
            }
            .startWith("IDとPasswordを入力してください。")
        
        self.loadLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next: return .just(.green)
                    // 一律errorの場合はここ
                case .error: return .just(.red)
                case .completed: return .empty()
                }
                
            }  
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidIdAndPassword: return "IDとPasswordが未入力です。"
        case .invalidId: return "IDが未入力です。"
        case .InvalidPassword: return "Passwordが未入力です。"
        }
    }
}

