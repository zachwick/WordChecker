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
    @State var all_words_in_universe: Array<String> = []
    @State var predictedValue: Array<String> = []
    @State var validWord: Bool = false
    @State var allTwoLetterWords: Array<String> = []

    func startGame() {
       if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
          if let startWords = try? String(contentsOf: startWordsURL) {
             let allWords = startWords.components(separatedBy: "\n")
                predictableValues = allWords
                all_words_in_universe = allWords
                allTwoLetterWords = twoLetterWords()
                return
          }
        }
        fatalError("Could not load words.txt from bundle.")
    }

    func showMatches() {
        let new_predictedValue = predictableValues.filter { (item: String) -> Bool in
            let stringMatch = item.lowercased().starts(with: textFieldInput.lowercased())
            return stringMatch
        }

        // Where/how to reset predictableValues for use in a recursive function?
        predictableValues = new_predictedValue
        predictedValue = new_predictedValue
    }

    func twoLetterWords() -> Array<String> {
        return all_words_in_universe.filter { (item: String) -> Bool in
            return item.lowercased().count == 2
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                TextField("Enter your word", text: $textFieldInput)
                    .onChange(of: textFieldInput, perform: { value in
                        if (textFieldInput == "") {
                            predictedValue = []
                            predictableValues = all_words_in_universe
                        } else {
                            showMatches()
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.largeTitle)
                List(self.predictedValue.sorted {
                    $0.count < $1.count
                }, id: \.self){
                    Text($0)
                }
                .navigationTitle("Check a word")
                .navigationBarItems(
                    trailing:
                        NavigationLink(
                            destination: List(self.allTwoLetterWords, id: \.self){
                                Text($0)
                            },
                            label: {
                                Text("2 letter words")
                            })
                )
            }.padding().onAppear(perform: startGame)
        }
    }
}
