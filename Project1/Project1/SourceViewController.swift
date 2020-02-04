//
//  SourceViewController.swift
//  Project1
//
//  Created by Aleksey Ozerov on 04.02.2020.
//  Copyright © 2020 Aleksey Ozerov. All rights reserved.
//

import Cocoa

class SourceViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var pictures = [String]()

    @IBOutlet var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // get a list of *.nssl files
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fileManager.contentsOfDirectory(atPath: path)

        // loop over each file in bundle
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
            pictures.sort()
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return pictures.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let vw = tableView.makeView(withIdentifier:
            tableColumn!.identifier, owner: self) as? NSTableCellView else
        { return nil }
        vw.textField?.stringValue = pictures[row]
        return vw
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        guard let splitVC = parent as? NSSplitViewController else { return }

        if let detail = splitVC.children[1] as? DetailViewController {
            detail.imageSelected(name: pictures[tableView.selectedRow])
        }
    }
    
}
