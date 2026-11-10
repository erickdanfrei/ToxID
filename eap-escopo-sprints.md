# Escopo do Projeto, EAP e Planejamento em Sprints — ToxID

**Instituição:** Universidade Tiradentes (Unit)  
**Disciplina:** Programação para Dispositivos Móveis  
**Docente:** Layse Santos Souza  
**Equipe:** Davi Bomfim de Oliveira, Erick Thalles Dantas Freire, Luís Felipe Carmelo da Silva, Paula Ximena Antonio Franco, Sara Jimena Barrera Mora  

---

## 1. Escopo do Projeto

### 1.1. Objetivo Geral
Desenvolver um aplicativo móvel híbrido em Flutter/Dart e Firebase para identificação emergencial e rápida de animais peçonhentos brasileiros (serpentes, aranhas, escorpiões, anfíbios e lagartas), orientando vítimas e socorristas em até 3 cliques sobre o soro antiveneno indicado, procedimentos corretos e localização do centro hospitalar de referência mais próximo, operando de forma 100% offline.

### 1.2. Limites e Não-Escopo
- **Não substitui atendimento médico presencial:** O app é classificado como sistema de apoio e triagem preliminar de primeiros socorros.
- **Geolocalização:** Coordenadas opcionais obtidas na identificação e armazenadas com a ocorrência; sem rastreamento contínuo.
- **Permissão de escrita:** Usuários finais não possuem permissão de inserção/edição biológica (Read-only); apenas o perfil administrativo autenticado tem acesso ao CRUD.

---

## 2. Estrutura Analítica do Projeto (EAP / WBS) Simplificada

```
1. PROJETO TOXID
│
├── 1.1 Concepção e Design (Unidade I)
│   ├── 1.1.1 Definição do Problema e Personas (João da Silva e Francia Gonzales)
│   ├── 1.1.2 Levantamento de Requisitos Funcionais (RF01 - RF12) e Não Funcionais (RNF01 - RNF06)
│   ├── 1.1.3 Identidade Visual Dark Mode de Alto Contraste (#0C140E e Verde-Musgo)
│   └── 1.1.4 Protótipos de Alta Fidelidade (Telas de Emergência, Catálogo, Hospitais e Admin)
│
├── 1.2 Desenvolvimento Mobile (Unidade II - Flutter & Dart)
│   ├── 1.2.1 Configuração da Arquitetura e Modelos de Domínio (Species, Hospital, AppUser)
│   ├── 1.2.2 Módulo de Triagem Visual Emergencial (Decisão em até 3 cliques)
│   ├── 1.2.3 Módulo de Catálogo Offline e Filtros Multicritério (Cor e Perigo)
│   ├── 1.2.4 Módulo de Hospitais e Cálculo Geodésico de Proximidade (Haversine)
│   └── 1.2.5 Módulo de Discagem Rápida Telefônica (url_launcher tel:192)
│
├── 1.3 Integração em Nuvem e Persistência (Firebase)
│   ├── 1.3.1 Autenticação Segura de Administradores (Firebase Auth + claim admin)
│   ├── 1.3.2 Modelagem de Coleções no Cloud Firestore (especies, hospitais, usuarios)
│   ├── 1.3.3 Implementação do Painel Administrativo com CRUD Completo
│   └── 1.3.4 Mecanismo de Cache Offline e Fallback com Dados Semente Embarcados
│
└── 1.4 Testes, Documentação e Entrega
    ├── 1.4.1 Testes Unitários de Domínio e Fórmulas de Distância
    ├── 1.4.2 Diagramas UML (Casos de Uso, Classes, Mapeamento Firestore e Navegação)
    ├── 1.4.3 Registro de Uso de IA (docs/uso-de-ia.md)
    └── 1.4.4 Manutenção do README.md e CHANGELOG.md no GitHub
```

---

## 3. Planejamento do Desenvolvimento em Sprints

### Sprint 1: Concepção, Arquitetura e UI Base (Semanas 1 e 2)
* **Objetivo:** Estruturação da base do projeto Flutter, criação do tema de alto contraste e componentes reutilizáveis.
* **Entregáveis:**
  - Setup do projeto Flutter e dependências no `pubspec.yaml`.
  - Implementação do `AppTheme` (Dark Mode preto/musgo).
  - Modelos de domínio: `Species`, `Hospital`, `AppUser`.
  - Criação da barra inferior persistente de navegação (`MainNavigationScreen`).
* **Responsáveis:** Davi Bomfim, Sara Jimena.

### Sprint 2: Modo Emergência e Catálogo Offline (Semanas 3 e 4)
* **Objetivo:** Construção da jornada crítica de triagem em até 3 cliques e catálogo de espécies offline.
* **Entregáveis:**
  - `HomeScreen` com botões gigantes ("Não sei o que me picou" e "SAMU 192").
  - Telas do fluxo de triagem (`TriageCategoryScreen`, `TriageFeatureScreen`, `TriageResultScreen`).
  - Cards de Soro Indicado e Primeiros Socorros (alertas vermelhos e verdes).
  - `CatalogScreen` com busca textual, chips de classe e modal de filtros por perigo e cores (`FilterSheet`).
  - Dataset semente embutido com 12 espécies brasileiras reais.
* **Responsáveis:** Erick Thalles, Paula Ximena, Luís Felipe.

### Sprint 3: Geolocalização de Hospitais e Discagem Rápida (Semanas 5 e 6)
* **Objetivo:** Conectar a indicação do soro à localização dos hospitais de referência mais próximos.
* **Entregáveis:**
  - Serviço de geolocalização temporária (`LocationService`) sem rastreamento (LGPD).
  - Cálculo geodésico de distância em km (Haversine) e estimativa de minutos.
  - Tela `HospitalsScreen` com ordenação automática por menor distância.
  - Integração com protocolo telefônico direto `tel:`.
* **Responsáveis:** Luís Felipe, Davi Bomfim.

### Sprint 4: Firebase Auth, Firestore Admin CRUD e Finalização (Semanas 7 e 8)
* **Objetivo:** Implementação do perfil administrativo, integração com o Cloud Firestore e consolidação dos artefatos técnicos da Unit.
* **Entregáveis:**
  - `AuthService` com autenticação Firebase e verificação de claim administrativa.
  - `AdminPanelScreen` com abas de Espécies e Hospitais.
  - Formulários de criação e edição (`SpeciesFormScreen`, `HospitalFormScreen`).
  - Regras de segurança no Firestore (`firestore.rules`).
  - Documentação técnica completa: Casos de Uso, Diagrama de Classes, Modelagem Firestore, Fluxo de Navegação, Registro de IA (`docs/uso-de-ia.md`) e `README.md`.
* **Responsáveis:** Todos os membros (Davi, Erick, Luís Felipe, Paula, Sara).
