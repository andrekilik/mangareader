//
//  ViewController.swift
//  MangaReader
//
//  Created by Andre Casarini on 9/6/17.
//  Copyright © 2017 Andre Casarini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lblMangaTitle: UILabel!
    @IBOutlet weak var tvMangaList: UITableView!
    @IBOutlet weak var lblMangaSummary: UILabel!
    @IBOutlet weak var ivMangaCover: UIImageView!
    var session: URLSession?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        let url = URL(string: "https://api.myjson.com/bins/dsay1")
        let task = session!.dataTask(with: url!) {(data, response, error) in
            
            if let coverUrl = self.returnMangaCover(data: data!){
                DispatchQueue.main.async {
                    self.loadImageURL(imageURL: coverUrl)
                }
            }
            
            if let mangaName = self.returnMangaName(data: data!) {
                DispatchQueue.main.async {
                    self.lblMangaTitle.text = mangaName
                }
            }
            
            if let mangaSummary = self.returnMangaSummary(data: data!) {
                DispatchQueue.main.async {
                    self.lblMangaSummary.text = mangaSummary
                }
            }
        }
        task.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnChapList(data: Data) -> Str {
        <#function body#>
    }
    func returnMangaCover(data: Data) -> String? {
        var mangaCover:String? = nil
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let urlString = json["Cover"] as? String {
                mangaCover = urlString
            }
        }
        catch let error as NSError {
            return "Error Loading Manga Cover: \(error.localizedDescription)"

        }
        return mangaCover
    }
    
    func loadImageURL(imageURL: String) {
        let myUrl = URL(string: imageURL)
        let url = URLRequest(url: myUrl!)
        let session = URLSession.shared
        let task =  session.dataTask(with: url) {(data, response, error) in
            if let imageData = data {
                DispatchQueue.main.async {
                    self.ivMangaCover.image = UIImage(data: imageData)
                }
            }
        }
     task.resume()
    }

    func returnMangaName(data: Data) -> String? {
        var mangaName:String? = nil
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let mangaString = json["Manga"] as? String {
                mangaName = mangaString
            }
        }
        catch let error as NSError {
            return "Error Loading Manga Name \(error.localizedDescription)"
        }
        return mangaName
    }

    func returnMangaSummary(data: Data) -> String? {
        var mangaSummary:String? = nil
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let mangaString = json["Summary"] as? String {
                mangaSummary = mangaString
            }
        }
        catch let error as NSError {
            return "Error Loading Manga Summary \(error.localizedDescription)"
        }
        return mangaSummary
    }

}

