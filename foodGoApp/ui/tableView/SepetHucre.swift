//
//  SepetHucre.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 12.10.2023.
//

import UIKit

protocol sepetCellProtocol{
    func siparisSil(indexPath:IndexPath)
    func updateToplamTutar()
    func adetSil(indexPath:IndexPath)
    func adetEkle(indexPath:IndexPath)
}

class SepetHucre: UITableViewCell {

    @IBOutlet weak var yemekResim: UIImageView!
    @IBOutlet weak var labelYemekAdi: UILabel!
    @IBOutlet weak var labelYemekFiyat: UILabel!
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var labelMaxAdet: UILabel!
    @IBOutlet weak var buttonAzalt: UIButton!
    @IBOutlet weak var buttonArtir: UIButton!
    
    var viewModel = SepetScreenViewModel()
    var adet:Int?
    
    var SepetProtocol: sepetCellProtocol?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if labelAdet.text == "9" {
            labelMaxAdet.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        SepetProtocol?.updateToplamTutar()
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // View yüklendiğinde, label'dan değeri al
        adet = Int(labelAdet.text ?? "0")
    }
    
    @IBAction func buttonAzalt(_ sender: Any) {
        
        adet = max(0, adet! - 1)
        updateAdetLabel()
        SepetProtocol?.updateToplamTutar()
        if adet == 0, let indexPath = indexPath {
            buttonArtir.isEnabled = true
            labelMaxAdet.isHidden = true
            if adet == 0 {
                labelAdet.text = "1"
            }
            SepetProtocol?.siparisSil(indexPath: indexPath)
        }else{
            SepetProtocol?.adetSil(indexPath: indexPath!)
            buttonArtir.isEnabled = true
            labelMaxAdet.isHidden = true
            labelAdet.text = String(adet!)
        }

    }

    
    @IBAction func buttonArtir(_ sender: Any) {

        adet = max(0, adet! + 1)
        updateAdetLabel()
        SepetProtocol?.updateToplamTutar()
        if adet! >= 9 {
            labelAdet.text = "9"
            SepetProtocol?.adetEkle(indexPath: indexPath!)
            labelMaxAdet.isHidden = false
            buttonArtir.isEnabled = false
            return
        }else{
            buttonArtir.isEnabled = true
            labelAdet.text = String(adet!)
        }
        SepetProtocol?.adetEkle(indexPath: indexPath!)
    }
    
    func updateAdetLabel() {
        labelAdet.text = String(adet!)
    }
    
}



