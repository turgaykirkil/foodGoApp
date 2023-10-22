import UIKit

class LoginScreen: UIViewController {

    @IBOutlet weak var labelKullaniciAdi: UITextField!
    @IBOutlet weak var labelSifre: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Gesture recognizer ekleyerek klavyenin dışına tıklama olayını tanımla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(klavyeninDisinaTiklandi))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func buttonGirisYap(_ sender: Any) {
        // Kullanıcı adı ve şifre kontrolü
        guard let kullaniciAdi = labelKullaniciAdi.text, kullaniciAdi.isValidEmail() else {
            showAlert(message: "Geçerli bir e-posta adresi girin.")
            return
        }
        
        // Şifrenin büyük harf, küçük harf ve sayı içerip içermediğini kontrol et
        guard let sifre = labelSifre.text, sifre.isValidPassword() else {
            showAlert(message: "Şifre en az bir büyük harf, bir küçük harf ve bir sayı içermelidir.")
            return
        }
        
        // Geçerli kullanıcı adı ve şifreyle giriş yapma işlemleri buraya gelecek
        performSegue(withIdentifier: "loginToApp", sender: self)
    }

    @IBAction func buttonSifremiUnuttum(_ sender: Any) {
        // Şifremi Unuttum butonuna basıldığında
        let alert = UIAlertController(title: "Şifremi Unuttum", message: "Şifrenizi sıfırlamak için e-posta adresinizi girin.", preferredStyle: .alert)
        
        var emailTextField: UITextField?

        alert.addTextField { (textField) in
            textField.placeholder = "E-posta Adresi"
            emailTextField = textField
        }
        
        let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let gonderAction = UIAlertAction(title: "Gönder", style: .default) { (action) in
            // Gönder butonuna basıldığında
            if let email = emailTextField?.text {
                self.showConfirmationAlert(email: email)
            }
        }
        
        alert.addAction(iptalAction)
        alert.addAction(gonderAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(email: String) {
        // Şifre sıfırlama maili gönderildiğinde
        let confirmationAlert = UIAlertController(title: "Mail Gönderildi", message: "Şifre sıfırlama maili \(email) adresine gönderildi.", preferredStyle: .alert)
        
        let tamamAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        confirmationAlert.addAction(tamamAction)
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Klavyenin dışına tıklandığında çağrılacak fonksiyon
    @objc func klavyeninDisinaTiklandi() {
        view.endEditing(true)
    }
}

extension String {
    // E-posta adresi geçerliliğini kontrol etmek için bir extension ekledik
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    // Şifre gücünü kontrol etmek için bir extension ekledik
    func isValidPassword() -> Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{6,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
