//
//  PicnicDetailViewController.swift
//  Picnic
//
//  Created by Kyle Burns on 7/18/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import MapKit
fileprivate let kPreviewHeight: CGFloat = 300
let kNavigationBarFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
fileprivate let visitButtonSize: CGSize = CGSize(width: 150, height: 80)
fileprivate let modalOffset: CGFloat = 500

class DetailController: UIViewController {
    private(set) var picnic: Picnic = .empty
    let navigationBar = NavigationBar()
    let preview = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: kPreviewHeight)))
    let rating = Rating()
    let map = MKMapView()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let overviewLabel = UITextView()
    let overview = UITextView()
    let visitedLabel = UILabel()
    let wouldVisitLabel = UILabel()
    let reviews = Reviews()
    let liked = HeartButton(pointSize: 40)
    let reviewModal = StagedModalController()
    let reviewRating = Rating(starSize: 60)
    let reviewContentTextField = PaddedTextField()

// MARK: What is this ????
//    override var preferredStatusBarStyle: UIStatusBarStyle { style }
//
//    var style: UIStatusBarStyle = .default

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
// MARK: Modal Configuration
        reviewModal.transitioningDelegate = self
        reviewModal.modalPresentationStyle = .custom
        reviewModal.offset = modalOffset
        reviewModal.delegate = self
        
        let reviewRatingView = UIView()
        let reviewRatingLabel = UILabel()
        reviewRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewRatingLabel.text = "How was it?"
        reviewRatingLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        reviewRatingLabel.textAlignment = .center
        
        reviewRating.translatesAutoresizingMaskIntoConstraints = false
        reviewRating.mode = .interactable
        reviewRating.style = .grayFill
        reviewRatingView.addSubview(reviewRatingLabel)
        reviewRatingView.addSubview(reviewRating)
        
        NSLayoutConstraint.activate([
            reviewRatingLabel.topAnchor.constraint(equalTo: reviewRatingView.topAnchor, constant: 10),
            reviewRatingLabel.leadingAnchor.constraint(equalTo: reviewRatingView.leadingAnchor),
            reviewRatingLabel.trailingAnchor.constraint(equalTo: reviewRatingView.trailingAnchor),
            reviewRatingLabel.heightAnchor.constraint(equalToConstant: 40),
            
            reviewRating.topAnchor.constraint(equalTo: reviewRatingLabel.bottomAnchor),
            reviewRating.centerXAnchor.constraint(equalTo: reviewRatingView.centerXAnchor),
            reviewRating.widthAnchor.constraint(equalToConstant: reviewRating.width),
            reviewRating.heightAnchor.constraint(equalToConstant: reviewRating.starSize)
        ])
        
        let reviewContentView = UIView()
        let reviewContentLabel = UILabel()
        reviewContentLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewContentLabel.text = "What did you think?"
        reviewContentLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        reviewContentLabel.textAlignment = .center
        
        reviewContentTextField.translatesAutoresizingMaskIntoConstraints = false
        reviewContentTextField.placeholder = "Enter a Description"
        reviewContentTextField.backgroundColor = .darkWhite
        reviewContentTextField.clipsToBounds = true
        reviewContentTextField.layer.cornerRadius = 5
        reviewContentTextField.contentVerticalAlignment = .top
        reviewContentTextField.delegate = self
        
        reviewContentView.addSubview(reviewContentLabel)
        reviewContentView.addSubview(reviewContentTextField)
        
        NSLayoutConstraint.activate([
            reviewContentLabel.topAnchor.constraint(equalTo: reviewContentView.topAnchor),
            reviewContentLabel.leadingAnchor.constraint(equalTo: reviewContentView.leadingAnchor),
            reviewContentLabel.trailingAnchor.constraint(equalTo: reviewContentView.trailingAnchor),
            reviewContentLabel.heightAnchor.constraint(equalToConstant: 40),
            
            reviewContentTextField.topAnchor.constraint(equalTo: reviewContentLabel.bottomAnchor, constant: 10),
            reviewContentTextField.leadingAnchor.constraint(equalTo: reviewContentView.leadingAnchor, constant: 50),
            reviewContentTextField.trailingAnchor.constraint(equalTo: reviewContentView.trailingAnchor, constant: -50),
            reviewContentTextField.bottomAnchor.constraint(equalTo: reviewContentView.bottomAnchor, constant: -20)
        ])
        
        reviewModal.addStage(reviewRatingView)
        reviewModal.addStage(reviewContentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        
        navigationBar.defaultConfiguration(left: true)
        navigationBar.backgroundColor = .clear
        navigationBar.leftBarButton?.tintColor = .white
        navigationBar.leftBarButton?.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 40),
        ])
        
// MARK: Section One
        preview.isUserInteractionEnabled = true
        preview.contentMode = .scaleAspectFill
        preview.clipsToBounds = true
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.setGradient(colors: [.clear, UIColor.black.withAlphaComponent(0.2)])
        
        Managers.shared.databaseManager.image(forPicnic: picnic) { image in
            self.preview.image = image
        }
        
        rating.configure(picnic: picnic)
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.mode = .displayWithCount
    
        liked.translatesAutoresizingMaskIntoConstraints = false
        liked.addTarget(self, action: #selector(likePress), for: .touchUpInside)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = picnic.name
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 40)
        
        preview.addSubview(rating)
        preview.addSubview(liked)
        preview.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            liked.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -20),
            liked.bottomAnchor.constraint(equalTo: preview.bottomAnchor, constant: -10),
            
            nameLabel.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: preview.bottomAnchor, constant: -5),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: liked.leadingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            rating.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 10),
            rating.widthAnchor.constraint(equalToConstant: rating.width),
            rating.heightAnchor.constraint(equalToConstant: rating.starSize),
            rating.bottomAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
        
        stackView.addArrangedSubview(preview)

// MARK: Section Two
        let overviewDivider = UIView()
        overviewDivider.translatesAutoresizingMaskIntoConstraints = false
        overviewDivider.backgroundColor = .lightGray
        
        overview.isEditable = false
        overview.insertText(picnic.userDescription)
        overview.isScrollEnabled = false
        overview.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        overview.textContainerInset = .zero
        overview.textContainer.lineFragmentPadding = .zero
        overview.backgroundColor = .darkWhite
        overview.layer.cornerRadius = 5
        overview.clipsToBounds = true
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.setRegion(MKCoordinateRegion(center: picnic.coordinates.location, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: false)
        let loc = MKPointAnnotation()
        loc.coordinate = picnic.coordinates.location
        loc.title = picnic.name
        map.addAnnotation(loc)
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.showsUserLocation = false
        map.layer.cornerRadius = 8
        map.clipsToBounds = true

        reviews.setup()
        reviews.delegate = self
        Managers.shared.databaseManager.addReviewQuery(for: picnic, limit: 20, queryKey: "Reviews")
        Managers.shared.databaseManager.nextPage(forReviewQueryKey: "Reviews") { reviews in
            self.reviews.update(reviews: reviews)
        }
        reviews.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            preview.widthAnchor.constraint(equalTo: view.widthAnchor),
            preview.heightAnchor.constraint(equalToConstant: kPreviewHeight),
            
            overviewLabel.widthAnchor.constraint(equalToConstant: 370),
            overviewLabel.heightAnchor.constraint(equalToConstant: 30),
            overview.widthAnchor.constraint(equalToConstant: 370),
            overviewDivider.widthAnchor.constraint(equalToConstant: 370),
            overviewDivider.heightAnchor.constraint(equalToConstant: 1),
            
            map.widthAnchor.constraint(equalToConstant: 370),
            map.heightAnchor.constraint(equalToConstant: 220),
            
            reviews.widthAnchor.constraint(equalToConstant: 370),
            reviews.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        stackView.addArrangedSubview(overview)
        stackView.addArrangedSubview(overviewDivider)
        stackView.addArrangedSubview(map)
        stackView.addArrangedSubview(reviews)
        
        view.bringSubviewToFront(navigationBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(true, animated: false)
        Managers.shared.databaseManager.addSaveListener(picnic: picnic, listener: liked) { liked in
            self.liked.setActive(isActive: liked)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        Managers.shared.databaseManager.removeListener(liked)
        Managers.shared.databaseManager.removeQuery("Reviews")
    }
    
    func configure(picnic: Picnic) { self.picnic = picnic }
    
    
    @objc func mapTap(_ sender: UITapGestureRecognizer) {
        // push to fullscreen map view
    }
    
    @objc func backButtonTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func likePress(_ sender: HeartButton) {
        if sender.isActive {
            Managers.shared.databaseManager.unsavePost(picnic: picnic)
        } else {
            Managers.shared.databaseManager.savePost(picnic: picnic)
        }
    }
}

extension DetailController: RatingDelegate {
    func ratingDidChange(newValue: Float) {
        Managers.shared.databaseManager.updateRating(picnic: picnic, value: Int64(newValue))
    }
}

extension DetailController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationBar.isHidden = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        navigationBar.isHidden = false
    }
}

extension DetailController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = ShortPresentationController(presentedViewController: presented, presenting: presenting)
        pc.offset = modalOffset
        return pc
    }
}

extension DetailController: ReviewsDelegate {
    func presentModal() {
         present(reviewModal, animated: true)
    }
}

extension DetailController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
}

extension DetailController: StagedModalControllerDelegate {
    func complete() {
        print("called")
        guard let id = picnic.id else { return }
        let review = Review(
            id: nil,
            pid: id,
            rating: reviewRating.rating,
            content: reviewContentTextField.text ?? "",
            userDisplayName: Managers.shared.auth.currentUser?.displayName,
            userPhotoURL: Managers.shared.auth.currentUser?.photoURL,
            images: nil
        )
        Managers.shared.databaseManager.submitReview(review: review)
    }
}
