//
//  ViewController.swift
//  Test_GraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myLabel = UILabel.init();
        self.view.addSubview(myLabel);
        myLabel.backgroundColor = .red;
        myLabel.text = "12312412312312412412312";
        myLabel.numberOfLines = 0;
        myLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.setOffset(10);
            make?.width.mas_equalTo()(100);
            make?.top.mas_equalTo()(100);
            make?.height.mas_equalTo()(myLabel.mas_width);
        };
    }


}

