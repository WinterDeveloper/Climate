//
//  SecondViewController.swift
//  Climate
//
//  Created by Siyu Zhang on 5/29/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var secondDelegate : WeatherProtocol?

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func searchButton(_ sender: Any) {
        
        secondDelegate?.userEnterACityName(cityName: textField.text!)
        self.dismiss(animated: true, completion: nil)
        
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
