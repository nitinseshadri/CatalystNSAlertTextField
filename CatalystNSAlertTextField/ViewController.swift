//
//  ViewController.swift
//  CatalystNSAlertTextField
//
//  Created by Nitin Seshadri on 11/26/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAlertWithTextField() {
        let controller = UIAlertController(
            title: "Change Playback Speed",
            message: "Enter new tempo in beats per minute.",
            preferredStyle: .alert
        )
        
        controller.addTextField { textField in
            textField.placeholder = "120"
            textField.keyboardType = .decimalPad
            textField.enablesReturnKeyAutomatically = true
            
            // Tap Tempo
            var tapTempoButtonConfiguration = UIButton.Configuration.borderedTinted()
            tapTempoButtonConfiguration.buttonSize = .small
            let tapTempoButton = UIButton(configuration: tapTempoButtonConfiguration, primaryAction: UIAction(
                title: "Tap",
                handler: { _ in
                    textField.text = "120"
                }
            ))
            textField.rightView = tapTempoButton
            textField.rightViewMode = .always
        }
        
        controller.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            if let newTempoText = controller.textFields?.first?.text, let newTempoValue = Float(newTempoText) {
                let newRate = newTempoValue / 1.0
                if (newRate > 0) {
                    self.label?.text = String(newRate)
                } else {
                    self.showAlertWithTextField()
                }
            } else {
                self.showAlertWithTextField()
            }
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // ADD THIS
        #if targetEnvironment(macCatalyst)
        NSObject.prepareBridgedAlertIfNeeded(from: controller)
        #endif
        
        self.present(controller, animated: true, completion: {
            
            // ADD THIS
            #if targetEnvironment(macCatalyst)
            NSObject.presentBridgedAlertIfNeeded(from: controller)
            #endif
            
            // Do completion things here
        })
    }
    

}

