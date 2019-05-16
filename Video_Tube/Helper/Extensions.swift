//
//  Extensions.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/14/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /**
     Function that pop up limited internet connectivity alertView
     */
    func noInternetAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect your device to Internet", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     Function that pop up error alertView with OK button
     - Parameters: Error title string and Error Message string
     */
    func errorAlert(_ title: String,_ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//Set Up State Property with Key Value
class AsyncOperation: Operation{
    enum State:String{
        case Ready, Executing, Finished
        fileprivate var keyPath: String{
            return "is" + rawValue
        }
    }
    var state = State.Ready{
        willSet{
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
}

//Overrride Operation Property
extension AsyncOperation{
    override var isReady: Bool{
        return super.isReady == true && state == .Ready
    }
    override var isExecuting: Bool{
        return state == .Executing
    }
    override var isFinished: Bool{
        return state == .Finished
    }
    override var isAsynchronous: Bool{
        return true
    }
    override func start() {
        if isCancelled{
            state = .Finished
        }
        main()
        state = .Executing
    }
    override func cancel() {
        state = .Finished
    }
}


extension String{
    /**
     This convert string of date to Date
     and Date to timestamp
     
     - Parameter : By default its the string
     - Returns: timeStamp of type Double

     */
    func convertDateStringToTimeStamp() -> Double{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormater.date(from: self.replacingOccurrences(of: ".000Z", with: "Z"))
        return Double(date?.timeIntervalSince1970 ?? 0.0 * 1000)
    }
}
