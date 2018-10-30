//
//  ViewController.swift
//  LoginRXDemo
//
//  Created by admin on 05/09/18.
//  Copyright © 2018 NIhilent. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var label_heading: UILabel!
    @IBOutlet weak var textfield_username: UITextField!
    
    @IBOutlet weak var textfield_password: UITextField!
    
    @IBOutlet weak var button_login: UIButton!
    
    @IBOutlet weak var button_register: UIButton!
    @IBOutlet weak var stackview_login: UIStackView!
    
    @IBOutlet weak var switch_account: UISwitch!
    let disposebag = DisposeBag()
     
    let subject:BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FirebaseApp.configure()
        
        switch_account.rx.isOn.changed.asObservable() //take signal if state is different than before. This is optional depends on your use
            .subscribe(onNext:{[weak self] value in
                //your code
                  self!.subject.accept(value) 
            }).disposed(by: disposebag)
        
            subject.asObservable().subscribe({isSelected in
                
                //your code
                if isSelected.element!{
                    self.button_register.isHidden = true
                    self.setUpSignInObservers()
                    
                 }
                else{
                    //register button show
                    self.button_register.isHidden = false
                    self.setUpSignUpObservers()
                }
            }).disposed(by: disposebag)
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK : Set up Observers
    func setUpSignInObservers(){
        
        let userNameObservable: Observable<Bool> = textfield_username.rx.text.map{ text -> Bool in
            return (text?.count)! >= 5
        }
        
        let passwordObservable : Observable<Bool> = textfield_password.rx.text.map{ text -> Bool in
            return (text?.count)! >= 8
        }
        
        let validationObservable:Observable<Bool> = Observable.combineLatest(userNameObservable, passwordObservable){$0 && $1}
        
        validationObservable.bind(to: button_login.rx.isEnabled).disposed(by: disposebag)
        
        button_login.rx.tap.asDriver().drive(onNext: {
            //call authentication
            Auth.auth().signIn(withEmail: self.textfield_username.text!, password: self.textfield_password.text!, completion: {(user,error) in
                //move to screen
                DataStorage.sharedData.saveData(data: "Nitisha")
            })
        }).disposed(by: disposebag)
    }
    
    func setUpSignUpObservers(){
        
        let userNameObservable: Observable<Bool> = textfield_username.rx.text.map{ text -> Bool in
            return (text?.count)! >= 5
        }
        
        let passwordObservable : Observable<Bool> = textfield_password.rx.text.map{ text -> Bool in
            return (text?.count)! >= 8
        }
        
        let validationObservable:Observable<Bool> = Observable.combineLatest(userNameObservable, passwordObservable){$0 && $1}
        
        validationObservable.bind(to: button_register.rx.isEnabled).disposed(by: disposebag)
        button_register.rx.tap.asDriver().drive(onNext: {
            // call for sign up
            Auth.auth().createUser(withEmail: self.textfield_username.text!, password: self.textfield_password.text!, completion: {(authresult , error) in
                //move to next screen
                self.textfield_username.text = ""
                self.textfield_password.text = ""
            })
        }).disposed(by: disposebag)
    }
}

