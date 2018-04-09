//
//  ViewController.swift
//  Calc
//
//  Created by DeanChiu on 2017-10-06.
//  Copyright © 2017 DeanChiu. All rights reserved.
//

import UIKit
import Foundation

struct Stack {
    fileprivate var array: [Double] = []
    
    mutating func push(_ element: Double){
        array.append(element)
    }
    
    mutating func popR() -> Double?{
        return Double(array.popLast()!)
    }
    
    mutating func pop(){
        array.removeLast()
    }
    
    mutating func removeHead() -> Double?{
        return Double(array.removeFirst())
    }
    
    mutating func remove(){
        array.removeAll(keepingCapacity: false)
    }
    
    mutating func result() -> Double{
        let temp = array.first
        return temp!
    }
    
    mutating func check() -> Double{
        return array[1]
    }
    
    mutating func add(){
        let num1:Double = popR()!
        let num2:Double = popR()!
        push(num1+num2)
    }
    
    mutating func subtract(){
        let num1:Double = popR()!
        let num2:Double = popR()!
        push(num2-num1)
    }
    
    mutating func multiply(){
        let num1:Double = popR()!
        let num2:Double = popR()!
        push(num1*num2)
    }
    
    mutating func mod(){
        let num1:Double = popR()!
        let num2:Double = popR()!
        let num3:Double = num2 - Double(Int(num2/num1)*Int(num1))
        push(num3)
    }
    
    mutating func divide(){
        let num1:Double = popR()!
        let num2:Double = popR()!
        if(num1 != 0){
            var temp = num2/num1
            temp = Double(round(temp*10000)/10000)
            push(temp)
        }else if(num2 == 0){
            remove()
        }
    }
    
    mutating func length() -> Int{
        return array.count
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label1: UILabel!
    var inNum = false
    var decimal = false
    var zeroNeg = false
    var numS = ""
    var previousTag = 0
    var numStack = Stack()
    var operationStack = Stack()
    
    
    
    @IBAction func Numbers(_ sender: UIButton) {
        let number = sender.currentTitle!
        
        if previousTag == 25{
            Label2.text!.removeAll()
        }
        //starting 0 removal
        if inNum == false {
            Label2.text!.removeAll()
            Label2.text = Label2.text! + number
            inNum = true
        }else if inNum == true{
            Label2.text = Label2.text! + number
        }
        zeroNeg = true
        numS.append(number)
        previousTag = sender.tag
    }
    
    //decimal
    @IBAction func deci(_ sender: UIButton) {
        if previousTag == 25{
            Label2.text!.removeAll()
        }
        if decimal == false{
            Label2.text = Label2.text! + "."
            if numS == ""{
                numS.append("0")
                numS.append(".")
            }else{
                numS.append(".")
            }
            decimal = true
            inNum = true
            zeroNeg = true
        }
        previousTag = sender.tag
    }
    
    //Negative operator
    @IBAction func Neg(_ sender: UIButton) {
        if numS == ""{zeroNeg = true}
        if 12...16 ~= previousTag{
            Label2.text = Label2.text! + "-"
            numS.append("-")
            inNum = true
            zeroNeg = true
        }else if (inNum == true) && (zeroNeg == true){
            if numS == "-"{
                numS = ""
                inNum = false
                let range = Label2.text!.index(Label2.text!.endIndex, offsetBy: -1)..<Label2.text!.endIndex
                Label2.text!.removeSubrange(range)
            }else{
                var tempNeg = Double(numS)
                let length = numS.characters.count
                let range = Label2.text!.index(Label2.text!.endIndex, offsetBy: -length)..<Label2.text!.endIndex
                tempNeg = -tempNeg!
                numS = String(tempNeg!)
                Label2.text!.removeSubrange(range)
                Label2.text!.append(numS)
            }
        }else if Label2.text! == "0" || previousTag == 25{
            Label2.text!.removeAll()
            Label2.text = Label2.text! + "-"
            numS.append("-")
            inNum = true
            zeroNeg = true
        }else if previousTag == 21{
            Label2.text = Label2.text! + "-"
            numS.append("-")
            inNum = true
            zeroNeg = true

        }
        previousTag = sender.tag
        
    }
    
    //AC
    @IBAction func AC(_ sender: UIButton) {
        Label2.text = "0"
        Label1.text = ""
        inNum = false
        decimal = false
        zeroNeg = false
        numS.removeAll()
        numStack.remove()
        operationStack.remove()
        previousTag = 0
    }
    
    
    //operationStack 1:+ 2:- 3:x 4:/ 5:%
    @IBAction func Operations(_ sender: UIButton) {
        if previousTag == 25{
            Label2.text!.removeAll()
            Label2.text = Label1.text
            Label1.text!.removeAll()
            numStack.push(Double(Label2.text!)!)
        }else if !(12...16 ~= previousTag){
            if numS == ""{
                numStack.push(0)
            }else if(previousTag != 21){
                numStack.push(Double(numS)!)
            }
        }
        numS.removeAll()
        
        //Label2 display
        if 12...16 ~= previousTag{
            operationStack.pop()
            let _ = Label2.text!.characters.removeLast(1)
        }
        Label2.text = Label2.text! + sender.currentTitle!
        operationStack.push(Double(sender.tag % 11))
        previousTag = sender.tag
        print("numStack before \(numStack)")

        if numStack.length() == 2 && operationStack.length() >= 1{
            let tempOp = operationStack.removeHead()!
            print("operation stack \(operationStack)")
            print("tempop \(tempOp)")
            switch tempOp {
            case 1.0:
                numStack.add()
            case 2.0:
                numStack.subtract()
            case 3.0:
                numStack.multiply()
                print("after calculation \(numStack)")
            case 4.0:
                if numStack.check() == 0{
                    Label1.text! = ""
                    Label2.text! = "division by 0"
                }else{
                    numStack.divide()
                }
            case 5.0:
                numStack.mod()
            default:
                break
            }
        }
        print("numStack after \(numStack)")
    }
    
    // equal
    @IBAction func equal(_ sender: UIButton) {
        if numS == "" || numS == "-"{
            numStack.push(0)
        }else{
            numStack.push(Double(numS)!)
        }
        numS.removeAll()
        
        if 12...16 ~= previousTag{
            let _ = operationStack.popR()
        }else if numStack.length() == 2 && operationStack.length() >= 1{
            let tempOp = operationStack.removeHead()!
            switch tempOp {
            case 1.0:
                numStack.add()
            case 2.0:
                numStack.subtract()
            case 3.0:
                numStack.multiply()
            case 4.0:
                if numStack.check() == 0{
                    Label1.text! = ""
                    Label2.text! = "division by 0"
                }else{
                    numStack.divide()
                }
            case 5.0:
                numStack.mod()
            default:
                break
            }
        }
        let result = numStack.removeHead()!
        if (result - Double(Int(result)) == 0){
            Label1.text = String(Int(result))
        }else{
            Label1.text = String(result)
        }
        previousTag = sender.tag
        inNum = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

