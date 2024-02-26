//
//  ViewController.swift
//  Marvel
//
//  Created by Ahmed Gamal on 22/02/2024.
//

import UIKit
import RxSwift

class SplashVC: UIViewController {
    
    let imageView = UIImageView(image: UIImage(named: "marvel-logo"))
    override func viewDidLoad() {
        super.viewDidLoad()
        addImage()
        // Do any additional setup after loading the view.
    }
    
    private func addImage(){
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseOut], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.imageView.alpha = 0.0
        }) { [weak self] _ in
            guard let self = self else {return}
            self.navigateToMainScreen()
        }
    }
    
    func navigateToMainScreen() {
        let nav = UINavigationController(rootViewController: HomeVC(viewModel: HomeVM(useCase: CharacterUseCase(repository: CharactersRepositoryImpl()))))
          nav.modalPresentationStyle = .fullScreen
//        nav.isNavigationBarHidden = true
        self.present(nav, animated: true)
    }
}

