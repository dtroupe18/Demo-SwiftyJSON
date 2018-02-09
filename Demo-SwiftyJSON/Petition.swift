//
//  Petition.swift
//  Demo-SwiftyJSON
//
//  Created by Dave on 2/9/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Petition {
    
    let title: String
    let body: String
    let signatureCount: Int
    
    init?(json: JSON) {
        self.title = json["title"].stringValue
        self.body = json["body"].stringValue
        self.signatureCount = json["signatureCount"].intValue
        
        // print("Petition:\ntitle: \(title)\nbody: \(body)\nsignaturecount: \(signatureCount)\n")
    }
}
