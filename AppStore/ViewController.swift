//
//  ViewController.swift
//  AppStore
//
//  Created by Shalitha Mihiranga on 10/2/18.
//  Copyright © 2018 Shalitha Mihiranga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    //to setup table
    var appArray = [iOSApps]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        alterLayout()
        table.tableFooterView = UIView()
        
    }
    
    //setup search bar
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print(searchBar)
        
        if searchBar.text == nil || searchBar.text == "" {
            print("No search key word")
        }
        else{
            setUpApps(key: searchBar.text!)
            table.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            table.scrollToRow(at: indexPath, at: .top, animated: true)
            searchBar.text = "";
        }
    }
    
    //set values to array
    private func setUpApps(key: String) {
        appArray = []
        let formattedKey =  key.replacingOccurrences(of: " ", with: "+")
        
        let url=URL(string:"https://itunes.apple.com/search?term="+formattedKey+"&limit=50&entity=software")
        do {
            let receivedData = try Data(contentsOf: url!)
            let responseJSON = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            if let results = responseJSON["results"] as? [[String: AnyObject]] {
                for index in 0...results.count-1 {
                    
                    let result = results[index]
                    
                    let formattedPrice = result["formattedPrice"] as? String ?? "Free"
                    var dispayPrice : String
                    if formattedPrice == "Free" {
                        dispayPrice = "Free"
                    }
                    else{
                        dispayPrice = String(result["formattedPrice"] as! String)
                    }
                    
                    appArray.append(
                        iOSApps(name: result["trackName"] as! String, sellerName: result["sellerName"] as! String, price: dispayPrice, type: result["kind"] as! String, gener: result["primaryGenreName"] as! String, image: result["artworkUrl60"] as! String))
                }
            }
        }
        catch {
            print("Error")
        }
        self.searchBar.endEditing(true)
    }
    
    func alterLayout(){
        table.tableHeaderView = UIView()
        table.estimatedSectionHeaderHeight = 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appArray.count
    }
    
    //set values to table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.name.text = appArray[indexPath.row].name
        cell.sellerName.text = appArray[indexPath.row].sellerName
        cell.price.text = appArray[indexPath.row].price
        
        
        //download and set image
        let url = NSURL(string:self.appArray[indexPath.row].image)
        let imagedata = NSData.init(contentsOf: url! as URL)
        
        if imagedata != nil {
            cell.imgView.image = UIImage(data:imagedata! as Data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedApp = self.appArray[indexPath.row]
        
        print(selectedApp.name)
        
        let alertController = UIAlertController(title: selectedApp.name, message: "Type:  " + selectedApp.type , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)

    }
        
    //set table hight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //set search bar on top
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class iOSApps {
    let name: String
    let sellerName: String
    let price: String
    let type: String
    let gener: String
    let image: String
    
    init(name: String, sellerName: String, price: String, type: String, gener: String, image: String) {
        self.name = name
        self.sellerName = sellerName
        self.price = price
        self.type = type
        self.gener = gener
        self.image = image
    }
}

