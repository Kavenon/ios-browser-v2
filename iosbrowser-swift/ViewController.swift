//
//  ViewController.swift
//  iosbrowser-swift
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var navLabel: UILabel!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet var stepper: UIStepper!
    
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var artistInput: UITextField!
    @IBOutlet var titleInput: UITextField!
    @IBOutlet var genreInput: UITextField!
    @IBOutlet var yearInput: UITextField!
    
    var apiNewElement = false;
    var apiEditElement = false;
    var apiEditRow = 0;
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        print("cancled");
    }
    
    @IBAction func stepperAction(sender: AnyObject) {
        
        if(stepper.value > 5.0){
            stepper.value = 5.0;
        }
        else if(stepper.value < 0.0){
            stepper.value = 0.0;
        }
        self.ratingLabel.text = "\(Int(stepper.value))";
        
        self.saveButton.enabled = true;
        
    }
    
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        if(self.newElementCreating){
            let newElement: NSMutableDictionary? = [
                "rating" : self.ratingLabel.text!,
                "artist" : self.artistInput.text!,
                "title" : self.titleInput.text!,
                "genre" : self.genreInput.text!,
                "date" : self.yearInput.text!
            ];
            
            self.albums!.addObject(newElement!);
            
        }
        else {
            let album = self.albums![self.currentIndex] as! NSMutableDictionary;
            album.setValue(Int(self.ratingLabel.text!), forKey: "rating");
            album.setValue(self.artistInput.text, forKey: "artist");
            album.setValue(self.titleInput.text, forKey: "title");
            album.setValue(self.genreInput.text, forKey: "genre");
            album.setValue(Int(self.yearInput.text!), forKey: "date");
        }
        self.saveButton.enabled = false;
       
        
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        
        if(!self.newElementCreating){
            self.albums!.removeObjectAtIndex(self.currentIndex);
        }
        
    }
    
    @IBAction func stepperChanged(sender: AnyObject) {
        self.saveButton.enabled = true;
    }
    
    @IBAction func artistChange(sender: AnyObject) {
        self.saveButton.enabled = true;
    }
    @IBAction func titleChange(sender: AnyObject) {
        self.saveButton.enabled = true;
    }
    
    @IBAction func genreChange(sender: AnyObject) {
        self.saveButton.enabled = true;
    }
   
    @IBAction func yearChange(sender: AnyObject) {
        self.saveButton.enabled = true;
    }
    
    @IBAction func newButtonAction(sender: AnyObject) {
        self.saveButton.enabled = false;
        newElement();
    }
    
    let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
    
    var albums: NSMutableArray?
    var currentIndex = 0;
    var newElementCreating = false;
    
    func loadFirstOrNew(){
        if(self.albums!.count > 0){
            self.editNthElement(0);
        }
        else {
            self.newElement();
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if albums == nil {
           albums = NSMutableArray(contentsOfFile:plistCatPath!);
        }
       
        
        if(self.apiNewElement){
            self.newElement();
        }
        else if(self.apiEditElement){
            self.editNthElement(self.apiEditRow);
        }
        
    }
      func newElement(){
        
        self.ratingLabel?.text = "";
        self.artistInput?.text = "";
        self.titleInput?.text = "";
        self.genreInput?.text = "";
        self.yearInput?.text = "";
        self.stepper?.value = 0.0;
        navLabel?.text = "New element";
        
        self.deleteButton?.enabled = true;
        self.newElementCreating = true;
       
    }
       
    func editNthElement(index : Int){
        
        let album = self.albums![index];
        self.currentIndex = index;
        
        self.artistInput.text = album["artist"] as? String;
        self.titleInput.text = album["title"] as? String;
        self.genreInput.text = album["genre"] as? String;
        
        if let date = album["date"] {
            self.yearInput.text = "\(date!)";
        }
        if let rating = album["rating"] {
            self.ratingLabel.text = "\(rating!)";
        }
     
        self.stepper.value = (album["rating"]??.doubleValue)!;
      
        self.deleteButton.enabled = true;
        self.saveButton.enabled = false;        
        self.newElementCreating = false;
    }
    
    
    
    func persistToPlist(){
        print("saving");
        albums!.writeToFile(plistCatPath!, atomically: true);
        print("saved");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

