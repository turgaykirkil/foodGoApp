//
//  ViewController.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 7.10.2023.
//

import UIKit
import RxSwift
import Kingfisher

class Anasayfa: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var labelLogo: UILabel!
    @IBOutlet weak var labelAdres: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = AnasayfaViewModel()
    var yemeklerListesi = [Yemekler]()
    var izinKontrol = false
    
    // Sepet durumu için bir değişken tanımla
    var sepetDurumu: Bool = false
        
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
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Klavyeyi kapat
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.yemekleriYukle()
    }

    
    @IBAction func buttonSolMenu(_ sender: Any) {
        print("sol menü açıldı")
    }
    
    @IBAction func buttonProfil(_ sender: Any) {
        performSegue(withIdentifier: "appToProfil", sender: nil)
    }
    
    @IBAction func buttonAdres(_ sender: Any) {
        performSegue(withIdentifier: "appToAdres", sender: nil)
    }
    
    @IBAction func buttonSepetim(_ sender: Any) {
        performSegue(withIdentifier: "appToSepet", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appToDetay" {
            if let data = sender as? [Any], let yemek = data[0] as? Yemekler, let adet = data[1] as? Int {
                let gidilecekVC = segue.destination as! DetayScreen
                gidilecekVC.yemek = yemek
                gidilecekVC.adet = adet
            }
        }
    }
}

extension Anasayfa: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "yemekHucre") as! YemekHucre
        let yemek = yemeklerListesi[indexPath.row]
        
        hucre.labelYemekAdi.text = yemek.yemek_adi!
        hucre.labelYemekFiyat.text = "\(yemek.yemek_fiyat!) ₺"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                hucre.yemekResim.kf.setImage(with: url)
            }
        }
        //hucre.yemekResim.image = UIImage(named: yemek.yemek_resim_adi!)
        hucre.resimAdi = yemek.yemek_resim_adi!
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let hucre = tableView.cellForRow(at: indexPath) as? YemekHucre else {
            return
        }
        
        var adet: Int = 0
        
        if let adetText = hucre.labelAdet.text, let adetValue = Int(adetText) {
            if adetValue > 0 {
                adet = adetValue
            }else if adetValue == 0 {
                adet = 1
            }
            
        }
        
        let yemek = yemeklerListesi[indexPath.row]
        performSegue(withIdentifier: "appToDetay", sender: [yemek, adet] as [Any])
        
        hucre.resetAdet()
    }
}

extension Anasayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Yemekler listesini filtrele
        if searchText.count > 0 {
            let filtrelenmisYemekler = yemeklerListesi.filter { yemek in
                return yemek.yemek_adi?.lowercased().contains(searchText.lowercased()) ?? false
            }

            // Filtrelenmiş listeyi kullanarak tableView'i güncelle
            self.yemeklerListesi = filtrelenmisYemekler
            self.tableView.reloadData()
        } else {
            viewModel.yemekleriYukle()
        }
        
    }
    
}
