//
//  FLCountryCell.swift
//  FlaresSwift
//
//  Created by SunyQin on 3/6/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit

class FLCountryCell: UICollectionViewCell {
	
	var text: NSString?
	var displayBottomLine: Bool = true {
		willSet {
			if newValue {
				bottomLine.hidden = false
			}
			else{
				bottomLine.hidden = true
			}
		}
	}
	var displayArrow: Bool = false {
		willSet {
			if newValue {
				arrow.hidden = false
			}
			else {
				arrow.hidden = true
			}
		}
	}
	
	var textLabel: UILabel!
	var bottomLine: UIImageView!
	var arrow: UIImageView!
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		textLabel = UILabel()
		textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		textLabel.backgroundColor = UIColor.clearColor()
		textLabel.font = UIFont.systemFontOfSize(16.0)
		textLabel.textColor = UIColor.whiteColor()
		self.contentView.addSubview(textLabel)
		
		bottomLine = UIImageView()
		bottomLine.setTranslatesAutoresizingMaskIntoConstraints(false)
		bottomLine.image = UIImage(named: "separate")
		bottomLine.contentMode = UIViewContentMode.ScaleToFill
		self.contentView.addSubview(bottomLine)
		
		arrow = UIImageView()
		arrow.setTranslatesAutoresizingMaskIntoConstraints(false)
		arrow.image = UIImage(named: "arrow")
		arrow.contentMode = UIViewContentMode.ScaleToFill
		self.contentView.addSubview(arrow)
		
//		var viewsDictionary: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
//		viewsDictionary["textLabel"] = textLabel
//		viewsDictionary["bottomLine"] = bottomLine
//		viewsDictionary["arrow"] = arrow
		
		let viewsDictionary: Dictionary<String, AnyObject> = ["textLabel": textLabel, "arrow": arrow, "bottomLine": bottomLine]
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textLabel]-5-[arrow(10)]-20-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textLabel]-[bottomLine(1)]-1-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bottomLine]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
	}
	
	func setText(text: String) {
		textLabel.text = text
	}
}