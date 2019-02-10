//
//  ImageService.swift
//  Budget
//
//  Created by João Leite on 09/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static func downloadUserImage(completion: @escaping (UIImage)->()){
        
        if let url = UserDefaults.standard.string(forKey: "userImage") {
            let request = URLRequest(url: URL(string: url)!)
            let session = URLSession.shared
            
            _ = session.dataTask(with: request, completionHandler: { (data, res, err) in
                if err != nil {
                    print("fuck")
                    return
                }
                
                if let photoData = data {
                    let finalImage = UIImage(data: photoData)
                    completion(finalImage!)
                }
            }).resume()
        }
    }
}
