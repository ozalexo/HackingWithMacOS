//
//  ViewController.swift
//  Project2
//
//  Created by Aleksey Ozerov on 05.02.2020.
//  Copyright © 2020 Aleksey Ozerov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet var tableView: NSTableView!

    @IBOutlet var guess: NSTextField!
    var answer = ""
    var guesses = [String]()
    var movesCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }

    @IBAction func submitGuess(_ sender: NSButton) {
        // check uniqueness
        let guessString = guess.stringValue
        guard Set(guessString).count == 4 else { return }
        guard guessString.count == 4 else { return }

        // ensure that there are no non-digit characters
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guessString.rangeOfCharacter(from: badCharacters) == nil else { return }

        // add the guess to the array and table view
        guesses.insert(guessString, at: 0)
        tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)

        // check results
        let resultString = result(for: guessString)

        if resultString.contains("4b") {
            let alert = NSAlert()
            alert.messageText = "You win."
            alert.informativeText = "Your result: \(resultString). Click OK to play again."

            // Show modal alert and stop until the player press 'OK'
            alert.runModal()

            startNewGame()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return guesses.count
    }

    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0

        let guessLetters = Array(guess)
        let answerLetters = Array(answer)

        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }

        return "\(bulls)b \(cows)c"
    }

    // Put values to an appropriate columns of table
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }

        if tableColumn?.title == "Guess" {
            // this is the "Guess" column; show a previous guess
            vw.textField?.stringValue = guesses[row]
        } else {
            // this is the "Result" column; call our new method
            vw.textField?.stringValue = result(for: guesses[row])
        }

        return vw
    }

    // Disable selectable table's rows
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }

    func startNewGame() {
        guess.stringValue = ""
        guesses.removeAll()
        answer = ""

        var numbers = Array(0...9).shuffled()

        for _ in 0..<4 {
            answer.append(String(numbers.removeLast()))
        }

        tableView.reloadData()
    }
}

