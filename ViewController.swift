//
//  ViewController.swift
//  Expandable table view
//
//  Created by Adil Anjum Khan on 22/06/2023.
//

import UIKit

struct Topic
{
    var sectionHeader:String
    var isExpanded:Bool
    var keyPoints:[String]
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var topics:[Topic]=[
        Topic(sectionHeader: "IOS", isExpanded: false, keyPoints: ["UI","Swift"]),
        Topic(sectionHeader: "Android", isExpanded: false, keyPoints: ["UI","Kotlin"]),
        Topic(sectionHeader: "Design Patern", isExpanded: false, keyPoints: ["MVC","Delegate"]),
        Topic(sectionHeader: "Machine Laerning", isExpanded: false, keyPoints: ["Regresion Learning","Alpha Beta Proning"])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(topics[section].isExpanded==true)
        {
            return topics[section].keyPoints.count+1
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row==0)
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = topics[indexPath.section].sectionHeader
            cell?.backgroundColor=UIColor.blue
            cell?.textLabel?.textColor = .white
            return cell!
        }
        else
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text=topics[indexPath.section].keyPoints[indexPath.row-1]
            cell?.backgroundColor=UIColor.gray
            cell?.textLabel?.textColor = .black
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0)
        {
            if(topics[indexPath.section].isExpanded)
            {
                topics[indexPath.section].isExpanded=false
            }
            else
            {
                topics[indexPath.section].isExpanded=true
            }
            let section=IndexSet.init(integer:indexPath.section)
            tableView.reloadSections(section, with: .none)
        }
    }

}

