//
//  ExperienceController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 10/1/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL, audioURL: URL, imageData: Data) {
        
        let experience = Experience(title: title, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        
        experiences.append(experience)
    }
    
    
    
    var experiences: [Experience] = []
}
