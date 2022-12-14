//
//  AlertBridge.swift
//  AppKitBridge
//
//  Created by Nitin Seshadri on 11/26/22.
//

import Cocoa

typealias AlertHandler = @convention(block) (NSObject) -> Void

@objc class AlertBridge: NSObject {

    @objc(presentNSAlertWithTitle:message:actions:textFields:completion:) func presentNSAlert(title: String, message: String, actions: [NSObject], textFields: [NSObject], completion: @escaping () -> Void) {
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        
        for action in actions {
            let actionTitle = action.value(forKey: "title") as! String
            
            alert.addButton(withTitle: actionTitle)
        }
        
        var bridgedTextFields: [NSTextField] = []
        
        if (textFields.count > 0) {
            let textFieldStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 228, height: (30*textFields.count)))
            textFieldStack.orientation = .horizontal
            textFieldStack.alignment = .centerX
            
            for (index, element) in textFields.enumerated() {
                let bridgedTextField = NSTextField()
                bridgedTextField.bezelStyle = .roundedBezel
                
                bridgedTextField.placeholderString = (element.value(forKey: "placeholder") as? String) ?? nil
                
                textFieldStack.addView(bridgedTextField, in: .bottom)
                bridgedTextFields.append(bridgedTextField)
                
                if (index == 0) {
                    alert.window.initialFirstResponder = bridgedTextField
                }
            }
            
            alert.accessoryView = textFieldStack
        }
        
        guard let window = NSApplication.shared.keyWindow else { return }
        
        alert.beginSheetModal(for: window) { response in
            // 1. Populate Text Fields
            if (textFields.count > 0) {
                for (index, element) in textFields.enumerated() {
                    let bridgedTextFieldValue = bridgedTextFields[index].stringValue
                    element.setValue(bridgedTextFieldValue, forKey: "text")
                }
            }
            
            // 2. Return to UIKit
            completion()
            
            // 3. Call Handlers
            switch (response) {
            case .alertFirstButtonReturn:
                if (actions.count > 0) {
                    if let block = actions[0].value(forKey: "handler") {
                        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
                        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
                        handler(actions[0])
                    }
                }
                break
            case .alertSecondButtonReturn:
                if (actions.count > 1) {
                    if let block = actions[1].value(forKey: "handler") {
                        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
                        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
                        handler(actions[1])
                    }
                }
                break
            case .alertThirdButtonReturn:
                if (actions.count > 2) {
                    if let block = actions[2].value(forKey: "handler") {
                        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
                        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
                        handler(actions[2])
                    }
                }
                break
            default:
                break
            }
        }
        
    }
    
}
