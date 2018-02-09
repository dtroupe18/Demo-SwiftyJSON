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
    
    // Marker: tableView delegate
    //
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
        cell.signatureLabel.font = UIFont.italicSystemFont(ofSize: 17)
        cell.signatureLabel.textColor = UIColor.red
        cell.urlLabel.text = petition.url
        cell.urlLabel.textColor = UIColor.blue
        
        let signatureCount = petition.signatureCount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: signatureCount)) {
            if signatureCount != 1 {
                cell.signatureLabel.text = "\(formattedNumber) Signatures"
            }
            else {
                cell.signatureLabel.text = "\(formattedNumber) Signature"
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openURL(recognizer:)))
        cell.urlLabel.addGestureRecognizer(tapGesture)
        cell.urlLabel.isUserInteractionEnabled = true
        
        return cell
    }
    
    @objc func openURL(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: location) {
            let urlString = petitions[indexPath.row].url
            
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
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
                // print("result: \(result)")
                let petition = Petition(json: result)
                    
                DispatchQueue.main.async {
                    self.petitions.append(petition)
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}













