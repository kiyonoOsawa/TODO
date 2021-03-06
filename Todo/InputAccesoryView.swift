//
//  InputAccesoryView.swift
//  Todo
//
//  Created by 大澤清乃 on 2021/11/28.
//

import Foundation
import UIKit

protocol InputAccesoryViewDelegate: AnyObject {
    func tappedButton(text: String)
}

class InputAccesoryView: UIView{
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    weak var delegate: InputAccesoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiateNib()
        updateUI()
    }
    //追加　ボタンが押されたら発動するメソッド
    func removeText(){
        messageTextView.text = ""
        sendMessageButton.isEnabled = false
    }
    
    @IBAction func tappedSendMessageButton(_ sender: Any) {
        guard let text = messageTextView.text else {return}
        
        delegate?.tappedButton(text: text)
    }
    func instantiateNib() {
        let nib = UINib(nibName: "InputAccesoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else{
            return
        }
        view.frame = self.bounds
        //親のviewの大きさが変わったら中のviewの大きさも変わる
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    func updateUI() {
        messageTextView.layer.cornerRadius = 8
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.gray.cgColor
        //高さを可変するのに必要
        messageTextView.isScrollEnabled = false
        //delegate処理の記述
        messageTextView.delegate = self
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.imageView?.contentMode = .scaleAspectFill
        sendMessageButton.contentVerticalAlignment = .fill
        sendMessageButton.contentHorizontalAlignment = .fill
        sendMessageButton.isEnabled = false
        //横幅が限界まできたら改行して高さ可変にする
        autoresizingMask = .flexibleHeight
    }
    //そのviewを表示するために必要な最低の大きさにする
    override var intrinsicContentSize: CGSize{
        return.zero
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputAccesoryView: UITextViewDelegate{
    //textviewの内容が変更された時に発動
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            sendMessageButton.isEnabled = false
        } else {
            sendMessageButton.isEnabled = true
        }
    }
}
