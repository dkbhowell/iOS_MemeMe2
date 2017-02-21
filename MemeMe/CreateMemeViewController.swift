//
//  CreateMemeViewController.swift
//  MemeMeSandBox
//
//  Created by Dustin Howell on 2/2/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var nightModeToggleButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    
    // Properties
    var nightMode = true
    
    // Colors (for night mode implementation)
    let darkBarColor = UIColor(colorLiteralRed: 56/255, green: 68/255, blue: 79/255, alpha: 1)
    let darkIconColor = UIColor(colorLiteralRed: 142/255, green: 201/255, blue: 235/255, alpha: 1)
    
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40) as Any,
        NSStrokeWidthAttributeName: -3.0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable camera button if device does not have a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // setup delegates
        topMemeText.delegate = self
        bottomMemeText.delegate = self
        
        // setup font styles
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        topMemeText.textAlignment = .center
        bottomMemeText.textAlignment = .center
        
        navigationController?.navigationBar.barTintColor = nightMode ? darkBarColor : darkIconColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Actions
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            activity, success, items, error in
            _ = Meme(topText: self.topMemeText.text!, bottomText: self.bottomMemeText.text!, originalImage: self.imageView.image!, memedImage: memeImage)
        }
        self.present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func toggleNightMode(_ sender: UIBarButtonItem) {
        nightMode = !nightMode
        let barColor: UIColor
        let iconColor: UIColor
        if nightMode {
            barColor = darkBarColor
            iconColor = darkIconColor
        } else {
            barColor = darkIconColor
            iconColor = darkBarColor
        }
        navigationController?.navigationBar.barTintColor = barColor
        bottomToolbar.barTintColor = barColor
        shareButton.tintColor = iconColor
        nightModeToggleButton.tintColor = iconColor
        cancelButton.tintColor = iconColor
        cameraButton.tintColor = iconColor
        albumButton.tintColor = iconColor
    }
    
    @IBAction func resetUI(_ sender: UIBarButtonItem) {
        imageView.image = UIImage(named: "default_image")
        topMemeText.text = "TOP"
        bottomMemeText.text = "BOTTOM"
    }
    
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            for constraint in imageView.constraints {
                print(constraint)
            }
        }
        dismiss(animated: true, completion: nil)
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        return
    }
    
    // MARK: Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let currentText = textField.text
        if currentText == "TOP" || currentText == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Notification methods
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // detect if the bottom text field is being edited
        if bottomMemeText.isEditing {
            let userInfo = notification.userInfo!
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        // do not move view up if the bottom text field is not being edited
        return 0
    }
    
    // MARK: Utility Functions
    
    func generateMemedImage() -> UIImage {
        // hide toolbar on bottom
        bottomToolbar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // capture the memed image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar
        bottomToolbar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        return memedImage
    }
}






