//
//  ShiftLabel.swift
//  creators
//
//  Created by Natasja Nielsen on 10/4/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

enum ShiftColor: Int {
    case Red
    case Orange
    case Green
    case Blue
    case Cream
    case Gray
    case LightGray
    func color() -> UIColor {
        switch self {
        case .Red:
            return UIColor(red: 245.0/255, green: 67.0/255, blue: 66.0/255, alpha: 1)
        case .Orange:
            return UIColor(red: 245.0/255, green: 144.0/255, blue: 67.0/255, alpha: 1)
        case .Green:
            return UIColor(red: 73.0/255, green: 212.0/255, blue: 103.0/255, alpha: 1)
        case .Blue:
            return UIColor(red: 56.0/255, green: 182.0/255, blue: 209.0/255, alpha: 1)
        case .Cream:
            return UIColor(red: 249.0/255, green: 249.0/255, blue: 242.0/255, alpha: 1)
        case .Gray:
            return UIColor(red: 71.0/255, green: 71.0/255, blue: 71.0/255, alpha: 1)
        case .LightGray:
            return UIColor(red: 71.0/255, green: 71.0/255, blue: 71.0/255, alpha: 0.2)
        default:
            return UIColor(red: 71.0/255, green: 71.0/255, blue: 71.0/255, alpha: 1)
        }
    }
}

enum ShiftFont: Int {
    case Canter
    case GRLight
    case GRBook
    func font() -> String {
        switch self {
        case .Canter:
            return "Canter"
        case .GRLight:
            return "Gotham Rounded"
        case .GRBook:
            return "GothamRounded-Book"
        default:
            return "Gotham Rounded"
        }
    }
}

enum Months: Int {
    case Jan = 1
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
    func month() -> String {
        switch self {
        case .Jan:
            return "Jan"
        case .Feb:
            return "Feb"
        case .Mar:
            return "Mar"
        case .Apr:
            return "Apr"
        case .May:
            return "May"
        case .Jun:
            return "Jun"
        case .Jul:
            return "Jul"
        case .Aug:
            return "Aug"
        case .Sep:
            return "Sep"
        case .Oct:
            return "Oct"
        case .Nov:
            return "Nov"
        case .Dec:
            return "Dec"
        default:
            return ""
        }
    }
}

class ShiftLabel: UILabel {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: ShiftFont.GRLight.font(), size: 12)
        self.textColor = ShiftColor.Gray.color()
    }
}

class ShiftTextView: UITextView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: ShiftFont.GRLight.font(), size: 12)
        self.textColor = ShiftColor.Gray.color() 
    }
}

class TitleLabel: ShiftLabel {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: ShiftFont.GRBook.font(), size: 18)
    }
}

class DescriptionLabel: ShiftLabel {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        //self.font = UIFont(name: ShiftFont.GRLight.font(), size: 12)
    }
}

class DescriptionTextView: ShiftTextView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: ShiftFont.GRLight.font(), size: 15)
    }
}

class ShiftImageView: UIImageView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

class ShiftButton: UIButton {
    /*override init(frame: CGRect) {
        super.init(frame: frame)
    }*/
}

class RsvpButton: ShiftButton {
    required override init(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 4
    }
    func setBackground(status: String) {
        switch status {
            case "GOING":
                self.backgroundColor = ShiftColor.Green.color()
                self.layer.borderColor = UIColor.clearColor().CGColor
            case "MAYBE":
                self.backgroundColor = ShiftColor.Blue.color()
                self.layer.borderColor = UIColor.clearColor().CGColor
            case "NOT":
                self.backgroundColor = ShiftColor.Red.color()
                self.layer.borderColor = UIColor.clearColor().CGColor
            default:
                self.backgroundColor = UIColor.clearColor()
                self.layer.borderColor = ShiftColor.LightGray.color().CGColor
        }
    }
}

class RsvpCircleButton: RsvpButton {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.bounds.size.width / 2
    }
}

class RequestButton: ShiftButton {
    required override init(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 4
    }
    func setBackground(status: String) {
        if status == "true" {
            self.backgroundColor = ShiftColor.Green.color()
            self.layer.borderColor = UIColor.clearColor().CGColor
            //self.setImage(UIImage(named:"square.png"), forState: .Normal)
        } else {
            self.backgroundColor = UIColor.clearColor()
            self.layer.borderColor = ShiftColor.LightGray.color().CGColor
        }
    }
}

class RequestCircleButton: RequestButton {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.bounds.size.width / 2
    }
}
