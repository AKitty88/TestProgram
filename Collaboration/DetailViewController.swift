//
//  DetailViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.

import UIKit
import Foundation
import MultipeerConnectivity

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    /// delegate (the MasterViewController)
    var delegate: TaskListProtocol!
    /// user's changes (of the particular task) are cancelled
    let sectionHeaders = ["Task", "Collaborators", "Log"]
    /// helps to find cell for the clicked textfield
    var textFieldIndexPath: IndexPath? = nil
    
    var peerlist = [MCPeerID]()
    
    /// Helps to decide which cell the actual cell is
    enum Sections: Int {
        case sectionA = 0
        case sectionB = 1
        case sectionC = 2
    }
    
    func CollaboratorClicked() {
        print ("D - CollaboratorClicked")
        let task_json = Task_Json(to_json: delegate.selectedTask!)
        delegate.sentData = task_json.json
        delegate.peerToPeer.send(data: (delegate.sentData)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Task"
        tableView.reloadData()
    }
    
    /// Gets invoked just before the view disappears
    override func viewWillDisappear(_ animated: Bool) {
        print ("D - viewWillDisappear \(String(describing: delegate.selectedTask?.title))")
        super.viewWillDisappear(true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            if delegate.selectedTask != nil {
                if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? TasknameTableViewCell {
                    delegate.SaveTask(withName: (cell.myTextLabel?.text) ?? "", history: (cell.myTextLabel?.text) ?? "")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        print ("D - viewDidLoad \(String(describing: delegate.selectedTask?.title))")
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CollaboratorTapped))
//        tap.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if peerlist != nil {
                return peerlist.count
            }
        }
        else if section == 2 {
            return (delegate.selectedTask?.logs.count)!
        }
        // else if section == 0
        else {
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return false if you do not want the specified item to be editable.
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("D - tableView cellForRowAt \(String(describing: delegate.selectedTask?.title))")
        var identifier: String
        
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Wrong section: \(indexPath.section)")
        }
        
        switch section {
        case .sectionA:
            identifier = "Detail Cell A"
        case .sectionB:
            identifier = "Detail Cell B"
        case .sectionC:
            identifier = "Detail Cell C"
        }
        
        if identifier == "Detail Cell A" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TasknameTableViewCell
            
            if let task = delegate.selectedTask {
                cell.myTextLabel.delegate = self
                cell.myTextLabel.text? = task.title
            }
            else {
                print ("missing selectedTask value")
            }
            return cell
        }
        else if identifier == "Detail Cell B" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CollaboratorTableViewCell
            
            cell.myLabel.text = peerlist[indexPath.row].displayName
            return cell
        }
        else if identifier == "Detail Cell C" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LogTableViewCell
            
            if let task = delegate.selectedTask {
                cell.dateLabel.text? = task.date                
                cell.collaboratorLabel.text? = task.logCreator[indexPath.row]
                cell.myTextLabel.delegate = self
                cell.myTextLabel.text? = task.logs[indexPath.row]
            }
            else {
                print ("missing selectedTask value")
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        print ("D - textFieldDidEndEditing \(String(describing: delegate.selectedTask?.title))")
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("D - textFieldShouldReturn \(String(describing: delegate.selectedTask?.title))")
        
        switch (textField.tag) {
        case 1:
            delegate.selectedTask?.title = (textField.text)!
            delegate.selectedTask?.taskNameChangedLog()
        case 2:
            print ("case 2")
        case 3:
            textFieldDidEndEditing(textField: textField)
            delegate.selectedTask?.logs[(textFieldIndexPath?.row)!] = (textField.text!)
        default:
            print ("default")
        }
        
        tableView.reloadData()
        delegate.SaveTask(withName: (delegate.selectedTask?.title)!, history: "")
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {            
            CollaboratorClicked()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("D - prepare for segue: ShowChatView")
        
        if segue.identifier == "ShowChatView" {
            var chatViewController: ChatViewController
            
            if let navController = segue.destination as? UINavigationController {
                chatViewController = navController.topViewController as! ChatViewController
            } else {
                chatViewController = segue.destination as! ChatViewController
            }
            chatViewController.chatDelegate = delegate
            // self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
}

