//
//  NSObject+AlertBridgeSupport.swift
//  CatalystNSAlertTextField
//
//  Created by Nitin Seshadri on 11/27/22.
//

import Foundation
import UIKit

#if targetEnvironment(macCatalyst)
extension NSObject {
    @objc(presentNSAlertWithTitle:message:actions:textFields:completion:) func presentNSAlert(title: String, message: String, actions: [NSObject], textFields: [NSObject], completion: @escaping () -> Void) {
    }
    
    class func prepareBridgedAlertIfNeeded(from controller: UIAlertController) {
        if (controller.preferredStyle == .alert && (controller.textFields?.count ?? 0) > 0 && controller.actions.count <= 3) {
            if NSClassFromString("AppKitBridge.AlertBridge") is NSObject.Type {
                controller.view.isHidden = true
            } else {
                NSLog("[AlertBridge] Could not initialize AlertBridge. Is the AppKit bridge bundle loaded?")
            }
        }
    }
    
    class func presentBridgedAlertIfNeeded(from controller: UIAlertController) {
        if (controller.preferredStyle == .alert && (controller.textFields?.count ?? 0) > 0 && controller.actions.count <= 3) {
            if let ab = NSClassFromString("AppKitBridge.AlertBridge") as? NSObject.Type {
                controller.view.isHidden = true
                
                let alertBridge = ab.init()
                
                alertBridge.presentNSAlert(title: controller.title ?? "", message: controller.message ?? "", actions: controller.actions, textFields: controller.textFields ?? [], completion: {
                    controller.dismiss(animated: false)
                })
            } else {
                NSLog("[AlertBridge] Could not initialize AlertBridge. Is the AppKit bridge bundle loaded?")
            }
        }
    }
}
#endif
