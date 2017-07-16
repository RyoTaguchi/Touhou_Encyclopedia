//
//  TextViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/07/08.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!
    var barTitle:String = ""
    var text:String = ""
    var isQA:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isQA {
            let filePath:String = Bundle.main.bundlePath + "/textData/QandA.txt"
            if let data = NSData(contentsOfFile:filePath) {
                let attrText:NSMutableAttributedString = NSMutableAttributedString(string:"")
                let loadText = String(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
                
                //行で分割
                var lines:Array<String> = Array<String>()
                loadText.enumerateLines { (line, stop) -> () in
                    lines.append(line)
                }
                
                //装飾して結合
                for line:String in lines {
                    if ( line.characters.count < 3 ) {
                        attrText.append( NSMutableAttributedString(string:line) )
                    } else {
                        let tmpAttrStr = NSMutableAttributedString(string:line)
                        
                        let tmp:String = line.substring(to:line.index(line.startIndex, offsetBy:3))
                        if (tmp == "Q. ") {
                            tmpAttrStr.addAttributes([NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0)], range: NSRange(location: 0, length: line.characters.count - 1))
                        } else {
                            tmpAttrStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)], range: NSRange(location: 0, length: line.characters.count - 1))
                        }
                        
                        attrText.append(tmpAttrStr)
                    }
                    attrText.append( NSMutableAttributedString(string:"\n") )
                }
                
                textView.attributedText = attrText
                
            }else{
                print("データなし")
            }
        } else {
            textView.text = text
        }
        
        //ボタン設置
        self.navigationItem.rightBarButtonItem = nil
        let questionBtn1:UIBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backBeforeView))
        self.navigationItem.rightBarButtonItem = questionBtn1
        let questionBtn2:UIBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backBeforeView))
        self.navigationItem.leftBarButtonItem = questionBtn2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = barTitle
    }
    override func viewDidLayoutSubviews() {
        textView.contentOffset = CGPoint(x: 0, y: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backBeforeView() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
