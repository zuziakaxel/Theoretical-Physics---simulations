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
 Dla jakiego parametru dt symulacja jest stabilna? (Kiedy przestana nam sie zmieniac wyniki)
 Dla tego parametru conajmniej 8 roznych symulacji (dla roznych wartosci parametrow poczatkowych)
 
 
 
 
 */

private let G = 9.82

struct Lab2Initial {
    let alpha: Double
    let dt: Double
    let stepsNo: Int
    
    init(alpha: Double, dt: Double, stepsNo: Int) {
        self.alpha = alpha
        self.dt = dt
        self.stepsNo = stepsNo
    }
}

struct ParticleState {
    var t: Double
    var phi: Double
    var z: Double
    var omega: Double
    var v: Double
    let initial: Lab2Initial
    
    init(t: Double, phi: Double, z: Double, omega: Double, v: Double, initial: Lab2Initial) {
        self.t = t
        self.phi = phi
        self.z = z
        self.omega = omega
        self.v = v
        self.initial = initial
    }
    
    init(previousState state: ParticleState, initial: Lab2Initial) {
        self.initial = initial
        self.t = state.t + initial.dt
        self.phi = state.phi + (state.omega * initial.dt)
        self.z = state.z + (state.v * initial.dt)
        
        let first = (G*pow(cos(initial.alpha), 2)) / (sin(initial.alpha))
        let second = (sin(self.phi)/self.z)
        let third = (2*state.v*state.omega)/self.z
        
        self.omega = state.omega - (((first*second) + third)*initial.dt)
        
        
        
        
//        self.omega = omega - ( (G*pow(cos(initial.alpha),2)/sin(initial.alpha)*(sin(state.phi)/state.z) ) + 2*state.v*state.omega/state.z )*initial.dt
        
        let firstV = pow(sin(initial.alpha), 2)*self.z*pow(self.omega,2)
        let secondV = -G*sin(initial.alpha)*pow(cos(initial.alpha),2)*(1-cos(self.phi))
        self.v = state.v + (firstV + secondV)*initial.dt
    }
}

class Lab2: Exercise {
    
    var data: [ParticleState] = []
    
    var filePath: String = ""
    
    init(filePath: String, initials: Lab2Initial? = nil, initialState: ParticleState? = nil) {
        self.filePath = filePath
        self.initials = initials == nil ? Lab2Initial(alpha: 0.5, dt: 0.1, stepsNo: 500) : initials!
        self.initialState = initialState == nil ? ParticleState(t: 0, phi: 1.1, z: 1.0, omega: 0.0, v: 0.0, initial: self.initials) : initialState!
    }
    
    let initialState: ParticleState
    let initials: Lab2Initial
    
    func execute(verbose: Bool, completion: () -> Void) {
        data = []
        data.append(initialState)
        if verbose { print("Simulating with initials: \(self.initials), \(self.initialState)") }
        for step in (1...initials.stepsNo) {
            let state = ParticleState(previousState: data.last!, initial: initials)
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
    
    
    func execute(initials: [Lab2Initial], initialState: [ParticleState]) {
        assert(initials.count != initialState.count)
        
        for p in (0...initials.count) {
            let file = AZTextFile(filePath: self.filePath + "\(p)", option: .Write)
            data = []
            let initials = initials[p]
            let initialState = initialState[p]
            data.append(initialState)
            for _ in (1...initials.stepsNo) {
                let state = ParticleState(previousState: data.last!, initial: initials)
                data.append(state)
            }
            
            file.write(results)
            
        }
        
    }

    
    
    private var results: String {
        get {
            var dataString = "Czas [s] \t Phi [rad] \t z [m] \t Omega \t V [m/s]\n"
            for step in data {
                dataString += "\(step.t) \t \(step.phi) \t \(step.z) \t \(step.omega) \t \(step.v)\n"
            }
            
            return dataString
        }
    }
}