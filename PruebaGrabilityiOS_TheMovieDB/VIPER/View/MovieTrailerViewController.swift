//
//  MovieTrailerViewController.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 10/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import UIKit
import YouTubePlayer

class MovieTrailerViewController: UIViewController, AnyView {
    var presenter: AnyPresenter?
    
    @IBOutlet weak var youTubePlayer: YouTubePlayerView!
    
    var firstCurrentVideo :ResultVideoItemCall?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Trailer"
        self.youTubePlayer.loadVideoID(self.firstCurrentVideo?.key ?? "")        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Router.wire(to: self)
    }
    
    // MARK: AnyView protocol methods
    func update<T>(with movies: T, gen: T.Type) where T : Decodable, T : Encodable {}
    func update(with error: Error) {}
    func setInitialData(with object: AnyObject) {
        guard let currentVideo: ResultVideoCall = object as? ResultVideoCall  else  { return; }
        self.firstCurrentVideo = currentVideo.results.first
    }

}
