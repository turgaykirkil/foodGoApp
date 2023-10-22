//
//  YemekDaoRepository.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 12.10.2023.
//

import Foundation
import RxSwift
import Alamofire

class YemekDaoRepository {
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetListesi = BehaviorSubject<[Sepetim]>(value: [Sepetim]())
    
    let kullanici_adi="turgay.kirkil"
    
    func sepeteEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, completion: @escaping () -> Void) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php")!
        let params: Parameters = ["yemek_adi": yemek_adi, "yemek_resim_adi": yemek_resim_adi, "yemek_fiyat": yemek_fiyat, "yemek_siparis_adet": yemek_siparis_adet, "kullanici_adi": kullanici_adi]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    _ = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func ara(aramaKelimesi:String) {
        print(aramaKelimesi)
    }
    
    
    
    func sepettenSil(sepet_yemek_id:Int, completion: @escaping () -> Void) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
        sepetiYukle { liste in
            for i in liste {
                if Int(i.sepet_yemek_id!) == sepet_yemek_id {
                    for j in liste {
                        if j.yemek_adi == i.yemek_adi {
                            print("Tespit Edilen ID : \(j.sepet_yemek_id!)")
                            let params:Parameters = ["sepet_yemek_id":j.sepet_yemek_id!,"kullanici_adi":self.kullanici_adi]
                            AF.request(url, method: .post, parameters: params).response {
                                response in
                                if let data=response.data {
                                    do{
                                        _ = try JSONDecoder().decode(CRUDCevap.self, from: data)
                                        print("Sepetten silinen ID : \(sepet_yemek_id)")
                                        completion()
                                    }catch{
                                        print("Silme hatası : \(error.localizedDescription)")
                                    }
                                }
                            }
                            completion()
                        }
                    }
                }
            }
        }
    }

    
    
    func sepettenUrunSil(sepet_yemek_id:Int, completion: @escaping () -> Void) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
        
        let params:Parameters = ["sepet_yemek_id":sepet_yemek_id,"kullanici_adi":kullanici_adi]
        AF.request(url, method: .post, parameters: params).response {
            response in
            if let data=response.data {
                do{
                    _ = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Sepetten silinen tek ID : \(sepet_yemek_id)")
                    completion()
                }catch{
                    print("Silme hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func yemekleriYukle(){
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")!
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler{
                        var sortedList = liste
                        sortedList.sort { $0.yemek_adi! < $1.yemek_adi! }
                        self.yemeklerListesi.onNext(liste)
                    }
                }catch{
                    print("Yemekleri Yükle hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sepetiYukle(completion: @escaping ([Sepetim]) -> Void) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php")!
        
        let params: Parameters = ["kullanici_adi": kullanici_adi]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(SepetimCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler {
                        for i in liste {
                            print("Sepet Yükle ID : \(i.sepet_yemek_id!)")
                        }
                        completion(liste)
                    }
                } catch {
                    print("Sepet Yükle hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sepetYukle(completion: @escaping () -> Void){
        self.sepetListesi.onNext([])
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php")!
        
        let params:Parameters = ["kullanici_adi":kullanici_adi]
        AF.request(url, method: .post, parameters: params).response {
            response in
            if let data=response.data {
                do{
                    let cevap = try JSONDecoder().decode(SepetimCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler{
                        var groupedItems: [String: Sepetim] = [:]

                        for item in liste {
                            if let existingItem = groupedItems[item.yemek_adi ?? ""] {
                                // Eğer ürün zaten ekliyse, adedini arttır
                                existingItem.yemek_siparis_adet = "\(Int(existingItem.yemek_siparis_adet ?? "0")! + Int(item.yemek_siparis_adet ?? "0")!)"

                                // Hata ayıklama için ekstra çıktı
                                print("Ürün zaten ekli. \(existingItem.yemek_adi ?? "") - Adet: \(existingItem.yemek_siparis_adet ?? "")")
                            } else {
                                // Eğer ürün yoksa, listeye ekle
                                groupedItems[item.yemek_adi ?? ""] = item

                                // Hata ayıklama için ekstra çıktı
                                print("Ürün ekleniyor. \(item.yemek_adi ?? "") - Adet: \(item.yemek_siparis_adet ?? "")")
                            }
                        }

                        // Gruplandırılmış ürünleri diziyi çıkart
                        let updatedList = Array(groupedItems.values).sorted { $0.yemek_adi! < $1.yemek_adi! }


                        for i in updatedList {
                            print("Sepet Yükle ID : \(i.sepet_yemek_id ?? "")")
                        }

                        
                        // Toplanmış ürünleri sepetListesi'ne onNext çağrısı ile gönder
                        self.sepetListesi.onNext(updatedList)

                        // Completion kapanışını çağır
                        completion()
                    }
                }catch{
                    self.sepetListesi.onNext([])
                    print("Sepet Yükle hatası : \(error.localizedDescription)")
                }
            }
        }
    }

    func sepetiBosalt(sepet_yemek_id:Int, completion: @escaping () -> Void) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
        sepetiYukle { liste in
            for i in liste {
                let params:Parameters = ["sepet_yemek_id":i.sepet_yemek_id!,"kullanici_adi":self.kullanici_adi]
                AF.request(url, method: .post, parameters: params).response {
                    response in
                    if let data=response.data {
                        do{
                            _ = try JSONDecoder().decode(CRUDCevap.self, from: data)
                            print("Sepetten silinen ID : \(sepet_yemek_id)")
                            completion()
                        }catch{
                            print("Silme hatası : \(error.localizedDescription)")
                        }
                    }
                }
                completion()
            }
        }
    }
     
    
}
