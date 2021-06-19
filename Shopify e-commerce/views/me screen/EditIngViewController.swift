//
//  EditIngViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 08/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TKFormTextField

class EditIngViewController: UIViewController {
    @IBAction func firstNameEnd(_ sender: Any) {
        if(firstName.text == ""){
            firstName.error = "all faild required"
        }
        else if(!editViewModel.nameRegexCheck(text: firstName.text!)){
            firstName.error = "invalid name"
        }
        else{
            firstName.error = nil
        }
    }
    
    
    @IBAction func emailEnd(_ sender: Any) {
        if(email.text == ""){
            email.error = "all failds required"
        }
        else if(!editViewModel.emailRegexCheck(text: email.text!)){
            email.error = "invalid email"
        }
        else{
            email.error = nil
        }
    }
    
    
    @IBAction func phoneEnd(_ sender: Any) {
        if(phoneNumber.text == ""){
            phoneNumber.error = "all faild required"
        }
        else if(!editViewModel.phoneNumRegexCheck(text: city.text!)){
            phoneNumber.error = "invalid phone number"
        }
        else{
            phoneNumber.error = nil
        }
    }
    
    
    @IBAction func addressEnd(_ sender: Any) {
        if(addressTxtField.text == ""){
            city.error = "all faild required"
        }

        else{
            addressTxtField.error = nil
        }
        
    }
    @IBAction func cityEnd(_ sender: Any) {
        if(city.text == ""){
            city.error = "all faild required"
        }
        else if(!editViewModel.nameRegexCheck(text: city.text!)){
            city.error = "invalid city name"
        }
        else{
            city.error = nil
        }
    }
    @IBAction func countryEnd(_ sender: Any) {
        if(countrry.text == ""){
            countrry.error = "all faild required"
        }
        else if(!editViewModel.nameRegexCheck(text: countrry.text!)){
            countrry.error = "invalid countrry name"
        }
        else{
            countrry.error = nil
        }
    }
    @IBAction func lastNameEnd(_ sender: Any) {
        if(secondName.text == ""){
            secondName.error = "all failds required"
        }
        else if(!editViewModel.nameRegexCheck(text: secondName.text!)){
            secondName.error = "invalid name"
        }
        else{
            secondName.error = nil
        }
    }
    
    
    
    @IBOutlet weak var addressTxtField: TKFormTextField!
    @IBOutlet weak var firstName: TKFormTextField!
    @IBOutlet weak var secondName: TKFormTextField!
    @IBOutlet weak var email: TKFormTextField!
    @IBOutlet weak var phoneNumber: TKFormTextField!
    @IBOutlet weak var countrry: TKFormTextField!
    @IBOutlet weak var city: TKFormTextField!
    private var disposeBag:DisposeBag!
    private var editViewModel:EditInfoViewModel!
    private var activityView:UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit User Data"
        firstName.title = "firstName"
        secondName.title = "last name"
        email.title = "email"
        phoneNumber.title = "phoneNumber"
        countrry.title = "countrry"
        city.title = "city"
        addressTxtField.title = "addressTxtField"
        disposeBag = DisposeBag()
        editViewModel = EditInfoViewModel()


        activityView = UIActivityIndicatorView(style: .large)
        
        editViewModel.loadingObservable.subscribe(onNext: {[weak self] (result) in
            switch result{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        editViewModel.dataObservable.subscribe(onNext: {[weak self] (customer) in
            self?.setData(customer: customer)
        },onCompleted: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        editViewModel.fetchData()
    }
    
    
    @IBAction func submit(_ sender: UIButton) {
        if(firstName.text == ""){
            firstName.error = "all faild required"
            
        }
       if(secondName.text == ""){
        secondName.error = "all faild required"
            
        }
        if(city.text == ""){
            city.error = "all faild required"
            
        }
        if(countrry.text == ""){
            countrry.error = "all faild required"
           
        }
        if(email.text == ""){
            email.error = "all faild required"
           
        }
        if(phoneNumber.text == ""){
            phoneNumber.error = "all faild required"
           
        }
        if(addressTxtField.text == ""){
            addressTxtField.error = "all faild required"
           
        }
        editViewModel.validateData(firstName: firstName.text!, lastName: secondName.text!, email: email.text!, phoneNumber: phoneNumber.text!, country: countrry.text!, city: city.text!,address: addressTxtField.text!)
        
    }
    
    func setData(customer:Customer){
        firstName.text = customer.firstName
        secondName.text = customer.lastName
        email.text = customer.email
        phoneNumber.text = String(describing: customer.phone?.dropFirst(2) ?? "")
        if(!customer.addresses!.isEmpty){
            countrry.text = customer.addresses?[0]?.country ?? ""
            city.text = customer.addresses?[0]?.city ?? ""
            addressTxtField.text = customer.addresses?[0]?.address1 ?? ""
        }else{
            countrry.text = ""
            city.text = ""
            addressTxtField.text = ""
        }
    }
    

    func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        activityView!.stopAnimating()
    }
    
}
