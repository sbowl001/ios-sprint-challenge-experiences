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
        self.presentImagePickerController()
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func monochromeSliderAction(_ sender: Any) {
        self.updateImage()
    }
  
    
    //MARK: Private Func
      private func presentImagePickerController() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                else {
                    NSLog("The photo library is not available")
                    return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        private func image(byFiltering image: UIImage) -> UIImage {
            
            //UIImage > CGImage > CIImage
            guard let cgImage = image.cgImage else {return image}
            
            let ciImage = CIImage(cgImage: cgImage)
            
            //set the values of the filter's paramenters
            filter.setValue(ciImage, forKey: "inputImage")
            filter.setValue(monochromeSlider.value, forKey: "inputIntensity")
  
            
            //CIImage > CGImage > UIImage
            guard let outputCIImage = filter.outputImage else {return image }
            
            guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image}
            
            return UIImage(cgImage: outputCGImage)
        }
        
        private func updateImage() {
            if let scaledImage = self.scaledImage {
                imageView.image = self.image(byFiltering: scaledImage)
            } else {
                imageView.image = nil
            }
        }
        
        private func presentSuccessfulSaveAlert() {
            let alert = UIAlertController(title: "PhotoSaved!", message: "The photo has been saved to your Photo library", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            
            present(alert, animated: true, completion: nil)
        }
 
    //MARK: Properties
    
    var originalImage: UIImage? {
          didSet {
              guard let originalImage = self.originalImage else {return}
        
              var scaledSize = imageView.bounds.size
              
              let scale = UIScreen.main.scale
              scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height  * scale )
              self.scaledImage = originalImage.imageByScaling(toSize: scaledSize)
          }
      }
    
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }

    private let context = CIContext(options: nil)
    private let filter = CIFilter(name: "CIColorMonochrome")!
}

extension ImageAndRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
    }
}
