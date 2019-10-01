//
//  MapViewDisplayViewController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 9/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit
import MapKit


class MapViewDisplayViewController: UIViewController, MKMapViewDelegate {

    
    var locationHelper = LocationHelper()
    let experienceController = ExperienceController()
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationHelper.requestLocationAuthorization()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        //remove annotations on the project , but why?
        //add annotations
        mapView.removeAnnotations(mapView.annotations)
        let experiences = experienceController.experiences
        mapView.addAnnotations(experiences)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
//        self.performSegue(withIdentifier: "toAddXP", sender: sender)
    }
  
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
        guard let experience = annotation as? Experience else {return nil}
        
        guard let av = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: experience) as? MKMarkerAnnotationView else {return nil}
        
        av.titleVisibility = .adaptive
        av.subtitleVisibility = .adaptive
        return av
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAddXP" {
//
//
        guard let destinationVC = segue.destination as? ImageAndRecordViewController else { return }
             destinationVC.experienceController = experienceController

        }
    }
//    }
    
    
    let annotationReuseIdentifier = "PostAnnotation"
}
