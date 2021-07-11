//
//  ViewController.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 7/9/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import UIKit
import Kingfisher

//For Testing Network Request...
protocol VCTest{
    func updateComplete()
}

class ViewController: UIViewController, AnyView {
    var presenter: AnyPresenter?
    
    var test: VCTest? //For Testing Network Request...
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let searchController = UISearchController(searchResultsController: nil)

    var movies : ResultMovieCall?
    var moviesFiltered : [ResultMovieItemCall]?
    
    var imageProcessor = {
        DownsamplingImageProcessor(size:CGSize.init(width: 50, height: 50))
                 |> RoundCornerImageProcessor(cornerRadius: 20)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Buscar peliculas y/o series"
        configureSearchAndScopeBar()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Router.wire(to: self)
    }
    
    
    func configureSearchAndScopeBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        let categories = ["By Text", "Popular", "Top Rated", "Upcoming"]
        searchController.searchBar.scopeButtonTitles = categories
    }
    
    
    func switchVisibleViews(to visible:Bool){
        self.activityIndicator.isHidden = visible
        self.tableView.isHidden = !visible
    }
    
    // MARK: AnyView protocol methods
    func update<T>(with movies: T, gen: T.Type) where T : Decodable, T : Encodable {
        test?.updateComplete() //For Testing Network Request...
        switchVisibleViews(to: true)
        if gen is ResultMovieCall.Type{
            self.movies = movies as? ResultMovieCall
            self.moviesFiltered = self.movies?.results
            self.tableView.reloadData()
        }
    }
    
    func update(with error: Error) {
        UtilView.displayAlertView("Information", error.localizedDescription, .alert, viewController: Weak<UIViewController>(self))
    }
    
    func setInitialData(with object: AnyObject) {}
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesFiltered?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMovie", for: indexPath)
        let movie = self.moviesFiltered?[indexPath.row]
        
        cell.textLabel?.text = movie?.title
        cell.detailTextLabel?.text = movie?.release_date?.description
        
        let baseURL = URL(string:APIConstants.secureBaseImageURLString)!
        let url = baseURL.appendingPathComponent(APIConstants.posterSizes[0]).appendingPathComponent(movie?.poster_path ?? "/")
        
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(
            with: url,
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.flipFromRight(1)),
                .cacheOriginalImage
            ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboardId = "MovieDetail"
        let controller = storyboard!.instantiateViewController(withIdentifier: storyboardId) as! MovieDetailViewController
        
        let controllerView = controller as AnyView
        controllerView.setInitialData(with: self.moviesFiltered?[indexPath.row] as AnyObject)
        
        navigationController!.pushViewController(controller, animated: true)
    }
}



extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && (searchBar.selectedScopeButtonIndex == 0 ){
            switchVisibleViews(to: false)
            let url = APIURL.fullURLForSearch(APIConstants.APIMethods.SearchTextMovie, searchString: searchText)
            self.presenter?.interactor?.callMediaAPI(url, genericType: ResultMovieCall.self)
        }
        else{
            filterContent(by: searchText)
        }
    }
    
    func filterContent(by searchText: String) {
        if searchText.isEmpty {
            self.moviesFiltered = self.movies?.results
        }
        else{
            moviesFiltered = self.movies?.results?.filter({ (resultCallMovie) -> Bool in
                return resultCallMovie.title?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text = ""
         switchVisibleViews(to: false)
        switch selectedScope {
        case 0:
            switchVisibleViews(to: true)
            self.navigationItem.title = "By Text"
            self.moviesFiltered?.removeAll()
            self.tableView.reloadData()
        case 1:
            self.navigationItem.title = "Popular Movies"
            makeCallMediaAPI(with: APIConstants.APIMethods.SearchPopularMovie, pageMaxParam: 306)
        case 2:
            self.navigationItem.title = "Top Rated Movies"
            makeCallMediaAPI(with: APIConstants.APIMethods.SearchTopRatedMovies, pageMaxParam: 15)
        case 3:
            self.navigationItem.title = "Upcoming Movies"
            makeCallMediaAPI(with: APIConstants.APIMethods.SearchUpcomingMovies, pageMaxParam: 15)
        default:
            print("")
        }
    }

    func makeCallMediaAPI(with path: String, pageMaxParam: Int){
        let url = APIURL.fullURLGeneral(path, page: String(Int.random(in: 1..<pageMaxParam)))
        self.presenter?.interactor?.callMediaAPI(url, genericType: ResultMovieCall.self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

