//
//  SepetScreenViewModel.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 12.10.2023.
//

import Foundation
import RxSwift

class SepetScreenViewModel {
    var yrepo = YemekDaoRepository()
    var sepetListesi = BehaviorSubject<[Sepetim]>(value: [Sepetim]())
    
    init() {
        sepetListesi=yrepo.sepetListesi
    }

    func sepeteOnayla(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int){
        
        yrepo.sepeteEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, completion: {})
    }

    func sepettenSil(sepet_yemek_id:Int) {
        yrepo.sepettenSil(sepet_yemek_id: sepet_yemek_id, completion: {
            //self.sepetYukle()
        })
    }
    
    func sepettenUrunSil(sepet_yemek_id:Int) {
        yrepo.sepettenUrunSil(sepet_yemek_id: sepet_yemek_id, completion: {
            self.sepetYukle()
        })
    }
    
    func sepetYukle(){
        yrepo.sepetYukle(completion: {})
    }

}
