//
//  ViewController.swift
//  ChineseHandWriting
//
//  Created by Hung Tran on 05/05/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func begin_handwriting(_ sender: Any) {
        let controller = ChineseHandWrittingViewController(nibName: "ChineseHandWrittingViewController", bundle: nil)
        self.present(controller, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

