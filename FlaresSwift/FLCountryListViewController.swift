//
//  FLCountryListViewController.swift
//  FlaresSwift
//
//  Created by SunyQin on 3/6/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit

protocol FLCountryListViewControllerDelegate: NSObjectProtocol {
	func didSelectCountry(dictionary: NSDictionary)
}

class FLCountryDataSource: NSObject {
	
	var countryList: [Dictionary<String, String>]? = [Dictionary]()
	var dic: Dictionary<String, String>?
	
	var currentCountryDic: Dictionary<String, String>? {
		get{
			if dic == nil {
				dic = getCurrentCountry()
			}
			return dic
		}
	}
	
	class var sharedDataSource : FLCountryDataSource {
		struct Static {
			static var onceToken : dispatch_once_t = 0
			static var instance : FLCountryDataSource? = nil
		}
		dispatch_once(&Static.onceToken) {
			Static.instance = FLCountryDataSource()
		}
		return Static.instance!
	}
	
	override init() {
		super.init()
		self.countryList = parseFromJSON()
	}
	
	func parseFromJSON() -> [Dictionary<String, String>]? {
		let path = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
		let parseData = NSData(contentsOfFile: path!)
		
		var error: NSError?
		if let data = parseData {
			if let list = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [Dictionary<String, String>] {
				return list
			}
		}
		return nil
	}
	
	//MARK Get Current Country
	
	func getCurrentCountry() -> Dictionary<String, String>? {
		let locale = NSLocale.currentLocale()
		let countryCode: String? = locale.objectForKey(NSLocaleCountryCode) as? String
		if let list = countryList {
			for country in list {
				if let code = country["code"] {
					if (code == countryCode) {
						return country
					}
				}
			}
		}
		return nil
	}
}

let cellId = "CELL"

class FLCountryListViewController: UIViewController {
	
	var delegate: FLCountryListViewControllerDelegate?
	var toolBar: UIToolbar!
	var textField: UITextField!
	var cancelButton: UIButton!
	var countryList: [Dictionary<String, String>]?
	var searchArray: [Dictionary<String, String>]?
	var collectionView: UICollectionView!
	
	override init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		countryList = FLCountryDataSource.sharedDataSource.countryList
		searchArray = countryList
		
		let background = UIImageView(frame: self.view.bounds)
		background.image = UIImage(named: "sky")
		background.contentMode = UIViewContentMode.ScaleAspectFill
		self.view.addSubview(background)
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		
		collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
		collectionView.backgroundColor = UIColor.clearColor()
		collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
		collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 44, 0)
		self.view.addSubview(collectionView)
		
		let closeButton = UIButton()
		closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
		closeButton.setImage(UIImage(named: "btn_close"), forState: UIControlState.Normal)
		closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(closeButton)
		
		self.view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: closeButton, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
		self.view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right , multiplier: 1, constant: 0))
		
		collectionView.registerClass(FLCountryCell.classForCoder(), forCellWithReuseIdentifier: cellId)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHidden:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		let userInfo = notification.userInfo as NSDictionary!
		let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
		println("\(frameNew)")
		
		let insetNewBottom = collectionView.convertRect(frameNew, fromView: nil).height
		let insetOld = collectionView.contentInset
		let insetChange = insetNewBottom - insetOld.bottom
		let overflow = collectionView.contentSize.height - (collectionView.frame.height-insetOld.top-insetOld.bottom)
		
		let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
		let animations: (() -> Void) = {
			if !(self.collectionView.tracking || self.collectionView.decelerating) {
				// Move content with keyboard
				if overflow > 0 {                   // scrollable before
					self.collectionView.contentOffset.y += insetChange
				}
			}
		}
		if duration > 0 {
			let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16)) // http://stackoverflow.com/a/18873820/242933
			UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
		} else {
			animations()
		}
	}
	
	func keyboardWillHidden(notification: NSNotification) {
		let userInfo = notification.userInfo as NSDictionary!
		let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
		println("\(frameNew)")
		
		let insetNewBottom = collectionView.convertRect(frameNew, fromView: nil).height
		let insetOld = collectionView.contentInset
		let insetChange = insetNewBottom - insetOld.bottom
		let overflow = collectionView.contentSize.height - (collectionView.frame.height-insetOld.top-insetOld.bottom)
		
		let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
		let animations: (() -> Void) = {
			if !(self.collectionView.tracking || self.collectionView.decelerating) {
				// Move content with keyboard
				if overflow > 0 {                   // scrollable before
					self.collectionView.contentOffset.y -= insetChange
				}
			}
		}
		if duration > 0 {
			let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16)) // http://stackoverflow.com/a/18873820/242933
			UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
		} else {
			animations()
		}
	}
	
	func close() {
		textField.resignFirstResponder()
		dismissViewControllerAnimated(true, completion: {})
	}
	
	func cancelAction() {
		textField.resignFirstResponder()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override var inputAccessoryView: UIView! {
		get {
			if toolBar == nil {
				toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, 44))
				toolBar.backgroundColor = UIColor.whiteColor()
				
				textField = UITextField()
				textField.backgroundColor = UIColor.whiteColor()
				textField.textColor = UIColor.grayColor()
				textField.layer.cornerRadius = 5
				textField.font = UIFont.systemFontOfSize(15.0)
				textField.borderStyle = UITextBorderStyle.RoundedRect
				textField.returnKeyType = UIReturnKeyType.Done
				textField.keyboardType = UIKeyboardType.Default
				textField.autocapitalizationType = UITextAutocapitalizationType.None
				textField.autocorrectionType = UITextAutocorrectionType.No
				textField.placeholder = SelectCountryString
				textField.delegate = self
				toolBar.addSubview(textField)
				
				cancelButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
				cancelButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16.0)
				cancelButton.setTitle("Cancel", forState: .Normal)
				cancelButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
				cancelButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
				cancelButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
				cancelButton.addTarget(self, action: "cancelAction", forControlEvents: UIControlEvents.TouchUpInside)
				toolBar.addSubview(cancelButton)
				
				textField.setTranslatesAutoresizingMaskIntoConstraints(false)
				cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
				
				self.toolBar.addConstraint(NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 5))
				self.toolBar.addConstraint(NSLayoutConstraint(item: textField, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 10))
				self.toolBar.addConstraint(NSLayoutConstraint(item: textField, attribute: .Right, relatedBy: .Equal, toItem: cancelButton, attribute: .Left, multiplier: 1, constant: -10))
				self.toolBar.addConstraint(NSLayoutConstraint(item: textField, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -5))
				self.toolBar.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 5))
				self.toolBar.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -5))
				self.toolBar.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: -10))
			}
			return toolBar
		}
	
	}
}

extension FLCountryListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	//MARK UICollectionViewDelegateLayout 
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
	{
		return CGSizeMake(CGRectGetWidth(self.view.bounds), 50)
	}
	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//		return UIEdgeInsetsMake(0, 0, 0, 0)
//	}
	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//	{
//		return CGSizeMake(CGRectGetWidth(self.view.bounds), 5)
//	}
	
	//MARK UICollectionViewDataSource
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let countrylist = searchArray {
			return searchArray!.count
		}
		return 0
	}
	
	// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let countryDic = searchArray![indexPath.item]
		let country = countryDic["name"]
		
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as FLCountryCell
		cell.setText(country!)
		return cell
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
//	// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//	optional func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
	
	//MARK UICollectionViewDelegate
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let dic = searchArray![indexPath.item]
		delegate?.didSelectCountry(dic)
		
		dismissViewControllerAnimated(false, completion: {})
	}

}

extension FLCountryListViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		var searchKey = textField.text.stringByAppendingString(string) as String
		searchArray?.removeAll(keepCapacity: false)
		searchArray = nil
		
		if !searchKey.isEmpty {
			let predicate = NSPredicate(format: "name contains [cd] %@", searchKey)
			searchArray = (countryList! as NSArray).filteredArrayUsingPredicate(predicate!) as? [Dictionary<String, String>]
		}
		else {
			searchArray = countryList
		}
		collectionView.reloadData()
		return true
	}
}
