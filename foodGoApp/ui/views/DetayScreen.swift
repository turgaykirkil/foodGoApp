//
//  DetayScreen.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 8.10.2023.
//

import UIKit

class DetayScreen: UIViewController {

    @IBOutlet weak var yemekResim: UIImageView!
    @IBOutlet weak var labelYemekAdi: UILabel!
    @IBOutlet weak var labelYemekFiyat: UILabel!
    @IBOutlet weak var labelMaxAdet: UILabel!
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var buttonAzalt: UIButton!
    @IBOutlet weak var buttonArtir: UIButton!
    
    var viewModel = DetayScreenViewModel()
    
    var adet: Int?
    var yemek: Yemekler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let y = yemek {
            labelYemekAdi.text = y.yemek_adi
            labelYemekFiyat.text = "\(y.yemek_fiyat!) ₺"
            labelAdet.text = String(adet ?? 9)
            yemekResim.image = UIImage(named: y.yemek_resim_adi!)
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(y.yemek_resim_adi!)") {
                DispatchQueue.main.async {
                    self.yemekResim.kf.setImage(with: url)
                }
            }
        }
    }
    

    @IBAction func buttongeri(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPaylas(_ sender: Any) {
        print("paylaş butonuna dokunuldu")
    }
    
    @IBAction func buttonAzalt(_ sender: Any) {
        adet = max(1, adet! - 1)
        if adet == 0 {
            buttonArtir.isEnabled = true
            labelMaxAdet.isHidden = true
            self.dismiss(animated: true, completion: nil)
            return
        } else {
            labelMaxAdet.isHidden = true
            buttonArtir.isEnabled = true
            adet = (adet ?? 0) - 1
            labelAdet.text = String(adet!)
        }
    }
    
    @IBAction func buttonArtir(_ sender: Any) {
        adet = max(1, adet! + 1)
        if adet! >= 9 {
            labelAdet.text = "9"
            labelMaxAdet.isHidden = false
            buttonArtir.isEnabled = false
            return
        }else{
            buttonArtir.isEnabled = true
            labelAdet.text = String(adet!)
        }
        labelAdet.text = String(adet!)
    }
    
    @IBAction func buttonSepeteEkle(_ sender: Any) {

        viewModel.sepeteEkle(yemek_adi: yemek?.yemek_adi ?? "", yemek_resim_adi: yemek?.yemek_resim_adi ?? "", yemek_fiyat: Int(yemek?.yemek_fiyat ?? "")!, yemek_siparis_adet: adet ?? 0)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
