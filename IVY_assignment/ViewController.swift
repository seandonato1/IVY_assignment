//
//  ViewController.swift
//  IVY_assignment
//
//  Created by Sean Donato on 6/20/18.
//  Copyright © 2018 Sean Donato. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents
import SwiftyJSON

private var booksArray = [Dictionary<String, Any>]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tableViewBooks: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return booksArray.count
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell

        var bookDict = booksArray[indexPath.row] as Dictionary
        
        if let title = bookDict["title"] as? String {
            
            cell.topLabelBC.text = title as String
            
            // When we get here, we know "ID" is a valid key
            // and that the value is a String.
        }
        if let author = bookDict["author"] as? String {
            
            cell.bottomLabelBC.text = author as String
            
            // When we get here, we know "ID" is a valid key
            // and that the value is a String.
        }
        

        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
        var bookDict = booksArray[indexPath.row] as Dictionary
            
        if let bookID = bookDict["id"] as? NSInteger {
            
            let idString = String(bookID)

            deleteBook(bookID: idString)

            }
        }
    }


    override func viewDidLoad() {
        
      //  self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationItem.title = "My Books"
        
        var appBar = MDCAppBar()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addBook))
        
        let deleteAll = UIBarButtonItem(title: "delete all", style: .plain, target: self, action: #selector(ViewController.deleteAllBooks))
        self.navigationItem.setLeftBarButton(add, animated: true)
        self.navigationItem.setRightBarButton(deleteAll, animated: true)

       // self.addChildViewController(appBar.headerViewController)

        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        tableViewBooks.rowHeight = 69
        
        super.viewDidLoad()
        //self.getBooks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        getBooks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBooks() {
        
       activityView.isHidden = false
       activityIndicator.startAnimating()
        Alamofire.request(URLConstants.booksURL,method: .get,encoding:URLEncoding.queryString).validate(statusCode:200..<300).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                self.activityView.isHidden = true
                self.activityIndicator.stopAnimating()
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let data = response.result.value as! NSArray
                    
                    if let booksArr = data as? [Dictionary<String, Any>]
                    {
                        booksArray = data as! [Dictionary<String, Any>]
                    
                        self.tableViewBooks.reloadData()
                    }
                }
                print("Validation Successful")
            case .failure(let error):
                
                self.activityView.isHidden = true
                self.activityIndicator.stopAnimating()

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

//        Alamofire.request(URLConstants.booksURL).responseJSON { (responseData) -> Void in
//            if((responseData.result.value) != nil) {
//                let swiftyJsonVar = JSON(responseData.result.value!)
//                let data = responseData.result.value as! NSArray
//
//                booksArray = data as! [Dictionary<String, Any>]
//
//                var xx = booksArray
//
//                print(swiftyJsonVar)
//                self.tableViewBooks.reloadData()
//            }
//        }



   // }

    func postBooks(){
    
    
        let newTodo: [String: Any] = ["author": "Ash Maurya",
                                      "categories": "process",
                                      "title": "Running Lean",
                                      "publisher": "O'REILLY"]


        Alamofire.request(URLConstants.booksURL,method: .post, parameters: newTodo,encoding:URLEncoding.httpBody, headers: nil).responseString { response in
            debugPrint(response)
        }
}

    func deleteBook(bookID: String){
        
        let urlString = URLConstants.booksURLWithQueryString + bookID
        
        Alamofire.request(urlString,method: .delete,encoding:URLEncoding.queryString).validate(statusCode:200..<300).responseJSON { response in
            
            switch response.result {
            case .success:
                self.getBooks()
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
    
    @objc func addBook(){
        
        let myViewController = BookAdder(nibName: "BookAdder", bundle: nil)

        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)

        self.navigationController!.pushViewController(myViewController, animated: true)

    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            
            let bookDict = booksArray[indexPath.row]
            
            let detailsVC = BookDetail(nibName: "BookDetail", bundle: nil)
            
      
            detailsVC.bookDictionary = bookDict
   

            self.navigationController?.pushViewController(detailsVC, animated: true)
            
        
    }
    
    @objc func deleteAllBooks(){
        
        let alertController = UIAlertController(title: "delete all books?", message: nil, preferredStyle: .alert)
        //
  
   
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            self.deleteAllCall()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(action2)

        alertController.addAction(action1)

        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func deleteAllCall(){
        
        let urlString = URLConstants.deleteBooks
    Alamofire.request(urlString,method: .delete,encoding:URLEncoding.queryString).validate(statusCode:200..<300).responseJSON { response in
            
            switch response.result {
            case .success:
                self.getBooks()
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

//
//let data = response.result.value as! NSArray
//booksArray = data as! [Dictionary<String, Any>]

