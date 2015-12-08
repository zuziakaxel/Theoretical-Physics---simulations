//
//  main.swift
//  Lab1
//
//  Created by Axel Zuziak on 01.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved.
//

import Foundation




print("Hello")
let cli = CommandLine()

let filePath = StringOption(shortFlag: "f", longFlag: "file", required: false,
    helpMessage: "Path to the output file.")
cli.addOption(filePath)

do {
    try cli.parse()
    
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

var path = ""
if filePath.value != nil {
    path = filePath.value!
} else {
    path = "wyniki.dat"
}

print("Results file path: \(path)")




//let lab1 = LabIA(filePath: path)
//
//print("Simulating...")
//lab1.esp({
//    print("Done!")
//})


let lab2 = Lab2(filePath: path)

print("simulating")
lab2.esp({
    print("Done, results saved")
})

//lab2.execute(Lab2Initial(alpha: <#T##Double#>, dt: <#T##Double#>, stepsNo: <#T##Int#>), initialState: <#T##[ParticleState]#>)



