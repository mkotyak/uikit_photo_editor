import Combine
import UIKit

class PhotoEditorModuleViewController: UIViewController {
    let viewModel: PhotoEditorModuleViewModel = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    lazy var photoEditorView: PhotoEditorModuleEditorView = .init()
    private lazy var addButtonView: PhotoEditorModuleAddButtonView = .init()
    
    private lazy var filtersControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel.availableFilters.map { $0.controlTitle })
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)

        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupBinding()
        
        reloadView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self
                
        photoEditorView.addGestureRecognizers(
            pinchGesture: pinchGesture,
            rotationGesture: rotationGesture,
            panGesture: panGesture
        )
        
        addButtonView.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        view.addSubview(photoEditorView)
        view.addSubview(filtersControl)
        view.addSubview(addButtonView)
    }
    
    private func setupConstraints() {
        photoEditorView.translatesAutoresizingMaskIntoConstraints = false
        filtersControl.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoEditorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoEditorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoEditorView.widthAnchor.constraint(equalToConstant: 350),
            photoEditorView.heightAnchor.constraint(equalToConstant: 350),
            
            filtersControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            filtersControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            filtersControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            addButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButtonView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addButtonView.widthAnchor.constraint(equalToConstant: 80),
            addButtonView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupBinding() {
        viewModel.state
            .sink { [weak self] newState in
                self?.photoEditorView.imageView.image = newState.filteredImage
            }
            .store(in: &cancellables)
    }
    
    func reloadView() {
        navigationItem.rightBarButtonItem = viewModel.hasSelectedImage
            ? UIBarButtonItem(
                image: UIImage(named: "externaldrive"),
                style: .plain,
                target: self,
                action: #selector(saveButtonTapped)
            )
            : nil
        
        addButtonView.isHidden = viewModel.hasSelectedImage
        filtersControl.isHidden = !viewModel.hasSelectedImage
        photoEditorView.isHidden = !viewModel.hasSelectedImage
    }
}
