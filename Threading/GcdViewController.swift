//
//  GcdViewController.swift
//  Threading
//
//  Created by iim jobs on 21/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class GcdViewController: UITableViewController {

    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.timeInterval(data: data)
                }
            }
        }
        
    }
    
// MARK: Parse the JSON
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
// MARK: Calculate time interval
    func timeInterval(data: Data) {
        let start = DispatchTime.now()
        
        parse(json: data)
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("GCD - time = \(timeInterval)")
    }

}

// MARK: TableView datasource
extension GcdViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGcd", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
}
