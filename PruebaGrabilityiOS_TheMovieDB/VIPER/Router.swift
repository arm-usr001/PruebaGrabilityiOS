//
//  Router.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//



import Foundation
import UIKit

typealias CurrentViewType = AnyView & UIViewController

protocol AnyRouter {
    static func wire(to view: CurrentViewType)
}

class Router : AnyRouter{
    private static var defaultPresenter: AnyPresenter = Presenter()
    private static var defaultInteractor: AnyInteractor = Interactor()
    private static var defaultRouter: AnyRouter = Router()
    
    static func wire(to view: CurrentViewType){
        var currentView = view;
        currentView.presenter = defaultPresenter
        defaultInteractor.presenter = defaultPresenter
                
        defaultPresenter.router = defaultRouter
        defaultPresenter.view = currentView
        defaultPresenter.interactor = defaultInteractor
    }
}
