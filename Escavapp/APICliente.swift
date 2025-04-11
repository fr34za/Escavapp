//
//  APICliente.swift
//  Escavapp
//
//  Created by Felipe Freaza on 11/04/25.
//
// Main View (SwiftUI)
import SwiftUI

struct ContentView: View {
    @State private var cnpj = ""
    @State private var lawyerId = ""
    @State private var lawsuits: [Lawsuit] = []
    @State private var latestCase: LawyerCase?
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Consultar Empresa por CNPJ")) {
                    TextField("CNPJ (somente números)", text: $cnpj)
                        .keyboardType(.numberPad)
                    
                    Button("Buscar Processos") {
                        Task {
                            await searchCompanyCases()
                        }
                    }
                    
                    if !lawsuits.isEmpty {
                        Text("Processos encontrados: \(lawsuits.count)")
                            .font(.subheadline)
                        
                        ForEach(lawsuits, id: \.numero_processo) { lawsuit in
                            VStack(alignment: .leading) {
                                Text(lawsuit.numero_processo)
                                    .fontWeight(.bold)
                                
                                // Verificar se há partes antes de exibir
                                if !lawsuit.partes.isEmpty {
                                    Text("Partes: \(lawsuit.partes.map { $0.nome }.joined(separator: ", "))")
                                } else {
                                    Text("Partes não informadas")
                                        .foregroundColor(.secondary)
                                }
                                
                                // Tratar data opcional
                                if let data = lawsuit.data_distribuicao, !data.isEmpty {
                                    Text("Distribuição: \(data)")
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                Section(header: Text("Último Processo do Advogado")) {
                    TextField("ID do Advogado", text: $lawyerId)
                        .keyboardType(.numberPad)
                    
                    Button("Buscar Último Processo") {
                        Task {
                            await searchLawyerCase()
                        }
                    }
                    
                    if let ultimoProcesso = latestCase { // 👈 tentei usar 'case' aqui mas é uma palavra reservada em Swift. Aprendido
                        VStack(alignment: .leading) {
                            Text(ultimoProcesso.processo.numero_processo)
                                .fontWeight(.bold)
                            
                            // Verificação correta para optional + string vazia
                            if let ultimaMov = ultimoProcesso.data_ultima_movimentacao, !ultimaMov.isEmpty {
                                Text("Última movimentação: \(ultimaMov)")
                            } else {
                                Text("Data de movimentação não disponível")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Escavador APP")
        }
    }
    
    private func searchCompanyCases() async {
        do {
            lawsuits = try await APIClient.shared.fetchLawsuitsByCNPJ(cnpj: cnpj)
            errorMessage = ""
        } catch {
            errorMessage = "Erro na busca: \(error.localizedDescription)"
        }
    }
    
    private func searchLawyerCase() async {
        guard let id = Int(lawyerId) else {
            errorMessage = "ID inválido"
            return
        }
        
        do {
            latestCase = try await APIClient.shared.fetchLatestLawyerCase(lawyerId: id)
            errorMessage = ""
        } catch {
            errorMessage = "Erro na busca: \(error.localizedDescription)"
        }
    }
}
