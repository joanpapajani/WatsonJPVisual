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



class SelectionPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    @IBOutlet weak var brandSelection: UIPickerView!
   
  
    
    var brandList = [["Walmart", "Costco", "Lidl", "Amazon"],["San Diego", "Teterboro", "Dublin", "Hong-Kong"]]
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? ViewController {
            viewControllerB.companyName = brandList[0][brandSelection.selectedRow(inComponent: 0)]
            viewControllerB.locationName = brandList[1][brandSelection.selectedRow(inComponent: 1)]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.brandSelection.dataSource = self;
        self.brandSelection.delegate = self;
        

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
       
        
       
        // Dispose of any resources that can be recreated.
    }

    
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandList[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return brandList[component][row]
        
        
    }
    

    

  
    
  
    



 

}
