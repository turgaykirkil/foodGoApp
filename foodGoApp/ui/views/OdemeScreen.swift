//
//  OdemeScreen.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 12.10.2023.
//

import UIKit

class OdemeScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textCard1: UITextField!
    @IBOutlet weak var textCard2: UITextField!
    @IBOutlet weak var textCard3: UITextField!
    @IBOutlet weak var textCard4: UITextField!
    @IBOutlet weak var textAyYil: UITextField!
    @IBOutlet weak var textCVV: UITextField!
    
    @IBOutlet weak var labelBaslik: UILabel!
    @IBOutlet weak var labelSiparisOzeti: UILabel!
    
    var viewModel = OdemeScreenViewModel()
    
    var sepetDetaylari: (String, Int, String)?
    var izinKontrol = false
    var sepet_yemek_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            granted, error in
            
            self.izinKontrol = granted
            if granted {
                print("izin alma işlemi başarılı")
            }else{
                print("izin alma işlemi başarısız")
            }
        })
        
        // Text field'ları delegate olarak ayarla
        textCard1.delegate = self
        textCard2.delegate = self
        textCard3.delegate = self
        textCard4.delegate = self
        textAyYil.delegate = self
        textCVV.delegate = self

        // İlk text field'i aktif hale getir ve klavyeyi aç
        textCard1.becomeFirstResponder()
        
        if let detaylar = sepetDetaylari {
            labelSiparisOzeti.text = detaylar.0
            labelBaslik.text = "Sipariş Özeti\nToplam Tutar: \(detaylar.1) ₺"
            self.sepet_yemek_id = detaylar.2
        }
        
        // Ekranın herhangi bir yerine dokunulduğunda klavyenin kapanması için gesture recognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(tapGesture)

    }
    
    // Klavyeyi kapat
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // Maksimum karakter sınırlarını kontrol et
        let maxLength: Int
        print(currentText)
        switch textField {
            case textCard1, textCard2, textCard3, textCard4:
                maxLength = 4
            case textAyYil:
                maxLength = 7
                if textAyYil.text?.count == 1 && !string.isEmpty {
                    print(currentText)
                    textAyYil.text = newText + "/"
                    return false
                }
            case textCVV:
                maxLength = 3
                if textCVV.text?.count == maxLength {
                    textField.resignFirstResponder() // Klavyeyi kapat
                }
            default:
                maxLength = Int.max
        }

        // Geçişleri kontrol et
        if newText.count == maxLength, let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField, let previousTextField = view.viewWithTag(textField.tag) as? UITextField {
            previousTextField.text = (previousTextField.text!) + string
            nextTextField.becomeFirstResponder()
        }
        print("-------")
        return newText.count <= maxLength
    }




    
    @IBAction func buttonKapat(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonPaylas(_ sender: Any) {
        print("paylaş butonuna doknuldu")
    }
    
    @IBAction func buttonOdeme(_ sender: Any) {
        if izinKontrol {
            let icerik = UNMutableNotificationContent()
            icerik.title = "Siparişin Alındı"
            icerik.body = "Siparişini takip etmek için bildirime dokun!"
            //icerik.badge = 1
            icerik.sound = .default
            
            let tetikleme = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let istek = UNNotificationRequest(identifier: "id", content: icerik, trigger: tetikleme)
            UNUserNotificationCenter.current().add(istek)
        }
        
        viewModel.sepetiBosalt(sepet_yemek_id: Int(sepet_yemek_id!)!)
        
        
        performSegue(withIdentifier: "odemeToTakip", sender: nil)
    }
    
    @IBAction func buttonIptal(_ sender: Any) {
        print("iptal buton")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension OdemeScreen: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Bildirim seçildi")
        
        let app = UIApplication.shared
        
        if app.applicationState == .active {
            print("ön plan bildirim seçildi")
        }
        
        if app.applicationState == .inactive {
            print("arka plan bildirim seçildi")
        }
        
        app.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
}
