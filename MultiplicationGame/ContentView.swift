//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Mihai Leonte on 10/28/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var upTo = 5
    @State private var isAllCombinations = true
    @State private var allCombinations: [(Int, Int)] = []
    @State private var questionsCount: Int = 0
    @State private var question: String = ""
    @State private var userAnswer: String = ""
    @State private var correctAnswer: Int = 0
    @State private var result: String = " "
    
    var body: some View {
        NavigationView {
            VStack {
                if questionsCount == 0 && allCombinations.isEmpty {
                    Form {
                        Stepper(value: $upTo, in: 1...12) {
                            Text("Study up to... \(upTo)")
                        }
                        
                        Toggle(isOn: $isAllCombinations) {
                            Text("All Combinations")
                        }
                        
                        if !isAllCombinations {
                            Button(action: {
                                self.questionsCount = 5
                                self.postQuestion()
                            }) {
                                Text("5 questions")
                            }
                            
                            Button(action: {
                                self.questionsCount = 10
                                self.postQuestion()
                            }) {
                                Text("10 questions")
                            }
                            
                            Button(action: {
                                self.questionsCount = 20
                                self.postQuestion()
                            }) {
                                Text("20 questions")
                            }
                        } else {
                            Button(action: {
                                self.postQuestion()
                            }) {
                                Text("Start All Combinations")
                            }
                        }
                    }
                } else {
                    Spacer()
                    
                    Text("\(question) ?")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Answer", text: $userAnswer, onCommit: checkQuestion)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100, alignment: .center)
                        .padding()
                    
                    Spacer()
                }
                
                
                Spacer()
                Text(result)
                    .font(.headline)
                    .foregroundColor(result == "Correct!" ? Color.green : Color.red)

                
                
            }.navigationBarTitle(Text("Multiple mX"))
        }
        
    }
    
    func postQuestion() {
        if isAllCombinations {
            if allCombinations.isEmpty {
                for i in 0...upTo {
                    for j in 0...upTo {
                        allCombinations.append((i,j))
                    }
                }
                postQuestion()
            } else {
                allCombinations.shuffle()
                let pair = allCombinations.popLast()
                let a = pair!.0
                let b = pair!.1
                correctAnswer = a * b
                question = "\(a) x \(b) ="
            }
        } else {
            if questionsCount > 0 {
                let a = Int.random(in: 0...upTo)
                let b = Int.random(in: 0...upTo)
                correctAnswer = a * b
                question = "\(a) x \(b) ="
                questionsCount -= 1
            }
        }
    }
    
    func checkQuestion() {
        guard let answer = Int(userAnswer) else { return }
        userAnswer = ""
        if answer == correctAnswer {
            result = "Correct!"
        } else {
            result = "Not correct! \(question) \(correctAnswer)"
        }
        postQuestion()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
