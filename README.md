# Multiverse

**Multiverse** é um aplicativo iOS desenvolvido com Swift, utilizando a [Rick and Morty API](https://rickandmortyapi.com/) para listar e exibir detalhes de personagens, episódios e locais da série **Rick and Morty**.

---

## 🛠️ Tecnologias Utilizadas

- **Swift**: Linguagem principal do desenvolvimento do aplicativo.
- **CocoaPods**: Gerenciador de dependências para integrar bibliotecas de terceiros.
- **Bibliotecas Utilizadas**:
  - [**SDWebImage**](https://github.com/SDWebImage/SDWebImage): Para carregamento e cache de imagens de forma assíncrona.
  - [**SwiftLint**](https://github.com/realm/SwiftLint): Para garantir a consistência e qualidade do código.
- **Rick and Morty API**: API pública para obter os dados da série.

---

## 🚀 Funcionalidades

- **Listagem de Personagens**:
  - Mostra todos os personagens da série com suas respectivas imagens e informações básicas.
  - Carregamento eficiente de imagens com cache usando **SDWebImage**.

- **Detalhes do Personagem**:
  - Exibe detalhes específicos de um personagem, como:
    - Nome
    - Status (vivo, morto ou desconhecido)
    - Espécie
    - Local de origem e localização atual
    - Episódios em que aparece

- **Listagem de Episódios**:
  - Apresenta uma lista de episódios com título, número e data de exibição.

- **Detalhes do Episódio**:
  - Exibe informações detalhadas de um episódio, incluindo:
    - Nome
    - Data de exibição
    - Personagens que aparecem no episódio

- **Listagem de Locais**:
  - Mostra os locais da série com suas respectivas descrições.

- **Detalhes do Local**:
  - Exibe informações específicas de um local, como:
    - Nome
    - Tipo
    - Dimensão
    - Personagens residentes

---

## 🔧 Configuração do Projeto

### Pré-requisitos

Certifique-se de ter os seguintes itens instalados:

- **Xcode** (versão 14 ou superior)
- **CocoaPods** (versão 1.11.0 ou superior)

### Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/luisteodorojr/multiverse.git
   cd multiverse
   ```

2. Instale as dependências:
   ```bash
   pod install
   ```

3. Abra o arquivo `.xcworkspace` no Xcode:
   ```bash
   open Multiverse.xcworkspace
   ```

4. Compile e execute o projeto no simulador ou dispositivo físico.

---

## 📦 Dependências

### **SDWebImage**
- Usado para carregar e cachear imagens.
- Benefícios:
  - Melhor performance ao carregar imagens da API.
  - Evita downloads redundantes com cache integrado.

### **SwiftLint**
- Configurado para manter o código limpo e consistente.
- Configuração básica no arquivo `.swiftlint.yml` para evitar erros comuns.

---

## 🧱 Arquitetura

O projeto utiliza a arquitetura **MVVM-C (Model-View-ViewModel-Coordinator)**, que oferece uma separação clara de responsabilidades e facilita a escalabilidade do aplicativo.

- **Model**: Representa os dados do aplicativo e suas regras de negócio (ex.: Character, Location, Episode).
- **View**: Responsável pela interface do usuário (ex.: Storyboards, ViewControllers).
- **ViewModel**: Intermediário entre o Model e a View, lidando com a lógica de apresentação.
- **Coordinator**: Gerencia a navegação entre telas e o fluxo do aplicativo, garantindo uma abordagem centralizada e modular.

### Benefícios do MVVM-C
- **Separação de Responsabilidades**: Cada camada tem uma função clara.
- **Testabilidade**: A lógica do ViewModel pode ser testada separadamente.
- **Escalabilidade**: Fácil de adicionar novos fluxos de navegação com Coordinators.

---

## 🌐 API Rick and Morty

A aplicação consome os dados da [Rick and Morty API](https://rickandmortyapi.com/), que fornece endpoints para:

- **Personagens** (`/character`)
- **Episódios** (`/episode`)
- **Locais** (`/location`)

---

## 📂 Estrutura do Projeto

```plaintext
Multiverse/
├── AppDelegate/
├── Commons/
├── Components/
├── Coordinator/
├── Networking/
├── Sections/
├── Service/
├── Supporting Files/
```

## Estrutura de Testes

```plaintext
MultiverseTests/
├── Character/
├── Episodes/
├── Locations/
├── MockJson/
├── MockNetworkService/
```

### Detalhes dos Testes

- **Camada de Mock**:
  - Utiliza arquivos JSON armazenados em `MockJson` para simular respostas da API.
  - A classe `MockNetworkService` é usada para substituir a camada de rede em testes.

- **Testes Unitários**:
  - Validam as funcionalidades dos ViewModels e da camada de networking.
  - Garantem que os dados sejam processados corretamente, mesmo com respostas simuladas.

- **Testes de UI**:
  - Planejados para futura implementação com o foco na interação e navegação.

---

## 🚀 Próximos Passos

- **Modularização**: 
  - Melhorar a separação das responsabilidades para aumentar a escalabilidade do projeto.
  
- **Melhorar a Camada de Erros**:
  - Implementar uma camada robusta de tratamento de erros para lidar com falhas de rede e respostas inválidas.
  
- **Teste de UI**:
  - Adicionar testes automatizados para validar a interface e navegação do aplicativo.

- **Melhorias na Camada de Rede**:
  - Implementar uma camada de rede mais robusta.

- **UI/UX Melhorada**:
  - Melhorar o layout.

- **Acessibilidade**:
  - Adicionar labels de acessibilidade para elementos-chave.

- **Favoritos**:
  - Permitir que o usuário marque personagens, episódios e locais como favoritos.

- **Modo Offline**:
  - Adicionar suporte offline para mostrar dados armazenados localmente (ex.: usando CoreData).

- **Filtros**:
  - Adicionar a possibilidade de filtrar os personagens por status, espécie ou outros atributos.

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
