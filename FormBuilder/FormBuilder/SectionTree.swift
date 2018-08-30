//
//  SectionTree.swift
//  FormBuilder
//
//  Created by Water Lou on 30/8/2018.
//  Copyright © 2018 Water Lou. All rights reserved.
//

import Foundation

// build the tree for the form structure, that will be easier for show / hide cells
class SectionTree {
    
    class Section {
        class Row {
            var key: String
            var isHidden = false
            init(key: String) {
                self.key = key
            }
        }
        var key: String
        var rows: [Row]
        var isHidden: Bool
        
        init(key: String, rows: [Row] = [], isHidden: Bool = false) {
            self.key = key
            self.rows = rows
            self.isHidden = isHidden
        }

        // global flag set, or all rows inside is hidden
        var isHiddenSection: Bool {
            return isHidden || rows.reduce(true, {$0 && $1.isHidden})
        }
        // count visible rows
        var numberOfRows: Int {
            return self.rows.filter { !$0.isHidden }.count
        }
        
        // include hidden
        var indexLength: Int {
            return 1 + rows.count
        }
        
        func indexFor(row rowIndex: Int) -> Int {
            var ret = 1 // start at 1, skip section row
            var rowIndex = rowIndex
            for row in rows {
                if row.isHidden {
                    ret += 1
                    continue
                }
                if rowIndex == 0 {
                    return ret
                }
                rowIndex -= 1
                ret += 1
            }
            return ret
        }
        
    }
    
    public private(set) var dummySectionCreated = false
    var sections: [Section] = []
    
    func clear() { sections = [] }
    func appendRow(key: String, isSectionHeader: Bool) {
        if isSectionHeader {
            assert(dummySectionCreated == false, "You can have sectionHeader at the begin of array for sectioned form.")
            sections.append(Section(key: key))
        }
        else {
            if sections.count == 0 {
                // no section create a empty one
                dummySectionCreated = true
                sections.append(Section(key: "__dummySection__"))
            }
            sections.last?.rows.append(Section.Row(key: key))
        }
    }

    // only visible sections
    var numberOfSections: Int {
        return self.sections.filter { !$0.isHiddenSection }.count
    }
    
    func section(at index: Int) -> Section {
        var index = index
        for section in sections {
            if section.isHiddenSection {
                continue    // skip hidden
            }
            if index == 0 {
                return section
            }
            index -= 1
        }
        fatalError("index out of bound")
    }
 
    func indexFor(section sectionIndex: Int) -> Int? {
        if dummySectionCreated {
            return nil
        }
        var sectionIndex = sectionIndex
        var resultIndex = 0
        for section in sections {
            if section.isHiddenSection {
                resultIndex += section.indexLength
                continue    // skip hidden
            }
            if sectionIndex == 0 {
                return resultIndex
            }
            sectionIndex -= 1
            resultIndex += section.indexLength
        }
        return resultIndex
    }
    
    func indexFor(row: Int, section sectionIndex: Int) -> Int {
        if let index = self.indexFor(section: sectionIndex) {
            let section = self.section(at: sectionIndex)
            return index + section.indexFor(row: row)
        }
        return row // no section
    }
    
    func setHidden(key: String, hidden: Bool) -> Bool {
        var changed = false
        self.sections.forEach { section in
            section.rows.forEach { row in
                if row.key == key && row.isHidden != hidden {
                    row.isHidden = hidden
                    changed = true
                }
            }
            if section.key == key && section.isHidden != hidden {
                section.isHidden = hidden
                changed = true
            }
        }
        return changed
    }

    func visibleTree() -> SectionTree {
        let filteredTree = SectionTree()
        filteredTree.dummySectionCreated = self.dummySectionCreated
        filteredTree.sections = self.sections.compactMap { section in
            if section.isHidden {
                return nil
            }
            let rows = section.rows.filter { row in
                row.isHidden == false
            }
            if rows.count == 0 {
                return nil
            }
            return Section(key: section.key, rows: rows, isHidden: section.isHidden)
        }
        return filteredTree
    }
}
