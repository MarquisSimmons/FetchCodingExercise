//
//  EventPhotosAPI.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
import UIKit

struct EventPhotosAPI: APIHandler {
 
    func parseResponse(data: Data) -> UIImage? {
        guard let returnedImage = UIImage(data: data) else {
            print("There was an error converting the Image data")
            return nil
        }
        return returnedImage
    }
}
