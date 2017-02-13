//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Lin Zhou on 2/6/17.
//  Copyright © 2017 Lin Zhou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
       // let smallImageRequest = NSURLRequest(URL:NSURL(string: "https://image.tmdb.org/t/p/w45\(posterPath )"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        titleLabel.sizeToFit()
        overviewLabel.sizeToFit()
        
        //let baseUrl = "https://image.tmdb.org/t/p/w500"
        let smallUrl = "https://image.tmdb.org/t/p/w45"
        let largeUrl = "https://image.tmdb.org/t/p/original"
        
        if let posterPath = movie["poster_path"] as? String{
            let smallImageRequest = NSURLRequest(url:NSURL(string: smallUrl + posterPath) as! URL)
            let largeImageRequest = NSURLRequest(url:NSURL(string: largeUrl + posterPath) as! URL)
            //let imageUrl = NSURL(string: baseUrl + posterPath)
            //posterImageView.setImageWith(imageUrl! as URL)
            posterImageView.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                // imageResponse will be nil if the image is cached
                if smallImageResponse != nil{
                    print("Imaged was NOT cached, fade in image")
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage
                    
                    UIView.animate(withDuration: 0.8, animations: {
                        self.posterImageView.alpha = 1.0
                    }, completion:{(success) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImageView.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                if largeImageResponse != nil{
                                    self.posterImageView.alpha = 0.0
                                    self.posterImageView.image = largeImage
                                    
                                    UIView.animate(withDuration: 0.8, animations: {
                                        self.posterImageView.alpha = 1.0
                                    })
                                }
                                else{
                                    self.posterImageView.image = largeImage
                                }
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
                } else{
                    print("Image was cached so just update the image")
                    self.posterImageView.setImageWith(NSURL(string:(largeUrl + posterPath)) as! URL)
                }
            },
                failure: { (smallImageRequest, smallImageResponse, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
                })
        // Do any additional setup after loading the view.
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
