//
//  SelectionPicker.swift
//  WatsonJPVisual
//
//  Created by John Papajani on 6/13/17.
//  Copyright © 2017 John Papajani. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import Alamofire
import MobileCoreServices
import CoreData
import PhotosUI



class SelectionPicker: UIViewController {

    
    
    
    
    //@IBOutlet weak var brandSelection: UIPickerView!
    @IBOutlet weak var locationSelection: UIPickerView!
    
    
    @IBOutlet weak var brandSelect: UITextField!
    
    
    @IBOutlet weak var locationSelect: UITextField!
    
    //var brandsList: [String] = [String]()
    
    var brandList = [["Walmart", "Costco", "Lidl", "Amazon"],["San Diego", "Teterboro", "Dublin", "Hong-Kong"]]
    var selection = String()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? ViewController {
            viewControllerB.companyName = brandSelect.text
            viewControllerB.locationName = locationSelect.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.brandSelect.delegate = self as! UITextFieldDelegate
        //self.locationSelect.delegate = self as! UITextFieldDelegate
       //brandsList = ["Walmart", "Costco", "Lidl"]
        
        //self.brandSelection.dataSource = self;
        //self.brandSelection.delegate = self;
        
        //self.locationSelection.delegate = self
        //self.locationSelection.dataSource = self
        
        
        
        
    
    }
    
    
    
    
 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
       
        
       
        // Dispose of any resources that can be recreated.
    }

    
    
    
/*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandList[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print(brandList[0][0])
        
        updateLabel()
        
        return brandList[component][row]
        
        
    }
    
    func updateLabel(){
        var brand = brandList[0][brandSelection.selectedRow(inComponent: 0)]
        var location = brandList[1][brandSelection.selectedRow(inComponent: 1)]
        
        
        
    }
    
    
*/
  
    
  
    



 

}
