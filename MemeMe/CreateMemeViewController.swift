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
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var containerView: UIView!

    // MARK: Properties
    var nightMode = true
    var rootFrameY: CGFloat = 0
    var keyboardShow = false
    
    // Colors (for night mode implementation)
    let darkBarColor = UIColor(colorLiteralRed: 56/255, green: 68/255, blue: 79/255, alpha: 1)
    let darkIconColor = UIColor(colorLiteralRed: 142/255, green: 201/255, blue: 235/255, alpha: 1)
    
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40) as Any,
        NSStrokeWidthAttributeName: -3.0
    ]

    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        // setup font styles
        topMemeText.configure(delegate: self, defaultAttributes: memeTextAttributes)
        bottomMemeText.configure(delegate: self, defaultAttributes: memeTextAttributes)
        topMemeText.textAlignment = .center
        bottomMemeText.textAlignment = .center
        // choose color scheme
        navigationController?.navigationBar.barTintColor = nightMode ? darkBarColor : darkIconColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CreateMemeController ViewWillAppear")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootFrameY = view.frame.origin.y
        print("rootFrameY is : \(rootFrameY)")
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Actions
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        pickImageFromSource(sourceType: .photoLibrary)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        pickImageFromSource(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            activity, success, items, error in
            let meme = Meme(topText: self.topMemeText.text!, bottomText: self.bottomMemeText.text!, originalImage: self.imageView.image!, memedImage: memeImage)
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            self.dismiss(animated: true)
        }
        self.present(shareController, animated: true)
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
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
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
    
    // MARK: Notification methods
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        print("keyboard will show")
        if keyboardShow == false {
            rootFrameY = view.frame.origin.y
            let newY = rootFrameY - getKeyboardHeight(notification)
            print("newY is : \(newY)")
            view.frame.origin.y = newY
        }

        keyboardShow = true
    }
    
    func keyboardWillHide(_ notification: Notification) {
        print("kebyoard will hide")
        if keyboardShow == true {
            view.frame.origin.y = rootFrameY
        }
        keyboardShow = false
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
    private func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(memeView.frame.size)
        memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: { self.shareButton.isEnabled = true })
    }
}






