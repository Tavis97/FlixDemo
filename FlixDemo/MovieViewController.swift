//
//  MovieViewcontroller.swift
//  FlixDemo
//
//  Created by Tavis Thompson on 6/21/17.
//  Copyright © 2017 Tavis Thompson. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewcontroller: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    var movies: [[String:Any]] = []
    var refreshControl: UIRefreshControl!
    var filteredMovies: [[String:Any]] = []
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
       
        activityIndicator.startAnimating()
        tableView.dataSource = self
        tableView.delegate = self
        SearchBar.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        refreshControl = UIRefreshControl()
        fetchMovies()
        
        refreshControl.addTarget(self, action: #selector(MovieViewcontroller.didPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
       
        
    }
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchMovies()
        
        
    }
    

    
    
    func fetchMovies(){
        let url = URL(string:
            "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        let request = URLRequest(url: url,cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: [])  as! [String:Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.filteredMovies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                print ("Network Request Recievied")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (filteredMovies.count)
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let  baseURLString  = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string:baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
    
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
        let movie = filteredMovies[indexPath.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filteredMovies = movies
        }
        else {
            //create a smaller array of the movies based on whats typed in
            
            filteredMovies = movies.filter{ (movie:[String:Any]) -> Bool in
                let title = movie["title"] as! String
                return title.range(of: searchText, options: .caseInsensitive,range: nil, locale: nil ) != nil
        }
        tableView.reloadData()
    }
        
    
}
}
