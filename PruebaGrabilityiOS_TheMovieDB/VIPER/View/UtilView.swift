//
//  UtilView.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation
import UIKit

public struct Weak<T> where T: AnyObject {
    public weak var object: T?

    public init(_ object: T?) {
        self.object = object
    }
}

class UtilView{
    static func displayAlertView(_ title: String?, _ error: String?, _ style : UIAlertController.Style, viewController: Weak<UIViewController>) {
        guard let _ = error else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: error, preferredStyle: style)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        (viewController.object! as UIViewController).present(alertController, animated: true)
    }
}
