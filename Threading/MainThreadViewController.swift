//
//  MainThreadViewController.swift
//  Threading
//
//  Created by iim jobs on 21/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class MainThreadViewController: UITableViewController{
    
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                timeInterval(data: data)
            }
        }
    }

// MARK: Calculate the time Interval
    func timeInterval(data: Data) {
        let start = DispatchTime.now()
        
        parse(json: data)
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Main thread - time = \(timeInterval)")
    }
    
// MARK: Pase the JSON
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
}

// MARK: TableView datasource
extension MainThreadViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMain", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
}
