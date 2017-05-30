//
//  ViewController.swift
//  CarthageExample
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getImage(_ sender: Any) {    //  SEND IMAGE TO PHP SERVER  FUNCTION
      
        
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
                            //self.delegate?.showSuccessAlert()
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            //                        self.showSuccesAlert()
                            //self.removeImage("frame", fileExtension: "txt")
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                            }
                        }
                        
                    case .failure(let encodingError):
                        //self.delegate?.showFailAlert()
                        print(encodingError)
                    }
                }

                
                picker.dismiss(animated: true, completion: nil)
            }
        }
    
    
        
        
        
    
        /*
        var image = UIImage.init(named: "image")
        image=imageView.image
        
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let userData = String("\(userID)").data(using: String.Encoding.utf8)
        
        var image1Data : NSData!
        if(self.imageView.image == nil ){
        }else{
            image1Data = UIImageJPEGRepresentation( self.imageView.image!, 0.5)! as NSData!
        }
        
        */
        
    @IBAction func send2server(_ sender: Any) {
    
        
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
        
        
        
        
        
        /*
 
         //  **** first try to send picture
 
        func sendImage(_ sender: Any) {
         
            var image = UIImage.init(named: "image")
            image=imageView.image
            let imgData = UIImageJPEGRepresentation(image!, 0.2)!
            
            let url = try! URLRequest(url: URL(string:"https://2eec40d5.ngrok.io/getimage.php")!, method: .post, headers: nil)
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
            },
                with: url,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if((response.result.value) != nil) {
                                
                            } else {
                                
                            }
                        }
                    case .failure( _):
                        break
                    }
            }
            )
            
            
            
        }
 
 */
        
        
    
    /*
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
            
            picker.dismiss(animated: true, completion: nil)
        }
    
    
    
    
    
        
            */
            
        
            
        
            
        
        
        /*
        
        //*****************      ALAMO  to   WATSON   with set URL image*****************//
    
        
        // https://unsplash.it/200/300?image=0

        let url = URL(string: "https://2eec40d5.ngrok.io/Picasso-1-300x300.jpeg")
        
        imageView.af_setImage(withURL: url!)
        
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
 */
        

            
    

    
}
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
