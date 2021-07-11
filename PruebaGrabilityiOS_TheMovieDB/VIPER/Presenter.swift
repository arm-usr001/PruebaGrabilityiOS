//
//  Presenter.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//


//ref to interactor
//ref to router
//ref to view

import Foundation


protocol AnyPresenter{
    var router : AnyRouter? {get set}
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    
    //Main.asyn GDC methods for update UI
    func interactorDidFetchMediaData<T: Codable>(with result: Result<Codable, Error>, gen: T.Type)
}

class Presenter: AnyPresenter{
    var router: AnyRouter?
    var interactor: AnyInteractor?
    var view: AnyView?
    
    func interactorDidFetchMediaData<T: Codable>(with result: Result<Codable, Error>, gen: T.Type) {
        DispatchQueue.main.async {[weak self] in
            switch result {
            case .success(let media):
                self?.view?.update(with: media as! T, gen: gen)
            case .failure(let error):
                self?.view?.update(with: error)
            }
        }
    }

}
