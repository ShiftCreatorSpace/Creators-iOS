//
//  ShiftLabel.swift
//  creators
//
//  Created by Natasja Nielsen on 10/4/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class ShiftLabel: UILabel {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: "Gotham Rounded", size: 18)
    }
}

class ShiftTextView: UITextView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: "Gotham Rounded", size: 18)        
    }
}
