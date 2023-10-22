//
//  YemekHucre.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 9.10.2023.
//

import UIKit

class YemekHucre: UITableViewCell {

    @IBOutlet weak var yemekResim: UIImageView!
    @IBOutlet weak var labelYemekAdi: UILabel!
    @IBOutlet weak var labelYemekFiyat: UILabel!
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var buttonEkle: UIButton!
    @IBOutlet weak var buttonAzalt: UIButton!
    @IBOutlet weak var buttonArtir: UIButton!
    @IBOutlet weak var labelMaxAdet: UILabel!
    
    var viewModel = AnasayfaViewModel()
    
    var adet:Int?
    var resimAdi = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let adetText = labelAdet.text, let adetValue = Int(adetText) {
            adet = adetValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonAzalt(_ sender: Any) {
        if adet == 0 {
            buttonArtir.isEnabled = true
            labelMaxAdet.isHidden = true
            return
        } else {
            adet = adet! - 1
            labelAdet.text = String(adet!)
            buttonArtir.isEnabled = true
            labelMaxAdet.isHidden = true
            if adet == 0 {
                labelMaxAdet.isHidden = true
                buttonArtir.isEnabled = true
                buttonEkle.isHidden = true
            }
        }
    }
    
    @IBAction func buttonArtir(_ sender: Any) {
        
        adet = max(0, adet! + 1)
        
        if adet! >= 9 {
            labelAdet.text = "9"
            labelMaxAdet.isHidden = false
            buttonArtir.isEnabled = false
            return
        }else{
            buttonArtir.isEnabled = true
            labelAdet.text = String(adet!)
        }
        buttonEkle.isHidden = false
    }
    
    @IBAction func buttonEkle(_ sender: Any) {
        guard let fiyatText = labelYemekFiyat.text?.replacingOccurrences(of: " ₺", with: ""), let fiyat = Int(fiyatText) else {
            print("Hata: Fiyat bilgisi alınamadı.")
            return
        }

        viewModel.sepeteEkle(yemek_adi: labelYemekAdi.text!, yemek_resim_adi: resimAdi, yemek_fiyat: fiyat, yemek_siparis_adet: adet!)
    }
    
    func resetAdet() {
        adet = 0
        labelAdet.text = "0"
        buttonEkle.isHidden = true
    }
    
}
