//
//  Lab4.swift
//  Lab1
//
//  Created by Axel Zuziak on 22.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved.
//

import Foundation


/*

    sp "..." u 1:2:3 w l / w pm 3d (gnuplot 3D)


    (x,y,z) = (i,j,k) 

    Na bokach wstawiamy wartosci elektrod lub 0.


    Zrobic wykres phi(nz)
*/

/**
*  Encapsulating position in 3-dimensional space.(x,y,z) = (i,j,k)
*/
struct Vector {
    var i = 0.0
    var j = 0.0
    var k = 0.0

    init(i: Double, j: Double, k: Double) {
        self.i = i
        self.j = j
        self.k = k
    }
    
    init() {
        
    }
}

/// Initial parameters
struct Initial {
    let size = Vector(i: 51, j: 51, k: 26) // nanometers
}

struct Potential {
    var point = Vector(i: 0, j: 0, k: 0)
    var value = 0.0
}

struct Electrode {
    var bl: Vector = Vector()
    var br: Vector = Vector()
    var tl: Vector = Vector()
    var tr: Vector = Vector()
    
    init(bl: Vector, br: Vector, tl: Vector, tr: Vector) {
        self.bl = bl
        self.br = br
        self.tl = tl
        self.tr = tr
    }
}

/// Initial parameters
let parameters = [
    "dx": 10,
    "dy": 10,
    "dz": 10,
    "nx": 51,
    "ny": 51,
    "nz": 26,
    "kqw": 10,
    "ke": 15
]

//let electrodes = [
//    Electrode(corners: [Vector(i: 0.0, j: 400, k: 0.0), Vector(i: 0.0, j: 200, k: 0.0), ]),
//    
//
//]


class Lab4 {
    var phi: [Potential] = Array(count: 51*51*26, repeatedValue: Potential())
    var previousPhi: [Potential] = Array(count: 51*51*26, repeatedValue: Potential())
    var electrodes: [Electrode] = []
    
    
    func simulate(completion: () -> Void) {
        phi = Array(count: 51*51*26, repeatedValue: Potential())
        previousPhi = Array(count: 51*51*26, repeatedValue: Potential())
        
        
        
    }
    
    
    
    
    private func fillElectrodes() {
        for
    }
    
    
    func esp(completion: () -> Void) {
        simulate({
            completion()
        })
    }
}






