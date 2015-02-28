//
//  FLTutorial.swift
//  FlaresSwift
//
//  Created by SunyQin on 2/27/15.
//  Copyright (c) 2015 Suny Qin. All rights reserved.
//

import Foundation
import UIKit

let pageNum = 5

protocol FLTutorialDeleage {
	func BeginToSignIn()
	func BeginToSignUp()
}

class FLTutorial: UIView {

	var delegate: FLTutorialDeleage? = nil
	var pageControl: UIPageControl!
	var scrollView: UIScrollView!
	var timer: NSTimer?
	var isTimering: Bool = false {
		willSet(newValue){
			if newValue {
				timer?.invalidate()
				timer = nil
				
				timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextStep", userInfo: nil, repeats: true)
			}
			else{
				timer?.invalidate()
				timer = nil
			}
		}
	}
	var index: Int = 0 {
		willSet(newValue){
			if (newValue < pageNum) {
				let subview: UIView? = scrollView.viewWithTag(newValue)
				self.scrollView.scrollRectToVisible(subview!.frame, animated: true)
				self.pageControl.currentPage = newValue
			}
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let width = frame.size.width
		let height = frame.size.height
		
		scrollView = UIScrollView(frame: frame)
		scrollView.pagingEnabled = true
		scrollView.delegate = self
		scrollView.bounces = false
		scrollView.backgroundColor = UIColor.clearColor()
		scrollView.contentSize = CGSizeMake(width * CGFloat(pageNum), height)
		self.addSubview(scrollView)
		
		for i in 0..<pageNum {
			let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * width , 0, width, height))
			var imageName = "flare_tutorial_\(i+1)"
			if height > 480 {
				imageName = "flare_tutorial_\(i+1)_568h"
			}
			imageView.image = UIImage(named: imageName)
			imageView.tag = i
			scrollView.addSubview(imageView)
			
			if i == pageNum - 1 {
				addButtonsOnLastPage()
			}
		}
		
		pageControl = UIPageControl(frame: CGRectMake(0, 95, width, 20))
		pageControl.numberOfPages = pageNum
		pageControl.currentPage = 0
		self.addSubview(pageControl)
		
		self.index = 0
	}
	
	func addButtonsOnLastPage() -> Void {
		
		let fullSize = self.frame.size
		let buttonOrginX: CGFloat = 35.0
		let buttonOrginY: CGFloat = CGFloat(fullSize.height) - 120.0
		let signUpImage = UIImage(named: "btn_active_up")
		let signInImage = UIImage(named: "btn_translucent_up")
		
		let signUpButton = UIButton()
		signUpButton.setBackgroundImage(signUpImage, forState: UIControlState.Normal)
		signUpButton.setTitle("sign-up", forState: UIControlState.Normal)
		signUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		signUpButton.titleLabel!.font = UIFont.systemFontOfSize(18.0)
		signUpButton.addTarget(self, action: "signUp", forControlEvents: UIControlEvents.TouchUpInside)
		let orginx = fullSize.width * 4 + buttonOrginX
		signUpButton.frame = CGRectMake(orginx, buttonOrginY, fullSize.width - buttonOrginX * 2, signUpImage!.size.height)
		scrollView.addSubview(signUpButton)
		
		let signInButton = UIButton()
		signInButton.setBackgroundImage(signInImage, forState: UIControlState.Normal)
		signInButton.setTitle("sign-in", forState: UIControlState.Normal)
		signInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		signInButton.titleLabel!.font = UIFont.systemFontOfSize(18.0)
		signInButton.addTarget(self, action: "signIn", forControlEvents: UIControlEvents.TouchUpInside)
		signInButton.frame = CGRectMake(orginx, buttonOrginY + 15 + signUpImage!.size.height, fullSize.width - buttonOrginX * 2, signInImage!.size.height)
		scrollView.addSubview(signInButton)
	}
	
	func signUp() -> Void {
		delegate?.BeginToSignUp()
	}
	
	func signIn() -> Void {
		delegate?.BeginToSignIn()
	}
	
	func nextStep() -> Void {
		if (self.index < pageNum - 1) {
			self.index = self.index + 1
		}
	}
	
	func showLastPage() -> Void {
		self.isTimering = true
		self.index = pageNum - 1
	}
}

extension FLTutorial: UIScrollViewDelegate{
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		self.isTimering = false
	}
	
	func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		self.isTimering = true
		self.index = Int(targetContentOffset.memory.x / self.frame.size.width)
	}
}