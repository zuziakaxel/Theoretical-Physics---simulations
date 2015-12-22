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





//let lab1 = LabIA(filePath: path)
//
//print("Simulating...")
//lab1.esp({
//    print("Done!")
//})


let lab2 = Lab2(filePath: path)

//for var i in (0...5) {
//    let dt = pow(10.0, Double(-i))
//    let lab2 = Lab2(filePath: "kalibracjaDT-\(i+1).dat", initials: Lab2Initial(alpha: 0.5, dt: dt, stepsNo: Int(50.0*(1/dt))) )
//    lab2.esp({
//      print("Calibration for dt \(dt) done")
//    })
//}
//let alphas = ["30", "45","60","75"]
//var index = 0
//for alpha in [0.523, 0.785, 1.046, 1.308] {
//    
//    let lab2_a = Lab2(filePath: "alpha\(alphas[index]).dat", initials: Lab2Initial(alpha: alpha/2.0, dt: 0.01, stepsNo: 5000))
//    lab2_a.esp({
//        print("Simulation for alpha \(alpha) done")
//    })
//    index++
//}
//
//let velocities = ["1","3","6"]
//index = 0
//for v in [1.0, 3.0, 6.0] {
//    
//    let lab2_a = Lab2(filePath: "v\(velocities[index]).dat", initials: Lab2Initial(alpha: 0.5, dt: 0.01, stepsNo: 5000), initialState: ParticleState(t: 0.0, phi: 1.1, z: 1.0, omega: 0.0, v: v, initial: Lab2Initial(alpha: 0.5, dt: 0.01, stepsNo: 5000)))
//    lab2_a.esp({
//        print("Simulation for v \(v) done")
//    })
//    index++
//}
//
//    let lab2_z = Lab2(filePath: "z.dat", initials: Lab2Initial(alpha: 0.5, dt: 0.01, stepsNo: 5000), initialState: ParticleState(t: 0.0, phi: 1.1, z: 200.0, omega: 0.0, v: -15.0, initial: Lab2Initial(alpha: 0.5, dt: 0.01, stepsNo: 5000)))
//lab2_z.esp({
//    print("Simulatin z done")
//})
//

//
//let lab3_1 = Lab3(filePath: "basic.dat")
//lab3_1.esp({})
//
//for var i in (0...5) {
//    let dt = pow(10.0, Double(-i))
//    let lab3 = Lab3(filePath: "kalibracjaDT-\(i+1).dat", initials: Lab3Initial(dt: dt, stepsNo: Int(50.0*(1/dt))) )
//    lab3.esp({
//      print("Calibration for dt \(dt) done")
//    })
//}




for var pr in [-1.0, 2.0, 4.0] {
    for var pphi in [-1.0, 2.0 , 4.0] {
        let dt = 0.01
        let lab3 = Lab3(filePath: "symPr\(Int(pr))_Pphi\(Int(pphi)).dat", initials: Lab3Initial(dt: dt, stepsNo: Int(50.0*(1/dt))), initialState: ParticleStateLab3(t: 0, Pphi: pphi, Pr: pr, r: 1, phi: 0.0, initial: Lab3Initial(dt: dt, stepsNo: Int(50.0*(1/dt)))))
        lab3.esp({
            print("sim for Pr=\(pr), Pphi=\(pphi) done")
        })
    }
}



















