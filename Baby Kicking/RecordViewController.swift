//
//  ViewController.swift
//  Baby Kicking
//
//  Created by Vinh Nguyen on 12/12/15.
//  Copyright © 2015 Axcoto. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RecordViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordKick(sender: UIButton) {
        print("Click record button")
        let kick = Kick()
        kick.count = 1
        kick.createdAt = NSDate()
        print(kick.createdAt)
        let realm = try! Realm()
        try! realm.write {
            realm.add(kick)
        }
    }

}

