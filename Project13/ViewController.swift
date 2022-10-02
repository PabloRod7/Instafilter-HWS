//
//  ViewController.swift
//  Project13
//
//  Created by Pablo Rodrigues on 06/09/2022.
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    // challenge 3
    @IBOutlet weak var Radius: UISlider!
    
    // chqllenge 2
    @IBOutlet weak var filterButtom: UIButton!
    // challenge 3
    @IBOutlet weak var RadiusButton: UILabel!
    
    var currentImage : UIImage!
    
    var context : CIContext!
  
    var currentFilter : CIFilter!
  
    override func viewDidLoad() {
        super.viewDidLoad()
     title = "InstaFilter"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
       
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        //challenge 2
        filterButtom.setTitle("change filter", for: .normal)
        
        
    }
    
    @objc func importPicture () {
        let picker = UIImagePickerController ()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Chosse Filter", message: nil, preferredStyle: .actionSheet);
        
        ac.addAction(UIAlertAction(title: "CIBumpDistorcion", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CIPixallete", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CISepianTone", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CITwirlDistorion", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter));
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter));
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        
        present(ac, animated: true)
    }
    
    func setFilter (action: UIAlertAction) {
       
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
       // challeng 2
        filterButtom.setTitle("\(actionTitle)", for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()

    }
    
    @IBAction func save(_ sender: Any) {
        //challenge 1
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "save error", message: "you dindt choose a image yet !", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return
            
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(Image), nil)
    }
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func RadiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    
    func applyProcessing () {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputImageKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
           currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
             
            let processedImage = UIImage(cgImage: cgimg)
               imageView.image = processedImage
           }
        
       
            
    }
  
    @objc func Image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your new image has been saved !", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
  
   
}

