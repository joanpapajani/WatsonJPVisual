//
//  ViewController.swift
//  WatsonJPVisual
//
//  Created by John Papajani on 5/28/17.
//  Copyright © 2017 John Papajani. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import AlamofireImage
import Alamofire
import MobileCoreServices
import CoreData
import PhotosUI



class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func getImage(_ sender: Any) {    
      
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
            
        }
    }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]!) {
            NSLog("Received image from camera")
            let mediaType = info[UIImagePickerControllerMediaType] as! String
            var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
            let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.compareCaseInsensitive)
            if ( compResult == CFComparisonResult.compareEqualTo ) {
                
                editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
                originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
                
                if ( editedImage != nil ) {
                    imageToSave = editedImage
                } else {
                    imageToSave = originalImage
                }
                imageView.image = imageToSave
                imageView.reloadInputViews()
                
                
                let parameters = [
                    "username": "john",
                    "password": "papa"
                ]
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(UIImageJPEGRepresentation(self.imageView.image!, 0.5)!, withName: "photo_path", fileName: "image.jpeg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to:"https://2eec40d5.ngrok.io/getimage.php")
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            
                            print(response.request)
                            print(response.response)
                            print(response.data)
                            print(response.result)
                            
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                            }
                        }
                        
                    case .failure(let encodingError):
                        
                        print(encodingError)
                    }
                }

                
                picker.dismiss(animated: true, completion: nil)
            }
        }
    

    
    
    @IBAction func sendPic(_ sender: Any) {
        
        let apiKey = "bf4a56b0b163ef8cae452ae70c6552a1ced4c645"
        let version = "2017-05-30"
        
        
        
        let url = URL(string: "https://2eec40d5.ngrok.io/image.jpeg")
        
       
        
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let failure = {(error:Error) in
            
            DispatchQueue.main.async {
                self.navigationItem.title = "Image could not load"
                
            }
            print(error)
            
        }
        
        
        
        visualRecognition.classify(image: (url?.absoluteString)!, failure: failure){
            
            classifiedImages in
            
            if let classifiedImage = classifiedImages.images.first {
                
                print(classifiedImage.classifiers)
                
                if let classification = classifiedImage.classifiers.first?.classes.first?.classification{
                    DispatchQueue.main.async {
                        self.navigationItem.title = classification
                    }
                    
                }
                
            }
            else{
                
                DispatchQueue.main.async{
                    self.navigationItem.title = "Could not be determined"
                }
            }
        }
        
        

    
}
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
