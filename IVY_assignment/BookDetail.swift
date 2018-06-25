//
//  BookDetail.swift
//  IVY_assignment
//
//  Created by Sean Donato on 6/25/18.
//  Copyright © 2018 Sean Donato. All rights reserved.
//

import UIKit
import Alamofire
import FacebookShare
import FacebookCore

class BookDetail: UIViewController {
    
    @IBOutlet weak var titleLabelBD: UILabel!
    @IBOutlet weak var lastCheckedOutLabelBD: UILabel!
    @IBOutlet weak var tagsLabelBD: UILabel!
    @IBOutlet weak var publisherLabelBD: UILabel!
    @IBOutlet weak var authorLabelBD: UILabel!
    var bookDictionary: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "Detail"

        let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(BookDetail.facebookShare))
        
       self.navigationItem.setRightBarButton(shareButton, animated: true)

        setLabels()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabels(){
        
        if let bookTitle :String = bookDictionary["title"] as? String{
            
            titleLabelBD.text = bookTitle

        }
        if let author :String = bookDictionary["author"] as? String{

            authorLabelBD.text = author

        }
        if let publisher :String = bookDictionary["publisher"] as? String{
            
            publisherLabelBD.text = "publisher: " + publisher
            
        }
        if let tags :String = bookDictionary["categories"] as? String{
            
            tagsLabelBD.text = "tags: " + tags

        }
        
        if let lastCheckedOut :String = bookDictionary["lastCheckedOut"] as? String{

            if let lastCheckedOutBy :String = bookDictionary["lastCheckedOutBy"] as? String{
                
                if(lastCheckedOut != ""){
                    lastCheckedOutLabelBD.text = "Last checked out by " + lastCheckedOutBy
                        + "@" + lastCheckedOut
                    
                }else{
                    lastCheckedOutLabelBD.text = "never checked out"
                }
            }
        }

    }

    
    @IBAction func askForName(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter Your Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.checkout(name: firstTextField.text!)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    func checkout(name:String){
        
        if let bID = bookDictionary["id"] as? NSInteger{
            
        let bid2 = String(describing: bID)
            
    
        let urlString = URLConstants.booksURLWithQueryString + bid2
        
        let params = ["lastCheckedOutBy":name]
        
        Alamofire.request(urlString,method: .put,parameters:params, encoding:URLEncoding.httpBody).validate(statusCode:200..<300).responseJSON { response in
            
            switch response.result {
            case .success:
                
                let alertController = UIAlertController(title: "Success", message: "book added!", preferredStyle: .alert)
                //
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                
                
                print("Validation Successful")
            case .failure(let error):
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                //
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("");
                }
                
                
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
    }
        
    }
    @objc func facebookShare(){
//
//        let bookTitle = bookDictionary["title"] as? String
//
//        let urlx :URL = URL(string: "https://www.google.com")!
//
//        let shareLink = LinkShareContent.init(url: urlx, quote: bookTitle)
//
//        do{
//            try ShareDialog.show(from: self, content: shareLink)
//        }catch{
//
//        }
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
