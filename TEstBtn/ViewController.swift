//
//  ViewController.swift
//  TEstBtn
//
//  Created by DerekYang on 2019/11/9.
//  Copyright © 2019 楊健麟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var imgs = [UIImage?]()
		for _ in 0...10 {
			imgs.append(UIImage(named: "help"))
		}
		let btn = DsyItemsView(frame: CGRect(x: 30, y: 30, width: 300, height: 200))
		btn.images = imgs
        btn.callback = { tag in
            print(tag)
        }
//        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
//        btn.backgroundColor = .blue
//        btn.setImage(UIImage(named: "help"), for: .normal)
        view.addSubview(btn)
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        v.backgroundColor = .red
//        btn.addSubview(v)
    }
    @objc func click() {
        print("click")
    }

}

