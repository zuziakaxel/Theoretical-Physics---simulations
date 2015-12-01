//
//  ShellCommands.swift
//  Lab1
//
//  Created by Axel Zuziak on 01.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved.
//

import Foundation


enum Command: String {
    case Gnuplot = "/usr/local/bin/gnuplot"
}

func executeCommand(command: Command, args: [String]) -> String {
    return executeCommand(command.rawValue, args: args)
}

func executeCommand(command: String, args: [String]) -> String {
    
    let task = NSTask()
    
    task.launchPath = command
    task.arguments = args
    
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String! = NSString(data: data, encoding: NSUTF8StringEncoding) as String!
    
    return output
}
