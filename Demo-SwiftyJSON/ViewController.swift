//
//  ViewController.swift
//  Demo-SwiftyJSON
//
//  Created by Dave on 2/9/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var petitions = [Petition]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        getPetitions()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetitionCell
        
        let petition = petitions[indexPath.row]
        cell.titleLabel.text = petition.title
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        cell.bodyLabel.text = petition.body
        
//        if petition.signatureCount != 1 {
//            cell.signatureLabel.text = "\(petition.signatureCount) Signatures"
//        }
//        else {
//            cell.signatureLabel.text = "\(petition.signatureCount) Signature"
//        }
        
        
        return cell
    }
    
    func getPetitions() {
        DispatchQueue.global(qos: .utility).async {
            let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            
            if let url = URL(string: urlString) {
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        // Everything is OK
                        //
                        self.parse(json: json)
                    }
                    else {
                        print("status: \(json["metadata"]["responseInfo"]["status"].intValue)")
                    }
                }
            }
        }
    }
    
    func parse(json: JSON) {
        DispatchQueue.global(qos: .utility).async {
            for result in json["results"].arrayValue {
                if let petition = Petition(json: result) {
                    
                    DispatchQueue.main.async {
                        self.petitions.append(petition)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}













