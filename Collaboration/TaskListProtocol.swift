//
//  TaskListProtocol.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//

import Foundation

/// Protocol to which MasterViewController must conform
protocol TaskListProtocol {
    /// the section of the task which is selected at the moment
    var selectedItemSection: Int? {get}
    /// the index of the task which is selected at the moment
    var selectedItemIndex: Int? {get}
    /// the task which is selected at the moment
    var selectedTask: Task? {get}
    
    var sentData: Data? {get set}
    
    var peerToPeer: PeerToPeerManager {get}
    
    /**
     Saves the task that is being edited
     - parameter task : description of task
     - parameter history : log
     */
    func SaveTask(withName task: String, history log: String)
 
    /// cancels the editing of the current task
    func Cancel()
}

