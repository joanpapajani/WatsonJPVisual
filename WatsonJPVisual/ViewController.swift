//
//  ViewController.swift
//  WatsonJPVisual
//
//  Created by John Papajani on 5/28/17.
//  Copyright © 2017 John Papajani. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import Alamofire
import MobileCoreServices
import CoreData
import PhotosUI





class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var promoResult: UITextView!
    
    @IBOutlet weak var compName: UILabel!
    
    @IBOutlet weak var locName: UILabel!
    
    var companyName:String!
    var locationName:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// For testing segue variables from previous controller
        print(companyName)
        print(locationName)
        
        self.compName.text = "Company: "+companyName
        
        self.locName.text = "Location: "+locationName
        
        
    }
    


    var promoMessage:String?
    
    let viewControllerB = SelectionPicker()
    
    
    @IBAction func getCode(_ sender: Any) {
  
        
        
        self.navigationController?.isNavigationBarHidden = true
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
        
        
    }
    
    
    

    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue);
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        
        
        
        var _url = "http://58c7e931.ngrok.io/getpromo.php"
        let parameters: Parameters = [
            "barcode": code,
            "company": companyName,
            "location": locationName
            
        ]
        
        
        
        
        Alamofire.request(_url,parameters:parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json1 = response.result.value
                print(json1)
                var jsonResponse1 : NSDictionary = NSDictionary()
                jsonResponse1 = json1 as! NSDictionary
                var label = jsonResponse1["Product Description"] as! String
                var discount = jsonResponse1["Discount"] as! String
                var SKUnum = jsonResponse1["SKU"] as! String
                
                
                if (SKUnum == "no"){
                    
                    self.promoResult.text = "Sorry we dont have this product in our database."
                    
                }
                else if (discount == "no"){
                    
                    var discount3 = "Sorry, there is no discount for this product in this location"
                    
                    self.promoResult.text = "SKU number: "+SKUnum+"\n\nProduct description: "+label+"\n\nDiscount for this location: " + discount3
                    
                }
                
                else{
                    
                
                var discount2 = (Double(discount)! * 100)
                var discount3 = String(Int(discount2))
                
                self.promoResult.text = "SKU number: "+SKUnum+"\n\nProduct description: "+label+"\n\nDiscount for this location: " + discount3+"%"
                
                }
                
                
                
                
                
                print(label)
                //print(discount3)
                
                
            case . failure(let error):
                print("Request failed with error: \(error)")
            }
            
        }
        
        
        self.navigationItem.title = "Barcode: "+code
        self.captureSession.stopRunning()
        self.previewLayer.removeFromSuperlayer()
        self.previewLayer = nil;
        self.captureSession = nil;
        self.navigationController?.isNavigationBarHidden = false
        
      
        
        
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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

    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
                    "company": companyName,
                    "location": locationName
                ]
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(UIImageJPEGRepresentation(self.imageView.image!, 0.5)!, withName: "photo_path", fileName: "image.jpeg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
                    }
                }, to:"http://58c7e931.ngrok.io/getimage.php")
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            
                            //print(response.request)
                            //print(response.response)
                            //print(response.data)
                            //print(response.result)
                            
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                var jsonResponse : NSDictionary = NSDictionary()
                                jsonResponse = JSON as! NSDictionary
                                var status1 = jsonResponse["Discount"] as! String
                                print(status1)
                                
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
        let version = "2017-06-09"
        
        
        var owners: [String] = ["bf4a56b0b163ef8cae452ae70c6552a1ced4c645", "IBM"]
        var classifierID: [String] = ["Colgate_1331719076", ""]
        var language = "en"
        
        
        
        
        let url = URL(string: "http://58c7e931.ngrok.io/image.jpeg")
        
       
        
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        
        
        
        
        
        let failure = {(error:Error) in
            
            DispatchQueue.main.async {
                self.navigationItem.title = "Image could not load"
                
            }
            print(error)
            
        }
        
        
        
        
        
        
        
        
        visualRecognition.classify(image: (url?.absoluteString)!, owners: owners, classifierIDs: classifierID, threshold: 0.2, language: language, failure: failure){
            
            classifiedImages in
            
            if let classifiedImage = classifiedImages.images.first {
                
                print(classifiedImage.classifiers)
                
                /*
                
                if (Double((classifiedImage.classifiers.first?.classes.first?.score)!)>Double((classifiedImage.classifiers.first?.classes.last?.score)!)){
                    
                    if let classification = classifiedImage.classifiers.first?.classes.first?.classification{
                        DispatchQueue.main.async {
                            self.navigationItem.title = classification
                        }
                        
                    }
                    
                    
                    
                }
                
                else if (Double((classifiedImage.classifiers.first?.classes.last?.score)!)>Double((classifiedImage.classifiers.first?.classes.first?.score)!)){
                    
                    if let classification = classifiedImage.classifiers.first?.classes.last?.classification{
                        DispatchQueue.main.async {
                            self.navigationItem.title = classification
                        }
                        
                    }
                    
                    
                    
                }
                
                 */
                
                
                
                if let classification = classifiedImage.classifiers.first?.classes.first?.classification{
                    DispatchQueue.main.async {
                        self.navigationItem.title = classification
                        
                        
                        if(classifiedImage.classifiers.first?.classes.first?.classification == "Colgate Wisp"){
                            
                            self.promoMessage = "Promotion on Colgate Wisp " + " for " + self.companyName + " in " + self.locationName + " is  10% off per single unit"
                            
                        }
                        
                    
                        else if(classifiedImage.classifiers.first?.classes.first?.classification == "Irish Spring Body Wash"){
                         
                            self.promoMessage = "Promotion on Irish Spring " + " for " + self.companyName + " in " + self.locationName + " is 5% off per single unit"
                            
                        }
                        
                        else if(classifiedImage.classifiers.first?.classes.first?.classification == "Softsoap Hand Wash"){
                            
                            self.promoMessage = "Promotion on Softsoap " + " for " + self.companyName + " in " + self.locationName + " is 20% off per single unit for orders of 10 or more"
                            
                        }
                        
                        else{
                            
                            self.promoMessage = "Sorry, product not found"
                            
                        }
                        
                        
                        self.promoResult.text = self.promoMessage
                        
                        
                        
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
    
    
    
    
    @IBAction func sendPicGeneral(_ sender: Any) {
        
        let apiKey = "bf4a56b0b163ef8cae452ae70c6552a1ced4c645"
        let version = "2017-06-09"
        
        
        var owners: [String] = ["bf4a56b0b163ef8cae452ae70c6552a1ced4c645", "IBM"]
        var classifierID: [String] = ["Colgate_1194136755", ""]
        var language = "en"
        
        
        
        
        let url = URL(string: "https://04fdef7e.ngrok.io/image.jpeg")
        
        
        
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
        
    }
}
