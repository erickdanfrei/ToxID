# Fluxo de Navegação Real do Aplicativo — ToxID

**Instituição:** Universidade Tiradentes (Unit)  
**Disciplina:** Programação para Dispositivos Móveis  
**Docente:** Layse Santos Souza  

---

## 1. Visão Geral da Navegação

A navegação do ToxID foi desenhada para eliminar atritos em situações críticas de pânico e emergência:
- Uma barra inferior persistente (`BottomNavigationBar`) dá acesso direto às 3 áreas fundamentais do app: **Emergência**, **Catálogo** e **Hospitais**.
- O fluxo de emergência é uma pilha sequencial com no máximo 3 telas até o diagnóstico e indicação do soro (atendendo ao RNF01).
- Um atalho discreto na AppBar permite o acesso dos gestores ao **Painel Administrativo** mediante autenticação Firebase Auth.

---

## 2. Mapa do Fluxo de Telas (Mermaid)

```mermaid
flowchart TD
    Splash([Início do App]) --> MainNav[MainNavigationScreen<br/>Abas Persistentes]

    subgraph Aba_Emergencia["Aba 1: Emergência"]
        MainNav --> Home[HomeScreen<br/>Logo + Alertas]
        Home -->|Toque no Botão SAMU 192| TelCall1[Discagem Direta tel:192]
        Home -->|Toque em 'Não sei o que me picou'| TriageCat[TriageCategoryScreen<br/>Passo 1: Categoria do Animal]
        
        TriageCat -->|Escolhe Répteis, Aracnídeos, etc.| TriageFeat[TriageFeatureScreen<br/>Passo 2: Características Marcantes]
        TriageCat -->|Botão SAMU 192| TelCall2[Discagem Direta tel:192]
        
        TriageFeat -->|Escolhe Característica| TriageRes[TriageResultScreen<br/>Passo 3: Diagnóstico + Soro]
        TriageFeat -->|Botão SAMU 192| TelCall3[Discagem Direta tel:192]
        
        TriageRes -->|Toque em 'Localizar Hospital'| HospScreenDirect[HospitalsScreen<br/>Filtrado pelo Soro do Animal]
    end

    subgraph Aba_Catalogo["Aba 2: Catálogo"]
        MainNav --> CatScreen[CatalogScreen<br/>Busca + Chips de Categoria]
        CatScreen -->|Toque no Botão Filtros| FilterModal[FilterSheet<br/>Modal Perigo e Cores]
        FilterModal -->|Aplicar| CatScreen
        CatScreen -->|Toque em um Card| DetailScreen[SpeciesDetailScreen<br/>Ficha Taxonômica + Soro + Cuidados]
        DetailScreen -->|Toque em 'Ver Hospitais'| HospScreenDirect
    end

    subgraph Aba_Hospitais["Aba 3: Hospitais"]
        MainNav --> HospScreen[HospitalsScreen<br/>Ordenado por Proximidade GPS]
        HospScreen -->|Toque em 'Ligar'| TelCallHosp[Discagem Direta tel:Hospital]
        HospScreen -->|Toque em 'Atualizar GPS'| RefreshGPS[Recálculo de Haversine]
    end

    subgraph Area_Administrativa["Área Administrativa (Gestão)"]
        Home --> Historico[Histórico da conta ou visitante]
        TriageRes --> Compartilhar[Compartilhar PDF ou alerta]
        TriageFeat -->|Não lembro| Inconclusivo[Resultado inconclusivo e discador 192]
        Home -->|Ícone de conta na AppBar| AdminLogin[AdminLoginScreen<br/>Google ou e-mail e senha]
        AdminLogin -->|Conta com claim admin| AdminPanel[AdminPanelScreen<br/>Abas: Espécies / Hospitais]
        
        AdminPanel -->|Toque em '+ Adicionar Espécie'| SpeciesFormNew[SpeciesFormScreen<br/>Criar Nova Espécie]
        AdminPanel -->|Toque no Ícone de Edição| SpeciesFormEdit[SpeciesFormScreen<br/>Editar Espécie]
        AdminPanel -->|Toque no Ícone de Lixeira| DeleteSpeciesDialog[Confirmar Exclusão]
        
        AdminPanel -->|Toque em '+ Adicionar Hospital'| HospitalFormNew[HospitalFormScreen<br/>Cadastrar Hospital]
        AdminPanel -->|Toque no Ícone de Edição| HospitalFormEdit[HospitalFormScreen<br/>Editar Hospital]
        AdminPanel -->|Toque no Ícone de Lixeira| DeleteHospitalDialog[Confirmar Exclusão]
        
        AdminPanel -->|Logout| AdminLogin
    end
```

---

## 3. Detalhamento dos Gatilhos e Transições

1. **`HomeScreen` -> `TriageCategoryScreen`**:
   - Acionado pelo botão gigante vermelho com alerta.
   - Utiliza transição padrão `MaterialPageRoute`.
2. **`TriageCategoryScreen` -> `TriageFeatureScreen`**:
   - Passa como argumento a chave da categoria selecionada (`Reptiles`, `Arácnidos`, `Anfibios`, `Insectos`).
3. **`TriageFeatureScreen` -> `TriageResultScreen`**:
   - Passa o `speciesId` da correspondência da árvore de decisão.
4. **`TriageResultScreen` -> `HospitalsScreen`**:
   - Passa como parâmetro opcional o nome do soro indicado (`requiredSerum: species.antivenom`).
   - A tela de hospitais já abre priorizando e destacando as unidades que possuem estoque do soro necessário.
5. **Acesso Administrativo**:
   - Acesso restrito via ícone no canto superior direito da Home.
   - Protegido por Firebase Auth e claim administrativa.
