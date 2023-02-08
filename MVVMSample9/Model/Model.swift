//
//  Model.swift
//  MVVMSample9
//
//  Created by 鈴木楓香 on 2023/02/08.
//

import Foundation
import RxSwift

enum ModelError: Error {
    case invalidId
    case InvalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

final class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidId)
        case (.some, .none):
            return Observable.error(ModelError.InvalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return Observable.error(ModelError.invalidIdAndPassword)
            case (true, false):
                return Observable.error(ModelError.invalidId)
            case (false, true):
                return Observable.error(ModelError.InvalidPassword)
            case (false, false):
                return Observable.just(())
            }
        }
    }
    
}
