//
//  ViewController.swift
//  SpeechSynthesizerTester
//
//  Created by Maura Driscoll on 10/23/23.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    private let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton(frame: .init(x: 100, y: 300, width: 200, height: 100))
        button.setTitle("Press to Speak", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc func didTapButton() {
        let utterance = AVSpeechUtterance(string: "Hello")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}

