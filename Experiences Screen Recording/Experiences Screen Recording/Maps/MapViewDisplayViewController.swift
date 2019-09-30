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

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //remove annotations
        //add annotations
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
    }
  
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let av = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else {return nil}
        
        av.titleVisibility = .adaptive
        av.subtitleVisibility = .adaptive
        return av
    }
    let annotationReuseIdentifier = "PostAnnotation"
}
