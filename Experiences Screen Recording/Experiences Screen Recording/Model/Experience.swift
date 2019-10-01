//
//  Experience.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 10/1/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL
    var recordingURL: URL
    var image: UIImage
    
    init(title: String?, coordinate: CLLocationCoordinate2D, videoURL: URL, recordingURL: URL, image: UIImage) {
        self.title = title
        self.coordinate = coordinate
        self.videoURL = videoURL
        self.recordingURL = recordingURL
        self.image = image
    }
}
