//
//  Exercise.swift
//  Lab1
//
//  Created by Axel Zuziak on 01.12.2015.
//  Copyright © 2015 Axel Zuziak. All rights reserved.
//

import Foundation

protocol Exercise {
    func execute(verbose: Bool, completion: () -> Void)
    func save(completion: (String) -> Void)
    func plot(completion: ()-> Void)
    func esp(completion: () -> Void) // execute, save, plot
}

private let G = -9.81

class LabIA: Exercise {

    var filePath: String = ""
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    private struct Particle {
        private var state: ParticleState
        
        init(state: ParticleState) {
            self.state = state
        }
    }
    
    private struct ParticleState {
        var m = 1.0 // KG
        var x = 0.0 // m
        var xa = 0.0 // m
        var v = 0.0 // m/s
        var t = 0.0 // s
        var e = 0.0 // J
        
        init(mass m: Double = 1.0, position x: Double = 0.0, velocity v: Double = 0.0, time t: Double = 0.0, postitionAnalytics xa: Double = 0.0) {
            self.m = m
            self.x = x
            self.v = v
            self.xa = xa
        }
        
        init(previousState state: ParticleState, timeInterval dt: Double, initialPosition x_0: Double, initialVelocity v_0: Double) {
            self.x = state.x + (state.v*dt)
            self.v = state.v + G*dt
            self.t = state.t + dt
            self.e = (0.5 * m * pow(state.v, 2)) - (m * G * state.x)
            self.xa = x_0 + (v_0 * t) + (0.5 * G * pow(t, 2))
        }
    }
    
    
    var dt = 0.001
    var x_0 = 0.0
    var v_0 = 10.0

    private var particle: Particle!
    private var states: [ParticleState] = []
    
    func esp(completion: () -> Void) {
        self.execute(false, completion: {
            self.save({ _ in
                self.plot(completion)
            })
        })
    }
    
    func execute(verbose: Bool, completion: () -> Void) {
        simulate(false, completion: completion)
    }

    func save(completion: (String) -> Void) {
        if states.isEmpty {
            simulate(completion: {
                let file = AZTextFile(filePath: self.filePath, option: .Write)
                file.write(self.results)
                completion(self.results)
            })
        } else {
            let file = AZTextFile(filePath: self.filePath, option: .Write)
            file.write(self.results)
            completion(self.results)
        }
        
    }
    
    func plot(completion: () -> Void) {
        let file = AZTextFile(filePath: "skrypt.plot", option: .Write)
        let plot = "reset\n" +
            "set terminal epslatex size 13cm,9cm color colortext\n" +
            "set output \'cechowanie.tex\'\n" +
            "set grid\n" +
            "set style line 1 linecolor rgb \'#314F77\' linetype 1 linewidth 5 \n" +
            "set ytics nomirror\n" +
            "set y2tics\n" +
            "set xlabel \"t [s]\"\n" +
            "set ylabel \"x [m]\"\n" +
            "set y2label \"E [J]\"\n" +
            "plot \"\(filePath)\" u 1:2 axes x1y1 w l title \"x(t)\", \"\(filePath)\" u 1:5 axes x1y2 w l ls 1 title \"e(t)\", \"\(filePath)\" u 1:3 axes x1y1 w l title \"Xanalityczne(t)\"\n" +
            "#\"\(filePath)\" u 1:3 axes x1y2 w l title \"v(t)\",\n"

        file.write(plot)
        print("Plotting")
        print(executeCommand("/usr/local/bin/gnuplot", args: ["skrypt.plot"]))
        completion()
        
    }
    
    private var results: String {
        get {
            var str = "Czas [s] \t X [m] \t X analitycznie [m] \t Preskosc [m/s] \t Energia [J]\n"
            for state in states {
                str += "\(state.t) \t \(state.x) \t \(state.xa) \t \(state.v) \t \(state.e)\n"
            }
            
            return str
        }
    }
    
    private func simulate(verbose: Bool = false, completion: () -> Void) {
        states = []
        particle = Particle(state: ParticleState(mass: 2.0, position: 0.0, velocity: 10.0))
        
        repeat {
            states.append(particle.state)
            if verbose {
                print("\(particle.state.t) \t \(particle.state.x) \t \(particle.state.xa) \t \(particle.state.v) \t \(particle.state.e)")
            }
            particle.state = ParticleState(previousState: particle.state, timeInterval: dt, initialPosition: x_0, initialVelocity: v_0)
        } while particle.state.x >= 0.0
        completion()
    }
    
}

