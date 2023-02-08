//
//  ViewController.swift
//  MVVMSample9
//
//  Created by 鈴木楓香 on 2023/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    private lazy var viewModel = ViewModel(idTextObservable: idTextField.rx.text.asObservable(), passwordTextObservable: passwordTextField.rx.text.asObservable(), model: Model())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.validationText
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loadLabelColor
            .bind(to: loadLabelColor)
            .disposed(by: disposeBag)

    }
    
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.validationLabel.textColor = color
        }
    }



}
