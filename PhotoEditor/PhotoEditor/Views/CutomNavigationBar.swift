import UIKit

class CustomNavigationBar: UIView {
    let titleLabel = UILabel()
    let leftButton: UIButton?
    let rightButton: UIButton?
    
    init(
        title: String? = "",
        leftButton: UIButton? = nil,
        rightButton: UIButton? = nil
    ) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        
        super.init(frame: .zero)
        
        setupView(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String?) {
        backgroundColor = .white
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(titleLabel)
        
        if let leftButton {
            addSubview(leftButton)
        }
        
        if let rightButton {
            addSubview(rightButton)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        if let leftButton = leftButton {
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        }
        
        if let rightButton = rightButton {
            rightButton.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
