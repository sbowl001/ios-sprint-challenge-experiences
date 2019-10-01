//
//  LandingVideoViewController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 9/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation


class LandingVideoViewController: UIViewController {

    
   let locationHelper = LocationHelper()
    
    var experienceController: ExperienceController?
    var recordingURL: URL?
    var image: UIImage?
//    var imageData: Data?
    var videoURL: URL?
    
   override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
          
        }
        private func showCamera() {
            performSegue(withIdentifier: "RecordVideo", sender: self)
        }

    @IBAction func recordVideoTapped(_ sender: UIButton) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                  case .authorized:
                      self.showCamera()
                  case .notDetermined:
                      AVCaptureDevice.requestAccess(for: .video) { (granted) in
                          if granted {
                              DispatchQueue.main.async {
                                  self.showCamera()
                              }
                          }
                      }
                  case .denied:
                      return
                  case .restricted:
                      return
         
                 default:
                      return
                  }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let videoURL = videoURL,
            let recordingURL = recordingURL,
//            let coordinate = CLLocationCoordinate2D?,
//            let coordinate =  self.locationHelper.locationManager.location?.coordinate,
            let image = image else { return }
        
        
        LocationHelper.shared.getCurrentLocation { (coordinate) in
            self.experienceController?.createExperience(title: nil, coordinate: coordinate!, videoURL: videoURL, recordingURL: recordingURL, image: image)
            
        }
         self.dismiss(animated: true, completion: nil)
        
       
    }
}
