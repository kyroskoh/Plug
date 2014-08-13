//
//  GenresViewController.swift
//  Plug
//
//  Created by Alex Marchant on 8/1/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class GenresViewController: NSViewController, NSTableViewDelegate {
    @IBOutlet var tableView: NSTableView!
    var dataSource: GenresDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setDelegate(self)
        if dataSource != nil {
            tableView.setDataSource(dataSource)
            dataSource!.tableView = tableView
        }
    }
    
    func setDataSource(dataSource: GenresDataSource) {
        self.dataSource = dataSource
        self.dataSource!.tableView = tableView
        self.dataSource!.loadInitialValues()
    }
    
    func itemForRow(row: Int) -> GenresListItem {
        return dataSource!.tableContents![row]
    }
    
    func itemAfterRow(row: Int) -> GenresListItem? {
        if dataSource!.tableContents!.count - 1 > row {
            return itemForRow(row + 1)
        } else {
            return nil
        }
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int) -> NSView! {
        switch itemForRow(row) {
        case .SectionHeaderItem:
            return  tableView.makeViewWithIdentifier("SectionHeader", owner: self) as NSView
        case .GenreItem:
            return tableView.makeViewWithIdentifier("GenreTableCellView", owner: self) as NSView
        }
    }
    
    func tableView(tableView: NSTableView!, isGroupRow row: Int) -> Bool {
        switch itemForRow(row) {
        case .SectionHeaderItem:
            return  true
        case .GenreItem:
            return false
        }
    }
    
    func tableView(tableView: NSTableView!, heightOfRow row: Int) -> CGFloat {
        switch itemForRow(row) {
        case .SectionHeaderItem:
            return  32
        case .GenreItem:
            return 48
        }
    }
    
    func tableView(tableView: NSTableView!, rowViewForRow row: Int) -> NSTableRowView! {
        switch itemForRow(row) {
        case .SectionHeaderItem:
            let rowView = tableView.makeViewWithIdentifier("GroupRow", owner: self) as NSTableRowView
            return rowView
        case .GenreItem:
            let rowView = tableView.makeViewWithIdentifier("IOSStyleTableRowView", owner: self) as IOSStyleTableRowView
            if let nextItem = itemAfterRow(row) {
                switch nextItem {
                case .SectionHeaderItem:
                    rowView.nextRowIsGroupRow = true
                case .GenreItem:
                    rowView.nextRowIsGroupRow = false
                }
            } else {
                rowView.nextRowIsGroupRow = false
            }
            return rowView
        }
    }

    func tableView(tableView: NSTableView!, shouldSelectRow row: Int) -> Bool {
        switch itemForRow(row) {
        case .SectionHeaderItem:
            return false
        case .GenreItem:
            return true
        }
    }
}