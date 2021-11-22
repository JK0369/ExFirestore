//
//  MainVC.swift
//  ExFirestore
//
//  Created by 김종권 on 2021/11/20.
//

import UIKit

class MainVC: UIViewController {
    
    let myFirestore = MyFirestore()
    
    private lazy var communicationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var communicationTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "메시지"
        return field
    }()
    
    private lazy var sentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Firestore 데이터 전송", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(didTapSentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var firestoreTextView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = .systemFont(ofSize: 24, weight: .bold)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        subscribeFirestore()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(communicationStackView)
        view.addSubview(firestoreTextView)
        communicationStackView.addArrangedSubview(communicationTextField)
        communicationStackView.addArrangedSubview(sentButton)
        
        communicationStackView.translatesAutoresizingMaskIntoConstraints = false
        communicationStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        communicationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        communicationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        firestoreTextView.translatesAutoresizingMaskIntoConstraints = false
        firestoreTextView.topAnchor.constraint(equalTo: communicationStackView.bottomAnchor, constant: 16).isActive = true
        firestoreTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firestoreTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firestoreTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56).isActive = true
    }
    
    private func subscribeFirestore() {
        myFirestore.subscribe(id: "123") { [weak self] result in
            switch result {
            case .success(let messages):
                messages.forEach {
                    self?.firestoreTextView.textColor = .darkGray
                    self?.firestoreTextView.text = $0.content + "\n" + (self?.firestoreTextView.text ?? "")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapSentButton() {
        guard let content = communicationTextField.text else { return }
        let message = Message(id: "123", content: content)
        
        myFirestore.save(message) { error in
            print("error: \(error)")
        }
    }
}
