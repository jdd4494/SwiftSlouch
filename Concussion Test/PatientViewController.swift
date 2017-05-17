//
//  PatientViewController.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/3/16.
//  Copyright (c) 2016 Slouch Design. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: [Properties]
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var sportPickerTextField: UITextField!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    fileprivate var _sport      : Int = 0;
    fileprivate var _tempSport  : Int = 0;
    
    var patient : Patient?
    var pickerDataSource = ["Baseball", "Basketball", "Football", "Hockey", "Lacrosse", "Soccer", "Swimming", "Tennis", "Track", "Wrestling"]
    
    fileprivate let _sportsPickerView:UIPickerView = UIPickerView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Handle the text field's user input through delegate callbacks
        firstNameTextField.delegate = self;
        lastNameTextField.delegate = self;
        
        // UI Picker View That Opens Up To Select Sport
        _sportsPickerView.backgroundColor = .white;
        _sportsPickerView.delegate = self;
        _sportsPickerView.dataSource = self;
        
        // UI Picker View Tool Bar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sportPickerTextField.inputView = _sportsPickerView;
        sportPickerTextField.inputAccessoryView = toolBar;
        
        // Fills Out Existing Patient Data
        if let patient = patient {
            navigationItem.title = patient.firstName + " " + patient.lastName;
            firstNameTextField.text = patient.firstName;
            lastNameTextField.text = patient.lastName;
            photoImageView.image = patient.photo;
            ratingControl.rating = patient.rating;
            sportPickerTextField.text = pickerDataSource[patient.sport.rawValue];
        }
        
        // Enable the Save button only if the text field has a valid Patient name.
        checkValidPatientName();
    }
    
    // MARK: [UIPickerView]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // patient.sport = row;
        sportPickerTextField.text = pickerDataSource[row];
        _tempSport = row;
    }
    
    func cancelPicker(){
        sportPickerTextField.resignFirstResponder()
        print("cancel UIPICKER " + String(_sport));
    }
    
    func donePicker(){
        _sport = _tempSport
        sportPickerTextField.resignFirstResponder()
        print("done UIPICKER " + String(_sport));
    }
    
    // MARK: [UITextFieldDelegate]
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide The Keyboad
        textField.resignFirstResponder();
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable Save Button While Editing
        saveButton.isEnabled = false;
    }
    
    func checkValidPatientName(){
        // Disable the Save Button If The Text Field Is Empty
        let firstNameText = firstNameTextField.text ?? "";
        let lastNameText = lastNameTextField.text ?? "";
        
        saveButton.isEnabled = !(firstNameText.isEmpty || lastNameText.isEmpty);
    }
    
    // LEFT OFF HERE!!!!
    // STEP 4.
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidPatientName();
        navigationItem.title = textField.text;
    }

    // MARK: [Navigation]
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as AnyObject? === saveButton) {
            let firstName = firstNameTextField.text ?? "";
            let lastName = lastNameTextField.text ?? "";
            let photo = photoImageView.image;
            let rating = ratingControl.rating;
            
            // Set The Patient To Be Passed To PatientTableViewController after unwind segment
            patient = Patient(firstName: firstName,lastName: lastName, photo:photo, rating:rating, sport:_sport);
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddPatientMode = presentingViewController is UINavigationController;
        
        if(isPresentingInAddPatientMode){
            dismiss(animated: true, completion: nil);
        }else{
            navigationController!.popViewController(animated: true);
        }
    }
    
    // MARK: [Actions]
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // [Hides Keyboard]
        firstNameTextField.resignFirstResponder();
        lastNameTextField.resignFirstResponder();
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController();
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary;
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self;
        
        present(imagePickerController, animated: true, completion: nil);
    }
   
 
    // MARK: [UIImagePickerControllerDelegate]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage;
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil);
    }

}

