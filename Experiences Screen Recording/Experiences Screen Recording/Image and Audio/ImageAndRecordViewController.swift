//
//  ImageAndRecordViewController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 9/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit
import Photos

class ImageAndRecordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var monochromeLabel: UILabel!
    
    @IBOutlet weak var monochromeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPosterImageTapped(_ sender: Any) {
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func monochromeSliderAction(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
