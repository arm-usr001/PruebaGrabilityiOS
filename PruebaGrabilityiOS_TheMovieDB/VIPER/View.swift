//
//  View.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation

//ref to presenter

protocol AnyView {
    var presenter: AnyPresenter? {get set}
    
    //main.async GDC methods for update UI
    func update<T:Codable>(with movies: T, gen: T.Type)
    func update(with error: Error)
    
    func setInitialData(with object: AnyObject)
}
