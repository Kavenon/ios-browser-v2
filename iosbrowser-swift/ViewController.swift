//
//  ViewController.swift
//  iosbrowser-swift
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var navLabel: UILabel!
    
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var newButton: UIButton!
    @IBOutlet var stepper: UIStepper!
    
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var artistInput: UITextField!
    @IBOutlet var titleInput: UITextField!
    @IBOutlet var genreInput: UITextField!
    @IBOutlet var yearInput: UITextField!
    
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
    
    @IBAction func previousButtonAction(sender: AnyObject) {
        
        if(self.currentIndex > 0){
            
            if(!self.newElementCreating){
                self.currentIndex--;
            }
            
            self.editNthElement(self.currentIndex);
            if(self.currentIndex == 0){
                self.previousButton.enabled = false;
            }
        }
        
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
            
            self.loadFirstOrNew();
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
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        
        
        if((self.albums?.count)!-1 < self.currentIndex+1){
            self.newElement();
        }
        else {
            self.currentIndex++;
            self.editNthElement(self.currentIndex);
            self.previousButton.enabled = true;
        }
                
    }
    @IBAction func deleteAction(sender: AnyObject) {
        
        if(!self.newElementCreating){
            self.albums!.removeObjectAtIndex(self.currentIndex);
        }
        
        self.loadFirstOrNew();
        
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
        self.newButton.enabled = false;
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
            self.previousButton.enabled = false;
        }
        else {
            self.newElement();
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        albums = NSMutableArray(contentsOfFile:plistCatPath!);

        if(albums!.count > 0){
            self.editNthElement(self.currentIndex);
        }
        
        self.previousButton.enabled = false;
        
        
    }
      func newElement(){
        
        self.ratingLabel.text = "";
        self.artistInput.text = "";
        self.titleInput.text = "";
        self.genreInput.text = "";
        self.yearInput.text = "";
        self.stepper.value = 0.0;
        navLabel.text = "New element";
        
        self.deleteButton.enabled = true;
        self.newElementCreating = true;
        self.newButton.enabled = false;
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
        
        self.updateNavLabel();
        self.newButton.enabled = true;
        self.deleteButton.enabled = true;
        self.saveButton.enabled = false;
        self.newButton.enabled = true;
        self.newElementCreating = false;
    }
    
    func updateNavLabel(){
        navLabel.text = "Record \(self.currentIndex+1) of \(self.albums!.count)";
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

