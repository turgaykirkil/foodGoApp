import UIKit

class ProfilScreen: UIViewController {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile") // Varsayılan profil resmi
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Turgay Kırkıl"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "turgaykirkil@me.com"
        label.textColor = .gray
        return label
    }()

    let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profili Düzenle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white

        // Profile Image
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Name Label
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true

        // Email Label
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true

        // Edit Profile Button
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc func editProfileButtonTapped() {
        // Profil düzenleme ekranına geçiş yapabilirsin
        // Örneğin, bir segue veya navigationController kullanabilirsin
        // Örneğin: performSegue(withIdentifier: "toEditProfile", sender: nil)
    }

    @IBAction func buttonKapat(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
