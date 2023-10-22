//
//  OdemeScreenViewModel.swift
//  foodGoApp
//
//  Created by Turgay KIRKIL on 22.10.2023.
//

import Foundation

class OdemeScreenViewModel {
    var yrepo = YemekDaoRepository()
    
    func sepetiBosalt(sepet_yemek_id:Int) {
        yrepo.sepetiBosalt(sepet_yemek_id: sepet_yemek_id, completion: {
            //self.sepetYukle()
        })
    }
}
