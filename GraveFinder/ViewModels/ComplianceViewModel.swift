//
//  ComplianceViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-21.
//

import SwiftUI
import CryptoKit

class ComplianceViewModel {

    func encrypt(string:String, password:String) -> Data? {
        let key = createKeyFromPassword(password)
        let dataToEncrypt = string.data(using: .utf8)!
        let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: key)
        return sealedBox?.combined
    }
    
    func decrypt(data:Data, password:String) -> String? {
        let key = createKeyFromPassword(password)
        if let sealedBox = try? ChaChaPoly.SealedBox(combined: data),
           let decrypted = try? ChaChaPoly.open(sealedBox, using: key) {
            return String(decoding: decrypted, as: UTF8.self)
        }
        return nil
    }
    func createKeyFromPassword(_ password: String) -> SymmetricKey {
      let hash = SHA256.hash(data: password.data(using: .utf8)!)
      let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
      let subString = String(hashString.prefix(32))
      let keyData = subString.data(using: .utf8)!

      return SymmetricKey(data: keyData)
    }
}
