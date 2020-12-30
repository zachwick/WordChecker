//
//  ContentView.swift
//  WordChecker
//
//  Created by zach wick on 12/29/20.
//

import SwiftUI

struct ContentView: View {

    @State var textFieldInput: String = ""
    @State var predictableValues: Array<String> = []
    @State var predictedValue: Array<String> = []

    func startGame() {
       if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
          if let startWords = try? String(contentsOf: startWordsURL) {
             let allWords = startWords.components(separatedBy: "\n")
                predictableValues = allWords
                return
          }
        }
        fatalError("Could not load words.txt from bundle.")
    }

    func showMatches() {
        predictedValue = predictableValues.filter { (item: String) -> Bool in
            let stringMatch = item.lowercased().starts(with: textFieldInput.lowercased())
            return stringMatch
        }
    }

    var body: some View {
        VStack(alignment: .leading){
            TextField("Enter your word", text: $textFieldInput)
                .onChange(of: textFieldInput, perform: { value in
                    showMatches()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            List(self.predictedValue, id: \.self){
                Text($0)
            }
        }.padding().onAppear(perform: startGame)
    }
}
