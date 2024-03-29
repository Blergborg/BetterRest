//
//  ContentView.swift
//  BetterRest
//
//  Created by Phil Prater on 8/31/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    // Input states
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
     
    // Compute default value
    // (Making this value static allows us to use it in an initializer statement.
    // This work becuase when we make the var static it belongs to the ContentView
    // struct itself rather than a single instance of that struct, so it can be used whenever.)
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private var idealBedTime: String {
        var bedtime = ""
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            
             bedtime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            print("Error")
            bedtime = "Sorry, there was a problem calculating your bedtime."
        }
        return bedtime
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()  // let's us hide the ugly label, but still use the lable for VoiceOver
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }

                Section("Daily coffee intake") {
                    // Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text("\($0)")
                        }
                    }
                }
                Section("Your ideal bedtime is") {
                    Text(idealBedTime)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Better Rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
