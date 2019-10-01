//
//  ImageAndRecordViewController.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 9/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ImageAndRecordViewController: UIViewController, AVAudioRecorderDelegate{
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var monochromeLabel: UILabel!
    
    @IBOutlet weak var monochromeSlider: UISlider!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         monochromeSlider.isHidden = true
         monochromeLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addPosterImageTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
//                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
//        case .denied:
//            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
//        case .restricted:
//            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        default:
            break
        }
        presentImagePickerController()
        monochromeSlider.isHidden = false
        monochromeLabel.isHidden = false
        
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
        if recorder == nil {
                guard let recordingURL = recordingURL else { return }
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                do {
                    recorder = try AVAudioRecorder(url: recordingURL, settings: settings)
//                    recorder = try AVAudioRecorder(url: self.saveAudio() ?? <#default value#>, settings: settings)
                    recorder.delegate = self
                    recorder.record()
                    recordLabel.text = "Recording..."
                    recordButton.setTitle("Stop", for: .normal)
                } catch {
                    NSLog("Error recording audio comment: \(error)")
                }
            } else {
                
                let time = round(recorder.currentTime * 100) / 100
                
                recordLabel.text = "Recording duration: \(time) seconds"
                recorder.stop()
                recorder = nil
                recordButton.setTitle("Record", for: .normal)
        }
        
    }
    
    @IBAction func monochromeSliderAction(_ sender: Any) {
        self.updateImage()
    }
  
    
    //MARK: Private Image Func
      private func presentImagePickerController() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                else {
                    NSLog("The photo library is not available")
                    return
            }
//        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
//        }
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
            
//            let filteredImage = UIImage(cgImage: outputCGImage)
//            imageData = filteredImage.jpegData(compressionQuality: 1)
            
//            return filteredImage
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
 
    private func savePhoto(){
        //to ADD later
        self.updateImage()
        guard let originalImage = originalImage else {return}
        let processedImage = self.image(byFiltering: originalImage)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {return }
            
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
            }) { (success, error) in
                if let error = error {
                    NSLog("error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.presentSuccessfulSaveAlert()
                }
            }
        }
    }
    
    
    
    // MARK: Private Audio Func
//    private func saveAudio() -> URL?{
//        //To hook up to something later
//      let fm = FileManager.default
//             let documentsDirector = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//             return documentsDirector.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
//    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewVideoRecording" {
            guard let destinationVC = segue.destination as? LandingVideoViewController else { return }
            
            destinationVC.experienceController = experienceController
            destinationVC.recordingURL = recordingURL
            destinationVC.image = imageView.image
        }
    }
    
    
    
    //MARK: Properties Image
    
    var experienceController: ExperienceController?
//var imageData: Data?
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
    
    //MARK: Properties Audio
    var session: AVAudioSession!
    var recorder: AVAudioRecorder!

    var recordingURL: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
               
               return documentDirectory.appendingPathComponent("audioComment.m4a")
    }
     
}


    //MARK: Extension Image
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
