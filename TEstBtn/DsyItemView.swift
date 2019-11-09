//
//  DsyItemView.swift
//  TEstBtn
//
//  Created by DerekYang on 2019/11/9.
//  Copyright © 2019 楊健麟. All rights reserved.
//

import UIKit

extension UIView {
    func full(_ margin: CGFloat) {
        if let parent = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: margin).isActive = true
            self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -margin).isActive = true
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: margin).isActive = true
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -margin).isActive = true
        }
    }
}

class DsyItemView: UIView {
    let scrollView = UIScrollView()
    let margin: CGFloat = 10
    let row = 3
    let colunm = 6
    let totalBtnCounts = 55
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
      super.init(frame : frame)
        self.backgroundColor = .yellow
        scrollView.backgroundColor = .green
        let pageSize = CGSize(width: frame.width - 2*margin, height: frame.height - 2*margin)
        scrollView.frame = CGRect(x: margin, y: margin, width: pageSize.width, height: pageSize.height)

        self.addSubview(scrollView)
//        scrollView.full(10)
       
        let pageCounts = totalBtnCounts/(row*colunm) + 1
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat( pageCounts), height: scrollView.frame.height)
  
        setupButtons(totalCounts: totalBtnCounts, pageSize: pageSize, pageRow: row, pageColunm: colunm)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    func setupButtons(totalCounts: Int, pageSize: CGSize, pageRow: Int, pageColunm: Int, margin: CGFloat = 10) {
        let allWidthMargin = CGFloat(pageColunm) * margin
        let allHeightMargin = CGFloat(pageRow + 1) * margin
        let pageCounts = pageRow*pageColunm
        let btnWidth = (pageSize.width - allWidthMargin) / CGFloat(pageColunm)
        let btnHeight = (pageSize.height - allHeightMargin) / CGFloat(pageRow)
        for i in 0 ..< totalCounts {
            let page = i/pageCounts
            let shiftX = CGFloat(i%pageColunm)
            let posX = (shiftX + 0.5) * margin + shiftX * btnWidth + CGFloat(page) * pageSize.width
            let shiftY = CGFloat((i%pageCounts)/pageColunm)
            let posY = (shiftY + 1) * margin + shiftY * btnHeight
//            let baseView = UIView(frame: CGRect(x: posX, y: posY, width: btnWidth, height: btnHeight))
            let btn = UIButton(frame: CGRect(x: posX, y: posY, width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: "help"), for: .normal)
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
//            btn.setTitle("\(i)", for: .normal)
            btn.tag = i
//            baseView.addSubview(btn)
//            btn.full(10)
            scrollView.addSubview(btn)
        }
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        print(sender.tag)
    }
}
