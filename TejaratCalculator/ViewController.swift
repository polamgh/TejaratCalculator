//
//  ViewController.swift
//  TejaratCalculator
//
//  Created by Ali Ghanavati on 1/9/1399 AP.
//  Copyright © 1399 AP Ali Ghanavati. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtFunctions: UILabel!
    @IBOutlet weak var txtNumber: UILabel!
    var decimal : Bool = false
    
    var currentNumber : Int64 = 0
    var functionPressed = false
    var isChange = false
    var value : Int64 = 0
    var lastOpt = "+"
    
    var displayValue: Int64 {
        get {
            return Int64(txtNumber.text!)!
        }
        set {
            let tmp = String(newValue).removeAfterPointIfZero()
            txtNumber.text = tmp.setMaxLength(of: 8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFunctions.text = ""
    }

    @IBAction func btnNumbers(_ sender: UIButton) {
        self.isChange = true
        if self.txtFunctions.text!.last == "=" {
            return
        }
        if self.txtNumber.text ?? "" == "0" || functionPressed {
            functionPressed = false
            displayValue = Int64(sender.titleLabel?.text ?? "") ?? 0
        }else {
            displayValue = Int64((self.txtNumber.text ?? "") + (sender.titleLabel?.text ?? "")) ?? 0
        }
    }
    
    fileprivate func operatorSelect(_ opt : String) {
        if self.txtFunctions.text!.last == "=" {
            lastOpt = opt
            let index = txtFunctions.text!.index(before: txtFunctions.text!.endIndex)
            txtFunctions.text = String(txtFunctions.text![..<index])
            txtFunctions.text = (txtFunctions.text ?? "") + opt
            return
        }
        if lastOpt == "=" && lastOpt != opt {
            lastOpt = opt
        }
        if isChange{
            switch lastOpt {
            case "+":
                if  (txtFunctions.text ?? "") == ""{
                    value = Int64(txtNumber.text!)!
                    lastOpt = opt
                }else{
                    value = value + Int64(txtNumber.text!)!
                    lastOpt = opt
                }
            break
            case "-":
                if  (txtFunctions.text ?? "") == ""{
                    value = Int64(txtNumber.text!)!
                    lastOpt = opt
                }else{
                    value = value - Int64(txtNumber.text!)!
                    lastOpt = opt
                }
            break
            case "*":
                if  (txtFunctions.text ?? "") == ""{
                    value = Int64(txtNumber.text!)!
                    lastOpt = opt
                }else{
                    value = value * (Int64(txtNumber.text!) ?? 0)
                    lastOpt = opt
                }
            break
            case "÷":
                if  (txtFunctions.text ?? "") == ""{
                    value = Int64(txtNumber.text!)!
                    lastOpt = opt
                }else{
                    value = value / Int64(txtNumber.text!)!
                    lastOpt = opt
                }
            break
            case "=":
                lastOpt = opt
            break
            default:
                print("error")
            }
            if String(value).count > 8 {
                value = 0
                txtNumber.text = "Error"
                self.resetCalculator()
            }
            
            self.txtFunctions.text = (txtFunctions.text ?? "") + (txtNumber.text ?? "0" ) + opt
            functionPressed = true
            isChange = false
        }else{
            if txtFunctions.text!.count > 1 {
                let index = txtFunctions.text!.index(before: txtFunctions.text!.endIndex)
                txtFunctions.text = String(txtFunctions.text![..<index])
                txtFunctions.text = (txtFunctions.text ?? "") + opt
            }
        }
        
        txtNumber.text = "\(value)"
        
    }
    
    @IBAction func btnFunction(_ sender: UIButton) {
        switch sender.tag {
        case 1: // ÷
           operatorSelect("÷")
           break
        case 2: // *
            operatorSelect("*")
            break
        case 3: // -
            operatorSelect("-")
            break
        case 4: // +
            operatorSelect("+")
            break
        case 5:
            if txtFunctions.text!.last != "="{
                isChange = true
                operatorSelect("=")
            }
            break
        case 8:
            backSpace()
            break
        case 9:
            self.resetCalculator()
            break
        default:
            print("Error")
        }
    }
    
    func resetCalculator() {
        self.txtNumber.text = "0"
        self.txtFunctions.text = ""
        self.currentNumber = 0
        self.value = 0
        self.lastOpt = "+"
    }
    func backSpace() {
         if txtNumber.text!.count > 1{
               let index = txtNumber.text!.index(before: txtNumber.text!.endIndex)
               txtNumber.text = String(txtNumber.text![..<index])
            let dotCheck = txtNumber.text!.firstIndex(of: ".") ?? txtNumber.text!.endIndex
            if dotCheck == txtNumber.text!.endIndex{
                decimal = false
            }
           }
           else if txtNumber.text!.count == 1{
               txtNumber.text = "0"
                decimal = false
           }
    }
}





















 public extension String {
    
    // set the max length of the number to display
     func setMaxLength(of maxLength: Int) -> String {
        var tmp = self
        
        if tmp.count > maxLength {
            var numbers = tmp.map({$0})
            
            if numbers[maxLength - 1] == "." {
                numbers.removeSubrange(maxLength+1..<numbers.endIndex)
            } else {
                numbers.removeSubrange(maxLength..<numbers.endIndex)
            }
            
            tmp = String(numbers)
        }
        return tmp
    }
    
    // remove the '.0' when the number is not decimal
     func removeAfterPointIfZero() -> String {
        let token = self.components(separatedBy: ".")
        
        if !token.isEmpty && token.count == 2 {
            switch token[1] {
            case "0", "00", "000", "0000", "00000", "000000":
                return token[0]
            default:
                return self
            }
        }
        return self
    }
}
