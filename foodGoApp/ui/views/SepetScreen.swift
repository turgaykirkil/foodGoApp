//
//  SepetScreen.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 11.10.2023.
//

import UIKit
import RxSwift

class SepetScreen: UIViewController {

    @IBOutlet weak var labelLogo: UILabel!
    @IBOutlet weak var labelToplamTutar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = SepetScreenViewModel()
    var AnasayfaVM = AnasayfaViewModel()
    var sepetListesi = [Sepetim]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        _ = viewModel.sepetListesi.subscribe(onNext: { liste in
            self.sepetListesi = liste
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }

    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.sepetYukle()
    }
    
    @IBAction func buttonKapat(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonPaylas(_ sender: Any) {
        print("paylaş butonuna doknuldu")
    }
    @IBAction func buttonOdemeYap(_ sender: Any) {
        performSegue(withIdentifier: "sepetToOdeme", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sepetToOdeme" {
            if let odemeScreen = segue.destination as? OdemeScreen {
                // Sepet detaylarını ve toplam ödeme tutarını OdemeScreen'e taşı
                odemeScreen.sepetDetaylari = sepetDetaylariniAl()
            }
        }
    }
}


extension SepetScreen: UITableViewDelegate, UITableViewDataSource, sepetCellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        let sepet = sepetListesi[indexPath.row]
        
        hucre.labelYemekAdi.text = sepet.yemek_adi
        hucre.labelYemekFiyat.text = "\(sepet.yemek_fiyat!) ₺"
        hucre.labelAdet.text = sepet.yemek_siparis_adet!
        //hucre.yemekResim.image = UIImage(named: sepet.yemek_resim_adi!)
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(sepet.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                hucre.yemekResim.kf.setImage(with: url)
            }
        }

        // SepetProtocol ve indexPath'i atayalım
        hucre.SepetProtocol = self
        hucre.indexPath = indexPath

        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let yemek = sepetListesi[indexPath.row]
        //performSegue(withIdentifier: "appToDetay", sender: yemek)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completionHandler) in
            // Silme işlemi için alert göster
            self?.showRemoveItemAlert(indexPath: indexPath)
            
            // completionHandler çağrılarak işlemin bitirildiği belirtilir
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func adetEkle(indexPath: IndexPath) {
        let sepet = sepetListesi[indexPath.row]
        print("1 adet eklendi")
        AnasayfaVM.sepeteEkle(yemek_adi: sepet.yemek_adi!, yemek_resim_adi: sepet.yemek_resim_adi!, yemek_fiyat: Int(sepet.yemek_fiyat!)!, yemek_siparis_adet: 1)
        viewModel.sepetYukle()
        
    }
    
    func adetSil(indexPath: IndexPath) {
        print("1 adet silindi")
        let sepet = sepetListesi[indexPath.row]
        //print(sepet.sepet_yemek_id)
        viewModel.sepettenUrunSil(sepet_yemek_id: Int(sepet.sepet_yemek_id!)!)
        viewModel.sepetYukle()
        
    }
    
    func siparisSil(indexPath: IndexPath) {
        //let yemek = sepetListesi[indexPath.row]
        showRemoveItemAlert(indexPath: indexPath)
    }

    func showRemoveItemAlert(indexPath: IndexPath) {
        let yemek = sepetListesi[indexPath.row]
        let alertController = UIAlertController(title: "Dikkat!", message: "Ürünü sepetten çıkartmak istediğinize emin misiniz?", preferredStyle: .alert)
        
        let hayirAction = UIAlertAction(title: "Hayır", style: .default, handler: { _ in
            // Hayır butonuna basıldığında yapılacak işlemler (herhangi bir işlem olmadığı için boş bıraktık)
        })
        
        let evetAction = UIAlertAction(title: "Evet", style: .destructive, handler: { [weak self] _ in
            self!.viewModel.sepettenSil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!)
            self?.removeItem(at: indexPath)
        })

        alertController.addAction(hayirAction)
        alertController.addAction(evetAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func removeItem(at indexPath: IndexPath) {
        // IndexPath'teki öğeyi listeden kaldır
        sepetListesi.remove(at: indexPath.row)
        
        // TableView'ı güncelle
        tableView.deleteRows(at: [indexPath], with: .none)
        
        // Toplam tutarı güncelle
        updateToplamTutar()
        
        // Eğer silinen hücre son hücre değilse ve listede hala eleman varsa
        // Silinen hücrenin sırasında olan hücreleri güncelle
        if indexPath.row < sepetListesi.count {
            tableView.reloadRows(at: (indexPath.row..<sepetListesi.count).map { IndexPath(row: $0, section: 0) }, with: .none)
        }
    }

    func updateToplamTutar() {
        // Sepetin güncel toplam tutarını hesapla
        let toplamTutar = sepetListesi.reduce(0) { $0 + (Int($1.yemek_fiyat ?? "0") ?? 0) * (Int($1.yemek_siparis_adet ?? "0") ?? 0) }
        
        // Toplam tutarı label'a aktar
        labelToplamTutar.text = "Toplam Tutar: \(toplamTutar) ₺"
    }
    
    func sepetDetaylariniAl() -> (String, Int, String) {
        // Sepet detaylarını al ve tuple olarak döndür
        var siparisDetayi = ""
        var toplamTutar = 0
        var sepet_yemek_id = ""

        for sepet in sepetListesi {
            // Her bir ürünün detayını siparisDetayi'ne ekle
            siparisDetayi += "\(sepet.yemek_adi!) - \(sepet.yemek_siparis_adet!) adet - "
            // Toplam tutarı güncelle
            toplamTutar += (Int(sepet.yemek_fiyat ?? "0") ?? 0) * (Int(sepet.yemek_siparis_adet ?? "0") ?? 0)
            // Sepet yemek ID'sini güncelle
            sepet_yemek_id = sepet.sepet_yemek_id!
        }

        return (siparisDetayi, toplamTutar, sepet_yemek_id)
    }


}
