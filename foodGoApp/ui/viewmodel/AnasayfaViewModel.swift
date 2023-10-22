//
//  AnasayfaViewModel.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 12.10.2023.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var yrepo = YemekDaoRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemeklerListesi=yrepo.yemeklerListesi
    }
    
    func sepeteEkle(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int){
        
        yrepo.sepeteEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, completion: {})
    }
    
    func ara(aramaKelimesi:String) {
        yrepo.ara(aramaKelimesi: aramaKelimesi)
        yemekleriYukle()
    }
    
    func yemekleriYukle(){
        yrepo.yemekleriYukle()
    }
}
