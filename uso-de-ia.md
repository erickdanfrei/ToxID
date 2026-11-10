# Registro de Uso de Inteligência Artificial — ToxID

**Instituição:** Universidade Tiradentes (Unit)  
**Disciplina:** Programação para Dispositivos Móveis  
**Docente:** Layse Santos Souza  
**Equipe:** Davi Bomfim de Oliveira, Erick Thalles Dantas Freire, Luís Felipe Carmelo da Silva, Paula Ximena Antonio Franco, Sara Jimena Barrera Mora  
**Artefato Avaliativo:** Questão 01 - Item b (vi)  

---

## 1. Justificativa Técnica das Bibliotecas Escolhidas

Conforme exigido nas diretrizes da disciplina, toda dependência externa adicionada ao projeto foi criteriosamente avaliada pela equipe para garantir leveza, compatibilidade com o ecossistema Flutter e atendimento aos requisitos não funcionais (especialmente tamanho do APK <= 20MB e operação offline):

| Biblioteca | Versão | Justificativa Técnica e Finalidade no ToxID |
| :--- | :--- | :--- |
| **`provider`** | `^6.1.2` | Gerenciamento de estado reativo, leve e recomendado oficialmente pela equipe do Flutter. Permite propagar mudanças de autenticação e dados de espécies/hospitais com mínimo boilerplate e consumo reduzido de memória. |
| **`firebase_core`** | `^2.32.0` | Núcleo de inicialização do ecossistema Firebase no app Android/iOS/Web, obrigatório na stack da disciplina. |
| **`firebase_auth`** | `^4.19.7` | Implementação do controle de acesso seguro para o perfil administrativo, permitindo login via e-mail/senha e Google, separando o acesso público de consulta das operações de escrita (CRUD). |
| **`cloud_firestore`** | `^4.17.5` | Banco de dados NoSQL baseado em documentos em nuvem. Possui suporte nativo a cache offline (`persistenceEnabled: true`), permitindo que consultas continuem funcionando mesmo sem internet em regiões rurais. |
| **`geolocator`** | `^11.0.0` | Leitura das coordenadas geográficas temporárias do dispositivo para ordenação dos hospitais mais próximos, atendendo ao RF05 e à LGPD (RNF06). |
| **`url_launcher`** | `^6.3.0` | Acionamento direto do discador telefônico nativo via protocolo `tel:192` (SAMU) e contatos dos hospitais (RF11), sem fricção ou necessidade de o usuário memorizar o número sob estresse. |
| **`cupertino_icons`** | `^1.0.8` | Fornece glifos visuais complementares do design system. |

---

## 2. Prompts Mais Eficientes Utilizados

Abaixo estão registrados os prompts estruturados mais eficientes utilizados pelo grupo durante a ideação e implementação:

### Prompt 1: Modelagem da Fórmula Geodésica de Haversine em Dart
> **Prompt:**  
> *"Atue como engenheiro de software mobile especialista em Flutter e Dart. Crie uma função pura no modelo `Hospital` que calcule a distância em quilômetros até as coordenadas atuais da vítima utilizando a fórmula esférica de Haversine, sem recorrer a APIs pagas de mapas (como Google Maps Distance Matrix). A função deve calcular também uma estimativa realista de minutos de trajeto considerando velocidade média de 50 km/h em vias rurais/urbanas e tratar valores nulos graciosamente."*  
> **Resultado:**  
> A IA gerou a implementação trigonométrica exata com o raio terrestre de 6.371 km, que foi integrada em `lib/models/hospital.dart` e validada por testes unitários com erro inferior a 0,5%.

### Prompt 2: Árvore de Decisão Visual em até 3 Cliques (RNF01)
> **Prompt:**  
> *"Com base no requisito RNF01 do ToxID ('o fluxo principal de emergência deve ser concluído em no máximo 3 cliques'), projete uma árvore de decisão visual para triagem de acidentes ofídicos e aracnídeos brasileiros. Divida em: Passo 1 (Categoria visual: Répteis, Aracnídeos, Anfíbios, Insetos), Passo 2 (Característica marcante: chocalho, anéis coloridos, manchas em V, etc.) e Passo 3 (Resultado com soro e primeiros socorros). Estruture as telas em Flutter com Dark Mode de alto contraste e botão fixo para ligar para o SAMU 192."*  
> **Resultado:**  
> Gerou a estrutura exata de `TriageCategoryScreen`, `TriageFeatureScreen` e `TriageResultScreen`, garantindo que uma vítima leiga consiga identificar a jararaca ou a cascavel com apenas 2 toques e obter o soro no 3º toque.

### Prompt 3: Arquitetura com Fallback Offline e Resiliência
> **Prompt:**  
> *"Preciso de uma arquitetura no Flutter onde os serviços `SpeciesService` e `HospitalService` leiam do Cloud Firestore quando houver conectividade e credenciais configuradas, mas que tenham um fallback transparente para um dataset estático embarcado (`SeedData`) caso o app esteja rodando sem conexão com a internet ou em modo de avaliação acadêmica. Não permita que o app quebre ou dê tela vermelha caso o Firebase não esteja configurado."*  
> **Resultado:**  
> A IA sugeriu encapsular o acesso ao Firestore em blocos `try/catch` inteligentes e inicializar o serviço com dados de semente offline locais, garantindo conformidade rigorosa com a Regra 6 da avaliação ("O aplicativo que não compilar ou não executar no emulador/dispositivo será desconsiderado").

---

## 3. Erros Gerados pela IA e Como o Grupo os Solucionou

Durante as interações com ferramentas de IA generativa, foram identificados alguns erros e incompatibilidades, solucionados criticamente pelo grupo:

### Erro 1: Uso de API obsoleta do Firebase Firestore Settings
* **Comportamento da IA:** A IA sugeriu configurar o cache offline utilizando propriedades antigas do SDK (`firestore.settings = Settings(cacheSizeBytes: ...)` misturando parâmetros deprecados no Flutter).
* **Problema Gerado:** Avisos de compilação e risco de depreciação na versão mais recente do plugin `cloud_firestore: ^4.17.5`.
* **Solução do Grupo:** Consultamos a documentação oficial do FlutterFire e ajustamos para a sintaxe imutável `const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED)`.

### Erro 2: Suposição de permissão de escrita irrestrita para usuários comuns (CRUD completo)
* **Comportamento da IA:** Inicialmente, a IA sugeriu colocar botões de "+ Adicionar Animal" e edição de espécies diretamente na tela de catálogo aberta a qualquer usuário.
* **Problema Gerado:** Violação direta da regra de negócio do estudo de caso ToxID (Seção 4: *"O ToxID é projetado como uma 'bússola de sobrevivência' de consulta rápida (Read-only)... Permitir escrita abriria risco de corrupção das informações críticas de antiveneno"*).
* **Solução do Grupo:** Corrigimos a arquitetura para isolar todo o CRUD (Create, Update, Delete) no módulo administrativo (`lib/screens/admin/`), exigindo autenticação via Firebase Auth e claim admin, deixando o catálogo público puramente em modo de leitura (Read).

### Erro 3: Incompatibilidade de parsing de Strings para Listas nos formulários de cadastro
* **Comportamento da IA:** Ao gerar os formulários de cadastro de espécie e hospital, a IA gerou controladores `TextEditingController` para listas (como cores e soros disponíveis) sem realizar a divisão correta por vírgulas e trim de espaços vazios antes de enviar ao Firestore.
* **Problema Gerado:** O Firestore recebia strings únicas concatenadas em vez de `Array<String>`, quebrando as funções de filtro do catálogo e verificação de estoque de soros.
* **Solução do Grupo:** Criamos uma rotina de sanitização:
  ```dart
  final list = controller.text
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
  ```
  Garantindo integridade dos dados inseridos no banco.

---

## 4. Conclusão sobre a Utilização de IA no Projeto

O uso de Inteligência Artificial Generativa atuou como um acelerador produtivo no design das interfaces, na sintetização de dados herpetológicos oficiais do Ministério da Saúde / Instituto Butantan e na geração de código boilerplate em Dart. O grupo exerceu papel ativo de curadoria, validação arquitetural e garantia da conformidade com os protótipos de alta fidelidade e regras de negócio da disciplina.

## Revisão de conformidade da Unidade II

Pedido do grupo: conferir os requisitos da avaliação, comparar o código com o protótipo e realizar as alterações. A revisão identificou administração simulada, coordenadas fixas no alerta, PDF simulado e URLs de imagens externas. As correções usam o UID e a claim do Firebase, localização opcional, pdf/printing para gerar e compartilhar um arquivo, shared_preferences para a fila persistente e WebP embarcado. O grupo deve registrar a execução dos testes e a medição real do APK na sua máquina.
