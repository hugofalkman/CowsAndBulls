//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by H Hugo Falkman on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var guess = ""
    @State private var guesses = [String]()
    @State private var answer = ""
    @State private var isGameOver = false
    @State private var guessText = "guess"
    @State private var isMaxGuesses = false
    
    @AppStorage("maximumGuesses") var maximumGuesses = 100
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    @AppStorage("showGuessCount") var showGuessCount = false

    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8  else { return }
        guess = ""
        guesses.removeAll()
        guessText = "guess"
        answer = ""
        let numbers = (0...9).shuffled()
        
        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
        print(answer)
    }
    func submitGuess() {
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }
        guard !Set(guesses).contains(guess) else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        guesses.insert(guess, at: 0)
        
        if result(for: guess).contains("\(answerLength)b") {
            if guesses.count != 1 { guessText = "guesses" }
            isGameOver = true
        }
        
        if guesses.count >= maximumGuesses {
            isMaxGuesses = true
        }
        
        guess = ""
    }
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index,letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                TextField("Enter a guess…", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action: submitGuess)
            }
            .padding()
            
            List(0..<guesses.count, id: \.self) { index in
                let guess = guesses[index]
                let shouldShowResults = (enableHardMode == false) || (enableHardMode) && index == 0
                
                HStack {
                    Text(guess)
                    Spacer()
                    
                    if shouldShowResults {
                        Text(result(for: guess))
                    }
                }
            }
            .listStyle(.sidebar)
            
            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
                    .padding()
            }
        }
        .navigationTitle("Cows and Bulls")
        .frame(width: 250)
        .frame(minHeight: 300)
        .onAppear(perform: startNewGame)
        .onChange(of: answerLength, startNewGame)
        .alert("You win after \(guesses.count) \(guessText)!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            if guesses.count < 10 {
                Text("Congratulations, needing very few guesses! Click OK to play again.")
            } else if guesses.count > 20 {
                Text("Congratulations, even if needing many guesses! Click OK to play again.")
            } else {
                Text("Congratulations! Click OK to play again.")
            }
        }
        .alert("You lose after reaching the maximum guesses \(maximumGuesses)", isPresented: $isMaxGuesses) {
            Button("OK", action: startNewGame)
        } message: {
            Text("The correct answer was \(answer). Click OK to play again.")
        }
        .touchBar {
            HStack {
                Text("Guesses: \(guesses.count)")
                    .touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
    }
}

#Preview {
    ContentView()
}
