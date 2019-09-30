//
//  LandingVideoViewController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 9/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit
import AVFoundation


class LandingVideoViewController: UIViewController {

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
    
}
