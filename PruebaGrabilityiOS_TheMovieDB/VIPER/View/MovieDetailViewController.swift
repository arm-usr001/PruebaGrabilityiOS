//
//  MovieDetailViewController.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 09/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, AnyView {
    var presenter: AnyPresenter?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overViewTextView: UITextView!
    
    var currentMovie: ResultMovieItemCall?
    
    @IBOutlet weak var ratingCircularProgressBar: CircularProgressBar!{
        didSet{
            ratingCircularProgressBar.lineWidth = 5
            ratingCircularProgressBar.backgroundColor = UIColor.clear
            ratingCircularProgressBar.lineColor = UIColor.green
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playButton: ArrowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.currentMovie?.title
        
        let baseURL = URL(string: APIConstants.secureBaseImageURLString)!
        let url = baseURL.appendingPathComponent(APIConstants.posterSizes[6]).appendingPathComponent(self.currentMovie?.poster_path ?? "/")
        self.posterImageView.kf.setImage(with: url)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let voteRating = (self.currentMovie?.vote_average ?? Double(1)) / 10
        self.ratingCircularProgressBar.setProgress(to: voteRating, withAnimation: true)
        
        self.dateLabel.text = self.currentMovie?.release_date?.dateShort()
        self.dateLabel.isHidden = true;
        
        UIView.transition(with: self.dateLabel, duration: 1, options: [.transitionFlipFromRight], animations: {
            self.dateLabel.isHidden = false
        })
        
        self.playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayButon)))

        if let string = self.currentMovie?.overview, string.isEmpty {
            self.overViewTextView.text = "No description"
        }
        else{
            self.overViewTextView.text = self.currentMovie?.overview
        }
        
        Router.wire(to: self)
    }
    
    @objc func tapPlayButon(){
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: { [weak self] in
                self?.playButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (bool) in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: { [weak self] in
                     self?.playButton.transform = CGAffineTransform.identity
                }, completion: {[weak self](bool) in
                    guard let movieId = self?.currentMovie?.id, movieId != 0 else{ return; }
                    let selectedMovieId = String(movieId)
                    let videoMethod = APIConstants.APIMethods.SearchMovie + selectedMovieId + APIConstants.APIMethods.SearchVideo
                    let url = APIURL.fullURLGeneral(videoMethod)
                    
                    self?.presenter?.interactor?.callMediaAPI(url, genericType: ResultVideoCall.self)
                })
            })
    }
    
    
    // MARK: AnyView protocol methods
    func update<T>(with movies: T, gen: T.Type) where T : Decodable, T : Encodable {
         if gen is ResultVideoCall.Type{
            guard let moviesLocal = movies as? ResultVideoCall, !(moviesLocal.results.isEmpty) else{
                UtilView.displayAlertView("Information", "There's no trailer yet.", .alert, viewController: Weak<UIViewController>(self))
                 return;
            }
            
            let storyboardId = "MovieTrailer"
            let controller = self.storyboard!.instantiateViewController(withIdentifier: storyboardId) as! MovieTrailerViewController
            
            let controllerView = controller as AnyView
            controllerView.setInitialData(with: moviesLocal as AnyObject)
            
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    func update(with error: Error) {}
    
    func setInitialData(with object: AnyObject) {
        guard let currentMovie: ResultMovieItemCall = object as? ResultMovieItemCall  else  { return; }
        self.currentMovie = currentMovie
    }
        
}



