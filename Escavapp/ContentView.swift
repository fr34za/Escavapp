//
//  ContentView.swift
//  Escavapp
//
//  Created by Felipe Freaza on 11/04/25.
//

// ViewController.swift
import UIKit

struct LawsuitResponse: Codable {
    let data: [Lawsuit]
}

struct Lawsuit: Codable {
    let numero_processo: String
    let partes: [Parte]
    let data_distribuicao: String?
}

struct Parte: Codable {
    let nome: String
}

struct LawyerResponse: Codable {
    let data: [LawyerCase]
}

struct LawyerCase: Codable {
    let processo: Lawsuit
    let data_ultima_movimentacao: String?
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://api.escavador.com/api/v2"
    private let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOGNmY2I1NjhhNmFiNzk2NDE4M2EwZGY4YWJhMmU2ZTBkOTM4MTQ5ZTY0MDZiZWY2ZGUzNzhhZDQ4YjdiODEwNjQ3ZjUxMjcxZDhmYzNlYzQiLCJpYXQiOjE3NDQ0MDE4NzIuNTE1MzMzLCJuYmYiOjE3NDQ0MDE4NzIuNTE1MzM1LCJleHAiOjIwNTk5MzQ2NzIuNTEyMDgzLCJzdWIiOiIyNDA5Mjk5Iiwic2NvcGVzIjpbImFjZXNzYXJfYXBpX3BhZ2EiLCJhY2Vzc2FyX2FwaV9wbGF5Z3JvdW5kIl19.UNPP3GexARid-mRkSIP6E24JUegdhemKxFxhsvzXN-5GGeGIEvHM5R-DZhSzuHwIoORBn9kTgbft5abEqiv-0roI_wWlsv39n4XB8uPGYtr4ngpEGTRZ1Hf7XRr1B1RD7gTsWkPtce8BW4ruA6avig6rT4VbVKxsiYXFM2TJYyw5yjIdPRRQA3LzBBvIfZXVfWT7d3nUuvHJjqF3ub25P1D3cVBZQHRsy2792CP5zQMHC_-fradNob1fDKZ6ypTbVm_lUrAH6IHGR2OrCUT5mtaDfRFUERroqNZJIZOa__tpHqB2hLI33-q5HoKWLt2aSVrQfQlLOFGJwPN6U0zkaUoB7t4DakmhRpbEcu4jEt_-iqfJ0FDRzy0qKlU1gUQIO_7ce6Hn3o0mUSBHE985Sg35Z2hwYoGnMf8Hz0o4mYzHsDEA8sHS-cbYg27BE05MuETXjTazsPit7Q21orcHU4eLolfzk-l10RGmVLypOM1WgkKd22itoup0ArgDU2KlX690xmr5uWU1Ked1nUGgJLe5Gx87O05D0TYspT8hRK0sNOPQeYhnWylps_pwB4-eDo65oxj0Gsx7MOw6JDAFC8nUA9KbIWdD8Rt9g21xlQsmPFbv0ZH4INowEmuTuTkQr3G0zmcX0osGIIhYrLmVLn3EAEbFZbrycx6nb83Vqm8" // 👈 token
    
    private init() {}
    
    func fetchLawsuitsByCNPJ(cnpj: String) async throws -> [Lawsuit] {
        let url = URL(string: "\(baseURL)/processos-empresa?q=\(cnpj)")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(LawsuitResponse.self, from: data)
        return response.data
    }
    
    func fetchLatestLawyerCase(lawyerId: Int) async throws -> LawyerCase? {
        let url = URL(string: "\(baseURL)/processos-advogado/\(lawyerId)")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(LawyerResponse.self, from: data)
        return response.data.first
    }
}
