//
//  ProfilePage.swift
//  GetPeached
//
//  Created by Ananth Suresh on 10/7/16.
//  Copyright © 2016 Fkboinc. All rights reserved.
//

import UIKit



class ProfilePage: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var sexField: UISegmentedControl! //sexinfields? not opposed
    
    @IBOutlet weak var sexPreference: UISegmentedControl! //sexpreference = often
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self;
        numberField.delegate = self;
        
        // Do any additional setup after loading the view.
        let savedName = UserDefaults.standard
        if let name = savedName.string(forKey: "Name"){
            finalName = name
            print(finalName)
            nameField.text = name

        }
        let savedNumber = UserDefaults.standard
        if let number = savedNumber.string(forKey: "Number"){
            finalNumber = number
            numberField.text = number

        }
        let savedSex = UserDefaults.standard
        let storedSex = savedSex.integer(forKey: "SexChosen")
        if storedSex == 0{
            finalSex = "Male"
        }
        if storedSex == 1{
            finalSex = "Female"
        }
        if storedSex != nil{
            sexField.selectedSegmentIndex = storedSex

        }
        let savedsexPreference = UserDefaults.standard
        let storedsexPreference = savedsexPreference.integer(forKey: "sexPreference")
        if storedsexPreference != nil{
            sexPreference.selectedSegmentIndex = storedsexPreference
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func onDoneClick(_ sender: AnyObject) {
        let name = UserDefaults.standard
        name.set(nameField.text, forKey: "Name")

        let number = UserDefaults.standard
        number.set(numberField.text, forKey: "Number")

        let sex = UserDefaults.standard
        sex.set(sexField.selectedSegmentIndex, forKey: "SexChosen")
        let sexPref = UserDefaults.standard
        sexPref.set(sexPreference.selectedSegmentIndex, forKey: "sexPreference")
        
    }
    
    @IBAction func onProfileClick(_ sender: UITapGestureRecognizer) {
        let profPicController = UIImagePickerController()
        profPicController.sourceType = .camera
        profPicController.delegate = self
        present(profPicController,animated:true, completion:nil)
        
        
    }
    
    func profPicControllerDidCancel(_picker:UIImagePickerController){
        dismiss(animated: true, completion:nil)
    }
    
    func profPicController(_picker:UIImagePickerController, didFinishPickingMediaInfo info: [String: AnyObject]){
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePic.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

