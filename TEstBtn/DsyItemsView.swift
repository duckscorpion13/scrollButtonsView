//
//  DsyItemsView.swift
//  TEstBtn
//
//  Created by DerekYang on 2019/11/9.
//  Copyright © 2019 楊健麟. All rights reserved.
//
import UIKit

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        UIGraphicsBeginImageContextWithOptions(bleed.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(
            x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
            y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
            size: breadthSize))
        else { return nil }
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: bleed.size)).addClip()
        var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
        strokeRect.origin = CGPoint(x: width/2, y: width/2)
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
        color.set()
        let line = UIBezierPath(ovalIn: strokeRect)
        line.lineWidth = width
        line.stroke()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class DsyItemsView: UIView {
    let scrollView = UIScrollView()
   
	var buttons = [UIButton]()
    var row = 1
    var colunm = 4
	
	var images = [UIImage?]()
	var subImages = [UIImage?]()
	var startIndex = 0
	
    var callback: ((Int) -> ())? = nil
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	func setParameter(images: [UIImage?], subImages: [UIImage?], startIndex: Int) {
		self.images = images
		self.subImages = subImages
		self.startIndex = startIndex
	}
	
	fileprivate func resetScrollView(_ images: [UIImage?], subImages: [UIImage?], startIndex: Int, margin: CGFloat = 5) {
//		print("aaaaaaaa frame\(frame)")
		for v in scrollView.subviews {
			v.removeFromSuperview()
		}
		
		let pageSize = CGSize(width: frame.width - 2*margin, height: frame.height - 2*margin)
		scrollView.frame = CGRect(x: margin, y: margin, width: pageSize.width, height: pageSize.height)
//		let pageCounts = (0 == images.count%(row*colunm)) ? images.count/(row*colunm)  : images.count/(row*colunm) + 1
//		scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageCounts), height: scrollView.frame.height)
		let colWidth = pageSize.width / CGFloat(colunm)
		let colCount = (0 == images.count%row) ?  images.count/row : images.count/row + 1
		scrollView.contentSize = CGSize(width:  colWidth * CGFloat(colCount) / CGFloat(row), height: scrollView.frame.height)
		setupButtons(icons: images, subIcons: subImages, pageSize: pageSize, startIndex: startIndex, pageColunm: colunm, pageRow: row)
	}
	
	convenience init(frame: CGRect, images: [UIImage?], subImages: [UIImage?]) {
		self.init(frame: frame)
		
		setParameter(images: images, subImages: subImages, startIndex: 0)
		
	}
	
    override init(frame: CGRect) {
		super.init(frame : frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
		
//        scrollView.backgroundColor = .green
		scrollView.indicatorStyle = .white
        self.addSubview(scrollView)
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		resetScrollView(self.images, subImages: self.subImages, startIndex: self.startIndex)
	}
	
    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
	func setupButtons(icons: [UIImage?], subIcons: [UIImage?], pageSize: CGSize, startIndex: Int, pageColunm: Int, pageRow: Int = 1,  margin: CGFloat = 2) {
        let allWidthMargin = CGFloat(pageColunm) * margin
        let allHeightMargin = CGFloat(pageRow + 1) * margin
        let pageCounts = pageRow*pageColunm
        let btnWidth = (pageSize.width - allWidthMargin) / CGFloat(pageColunm)
        let btnHeight = (pageSize.height - allHeightMargin) / CGFloat(pageRow)
		
		self.buttons.removeAll()
		for i in 0 ..< icons.count {
            let page = i/pageCounts
            let shiftX = CGFloat(i%pageColunm)
            let posX = (shiftX + 0.5) * margin + shiftX * btnWidth + CGFloat(page) * pageSize.width
            let shiftY = CGFloat((i%pageCounts)/pageColunm)
            let posY = (shiftY + 1) * margin + shiftY * btnHeight
//            let baseView = UIView(frame: CGRect(x: posX, y: posY, width: btnWidth, height: btnHeight))
            let btn = UIButton(frame: CGRect(x: posX, y: posY, width: btnWidth, height: btnHeight))
			btn.setImage(icons[i], for: .normal)
			if(i < subIcons.count),
			let subImg = subIcons[i] {
				btn.setImage(subImg, for: .selected)
			} else {
				btn.setImage(icons[i]!.rounded(with: .blue, width: 2), for: .selected)
			}
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
//            btn.setTitle("\(i)", for: .normal)
            btn.tag = startIndex + i
//            baseView.addSubview(btn)
//            btn.full(10)
            scrollView.addSubview(btn)
			self.buttons.append(btn)
        }
    }
    
    @objc func clickBtn(_ sender: UIButton) {
		let tag = sender.tag
		sender.isSelected = !sender.isSelected
		for btn in self.buttons {
			if(tag != btn.tag) {
				btn.isSelected = false
			}
		}
//		print(sender.isSelected )
        self.callback?(sender.tag)
    }
}
