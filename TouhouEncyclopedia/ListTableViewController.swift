//
//  ListTableViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/07/09.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var listTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.delegate = self
        listTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: "Icon/charWinIcon.jpg")
        
        let textLabel = cell.viewWithTag(2) as! UILabel
        textLabel.text = "test"
        
        return cell
    }
}
