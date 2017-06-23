//
//  DetailViewController.swift
//  FlixDemo
//
//  Created by Tavis Thompson on 6/22/17.
//  Copyright © 2017 Tavis Thompson. All rights reserved.
//

import UIKit

enum MovieKeys{
    static let title = "title"
    static let backdropPath = "backdrop_path"
    static let posterPath  = "poster_path"
}

class DetailViewController: UIViewController {
    

    
    @IBOutlet weak var backDropImageView: UIImageView!
    
    @IBOutlet weak var PosterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var releasedateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
   
    var movie: [String:Any]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            releasedateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let posterPathString = movie[MovieKeys.posterPath] as! String
            let  baseURLString  = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            PosterImageView.af_setImage(withURL: posterPathURL)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Start the activity indicator

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
