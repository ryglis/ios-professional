//
//  PushViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 14/03/2024.
//

import UIKit

class PushViewController: UIViewController {
    
    let stackView = UIStackView()
    let popButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        print("jestem")
    }
    
    func style() {
        title = "Pushed ViewController"
        view.backgroundColor = .systemOrange

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        popButton.translatesAutoresizingMaskIntoConstraints = false
        popButton.configuration = .filled()
        popButton.setTitle("Pop", for: [])
        popButton.addTarget(self, action: #selector(popTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(popButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func popTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("I will appear")
    }
}
