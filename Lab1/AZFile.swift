//
//  AZFile.swift
//  Lab1
//
//  Created by Axel Zuziak on 01.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved.
//

import Foundation


struct AZTextFile {
    var file: UnsafeMutablePointer<FILE>!
    
    init(file: UnsafeMutablePointer<FILE>) {
        self.file = file
    }
    
    init(filePath: String, option: Option) {
        self.file = fopen(filePath, option.rawValue)
    }
    
    enum Option: String {
        case Read = "r"
        case Write = "w"
    }
    
    func read() -> String {
        guard file != nil else {
            return ""
        }
        // change the buffer size at your needs
        let buffer = [CChar](count: 10, repeatedValue: 0)
        var string = String()
        while fgets(UnsafeMutablePointer(buffer), Int32(buffer.count), file) != nil {
            if let read = String.fromCString(buffer) {
                string += read
            }
        }
        return string
    }
    
    func write(text: String) {
        guard file != nil else {
            return
        }
        fputs(text, file)
    }
    
}