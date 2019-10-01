//
//  ExperienceController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 10/1/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import UIKit 
import CoreLocation

class ExperienceController {
    
    
    func createExperience(title: String?, coordinate: CLLocationCoordinate2D, videoURL: URL, recordingURL: URL, image: UIImage) {
        
        let experience = Experience(title: title, coordinate: coordinate, videoURL: videoURL, recordingURL: recordingURL, image: image)
        
        experiences.append(experience)
    }
    
    
    
    var experiences: [Experience] = []
}
