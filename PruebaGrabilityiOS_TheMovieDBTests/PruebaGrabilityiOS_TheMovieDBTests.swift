//
//  PruebaGrabilityiOS_TheMovieDBTests.swift
//  PruebaGrabilityiOS_TheMovieDBTests
//
//  Created by Arm on 11/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import XCTest
@testable import PruebaGrabilityiOS_TheMovieDB

class PruebaGrabilityiOS_TheMovieDBTests: XCTestCase {
    
     var mainvc: ViewController?

    override func setUpWithError() throws {
//        continueAfterFailure = true;
             
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
        self.mainvc = storyboard.instantiateViewController(withIdentifier: "Main") as? ViewController //
        self.mainvc?.loadViewIfNeeded()
        self.mainvc?.viewDidLoad()
        
        Router.wire(to: self.mainvc!)
        
    }

    override func tearDownWithError() throws {
        self.mainvc = nil
    }
    

    func testGettingMoviesWithString() throws {
        
//        let stringForSearchMovies = "Avengers"
        let stringForSearchMovies = "fdsjblfjaskf"
        
        let expectation = XCTestExpectation(description: "Gettin list of movies...")
        
        self.mainvc?.searchController.searchBar.text = stringForSearchMovies
        let url = APIURL.fullURLForSearch(APIConstants.APIMethods.SearchTextMovie, searchString:  self.mainvc?.searchController.searchBar.text)
        
        self.mainvc?.presenter?.interactor?.callMediaAPI(url, genericType: ResultMovieCall.self, completition: { (entities) in
            XCTAssertGreaterThan(entities.results?.count ?? 0, 0, "No movies obtained with string \"\(stringForSearchMovies)\"")
            expectation.fulfill();
        })
        wait(for: [expectation], timeout: 5)
    }
    

}
