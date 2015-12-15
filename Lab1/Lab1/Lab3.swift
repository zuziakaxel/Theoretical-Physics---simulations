//
//  Lab2.swift
//  Lab1
//
//  Created by Axel Zuziak on 08.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved./Users/zuziakaxel/Library/Mobile Documents/com~apple~CloudDocs/Semestr5/FT_LAB/Lab2/plots/skrypt.plot
//

import Foundation
/**
 *   w sprawozdaniu:
 Dobrac dt, tak aby wykres energii byl dobry
Wyniki dla roznych wartosci poczatkowych (wybieramy trzy paramtery (poczatkowe)) phi(0), r(0), pr(0) albo pphi(0), B
Dla kazdej z wielkosci co najmniej 4 wartosci.
Uwaaga na r->0
Uwaga na skale w gnuplocie (set size ratio -1) // to da 1:1

 */

private let G = 9.82

struct Lab3Initial {
    let m: Double
    let e: Double
    let B: Double
    let dt: Double
    let stepsNo: Int
    
    init(m: Double=1, e: Double=1, B: Double=1, dt: Double, stepsNo: Int) {
        self.m = m
        self.e = e
        self.B = B
        self.dt = dt
        self.stepsNo = stepsNo
    }
}

struct ParticleStateLab3 {
    var t: Double
    var Pphi: Double
    var Pr: Double
    var r: Double
    var phi: Double
    var E: Double = 0.0
    let initial: Lab3Initial
    
    init(t: Double, Pphi: Double, Pr: Double, r: Double, phi: Double, initial: Lab3Initial) {
        self.t = t
        self.phi = phi
        self.r = r
        self.Pr = Pr
        self.Pphi = Pphi
        self.initial = initial
        let first = 0.5*initial.m*(pow(Pr,2) + pow(Pphi/r, 2))
        let second =  Pphi*(initial.e*initial.B)/(2*initial.m)*(-1)
        let third = (pow(initial.e*initial.B*r,2)/8*initial.m)
        self.E = first + second + third
    }
    
    init(previousState state: ParticleStateLab3, initial: Lab3Initial) {
        self.initial = initial
        self.t = state.t + initial.dt
        self.Pphi = state.Pphi
        self.phi = state.phi + initial.dt*((state.Pphi/(initial.m*pow(state.r,2))) - (initial.e*initial.B)/(2*initial.m))
        self.r = state.r + (state.Pr/initial.m)*initial.dt
        
        self.Pr = state.Pr + ((pow(state.Pphi,2))/(initial.m*pow(self.r,3)) - pow(initial.e,2)*self.r*pow(initial.B,2)/(4*initial.m))*initial.dt
        let first = 0.5*initial.m*(pow(Pr,2) + pow(Pphi/r, 2))
        let second =  Pphi*(initial.e*initial.B)/(2*initial.m)*(-1)
        let third = (pow(initial.e*initial.B*r,2)/8*initial.m)
        self.E = first + second + third
    }
}

class Lab3: Exercise {
    
    var data: [ParticleStateLab3] = []
    
    var filePath: String = ""
    
    init(filePath: String, initials: Lab3Initial? = nil, initialState: ParticleStateLab3? = nil) {
        self.filePath = filePath
        self.initials = initials == nil ? Lab3Initial(dt: 0.01, stepsNo: 5000) : initials!
        self.initialState = initialState == nil ? ParticleStateLab3(t: 0, Pphi: 1.1, Pr: 1.0, r: 1.0, phi: 0.0, initial: self.initials) : initialState!
    }
    
    let initialState: ParticleStateLab3
    let initials: Lab3Initial
    
    func execute(verbose: Bool, completion: () -> Void) {
        data = []
        data.append(initialState)
        if verbose { print("Simulating with initials: \(self.initials), \(self.initialState)") }
        for step in (1...initials.stepsNo) {
            let state = ParticleStateLab3(previousState: data.last!, initial: initials)
            data.append(state)
        }
        completion()
    }
    
    func save(completion: (String) -> Void) {
        if data.isEmpty {
            execute(false, completion: {
                
            })
        }
        
        let file = AZTextFile(filePath: self.filePath, option: .Write)
        file.write(results)
    }
    
    func plot(completion: ()-> Void) {
        
    }
    
    func esp(completion: () -> Void) {
        execute(true, completion: {
            self.save({_ in
                completion()
            })
        })
    }
    
    
    func execute(initials: [Lab3Initial], initialState: [ParticleStateLab3]) {
        assert(initials.count != initialState.count)
        
        for p in (0...initials.count) {
            let file = AZTextFile(filePath: self.filePath + "\(p)", option: .Write)
            data = []
            let initials = initials[p]
            let initialState = initialState[p]
            data.append(initialState)
            for _ in (1...initials.stepsNo) {
                let state = ParticleStateLab3(previousState: data.last!, initial: initials)
                data.append(state)
            }
            
            file.write(results)
            
        }
        
    }

    
    
    private var results: String {
        get {
            var dataString = "Czas [s] \t r [m] \t phi [rad] \t Pr [kg m/s] \t Pphi [kg m/s] \t x [m] \t y [m]\t E [J]\n"
            for step in data {
                dataString += "\(step.t) \t \(step.r) \t \(step.phi) \t \(step.Pr) \t \(step.Pphi) \t \(step.r*cos(step.phi))\t \(step.r*sin(step.phi)) \t \(step.E)\n"
            }
            
            return dataString
        }
    }
}