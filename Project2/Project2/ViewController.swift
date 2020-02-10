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

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }

    @IBAction func submitGuess(_ sender: NSButton) {
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
        return "Result"
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

