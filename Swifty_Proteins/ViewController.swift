//
//  ViewController.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/25.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit

var selectedCell : String?

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchInfo = [String]()
    var searching = false
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInfo = infoList.infoArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchInfo.count
        } else {
            return infoList.infoArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchInfo[indexPath.row]
        } else {
            cell?.textLabel?.text = infoList.infoArr[indexPath.row]
        }
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
            tblView.reloadData()
    }
    //////////// To make cell 'selectable'
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sceneView:SceneViewController = self.storyboard?.instantiateViewController(withIdentifier: "SceneView") as! SceneViewController

        if tblView.cellForRow(at: indexPath) != nil{
            if searching {
                selectedCell = searchInfo[indexPath.row]
                print(selectedCell as Any)
                self.navigationController?.pushViewController(sceneView, animated: true)
            } else {
                selectedCell = infoList.infoArr[indexPath.row]
                print(selectedCell as Any)
                self.navigationController?.pushViewController(sceneView, animated: true)
            }
        }
    }
    ///////////
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

