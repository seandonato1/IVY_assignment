//
//  BookAdder.swift
//  IVY_assignment
//
//  Created by Sean Donato on 6/22/18.
//  Copyright © 2018 Sean Donato. All rights reserved.
//

import UIKit
import Alamofire

class BookAdder: UIViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var bookTitleField: UITextField!
    @IBOutlet weak var scrollViewBA: UIScrollView!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollViewBA.delegate = self
        
        scrollViewBA.contentSize = CGSize(width: 375, height: 900) // You can set height, whatever you want.

        self.navigationItem.title = "Add Book"
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(BookAdder.doneFunction))
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = add

        let tap = UITapGestureRecognizer(target: self, action:#selector(BookAdder.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneFunction(){
        
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)

        self.navigationController?.popViewController(animated: true)
    }
    
 
    @IBAction func submitBook(_ sender: Any) {
        
        guard let bookTitle = bookTitleField.text, !bookTitle.isEmpty else{
            
            showAlert(emptyField: "a title")
            
            return
        }
        guard let author = authorField.text, !author.isEmpty  else{
            
            showAlert(emptyField: "an author")

            return
        }
        guard let publisher = publisherField.text, !publisher.isEmpty  else{
            
            showAlert(emptyField: "a publisher")

            return
        }
        guard let categories = categoriesField.text, !categories.isEmpty
            else{
            
            showAlert(emptyField: "a category")

            
            return
        }
     
        submitNewBook(title: bookTitle, author: author, publisher: publisher, categories: categories)

    }
    
    
    func submitNewBook(title: String, author: String, publisher: String, categories: String){
        
        
        let urlString = URLConstants.booksURL
        
        let params = ["title":title,"author":author,"publisher":publisher,"categories":categories]
        Alamofire.request(urlString,method: .post,parameters:params, encoding:URLEncoding.queryString).validate(statusCode:200..<300).responseJSON { response in
            
            switch response.result {
            case .success:

                let alertController = UIAlertController(title: "Success", message: "book added!", preferredStyle: .alert)
                //
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    self.doneFunction();
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
    
    
    func showAlert(emptyField: String){
      
        let emptyFieldMessage = "Please enter " + emptyField
        let alertController = UIAlertController(title: "Error", message: emptyFieldMessage, preferredStyle: .alert)
        //
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("");
        }
        
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
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
