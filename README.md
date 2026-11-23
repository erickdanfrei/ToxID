# ToxID 🐍

**Informação que pode fazer diferença na hora de buscar ajuda.**

Quando alguém se depara com uma serpente, um escorpião ou uma aranha, é normal ter dúvidas: que animal é esse? O que fazer primeiro? Onde procurar atendimento?

Foi para ajudar nessas situações que desenvolvemos o **ToxID**, um aplicativo criado como projeto da disciplina de **Programação para Dispositivos Móveis**, do curso de Ciência da Computação.

A ideia é reunir, em um só lugar, informações sobre animais peçonhentos, orientações iniciais, uma triagem informativa e a consulta a hospitais de referência. Queremos que o aplicativo seja fácil de entender e útil mesmo para quem não tem familiaridade com tecnologia.

> **Antes de tudo:** o ToxID é uma ferramenta de informação e apoio. Ele **não identifica um animal com certeza, não faz diagnóstico e não substitui o atendimento médico**. Em caso de picada ou suspeita de envenenamento, procure um serviço de saúde imediatamente. A escolha e a aplicação de antiveneno cabem à equipe de saúde.

**Links do projeto**

- [Código-fonte no GitHub](https://github.com/erickdanfrei/ToxID)
- [Versão web do ToxID](https://toxid.vercel.app) — disponível conforme a implantação ativa na Vercel

## O que você encontra no aplicativo

Procuramos organizar as funcionalidades de um jeito simples, para que a pessoa consiga ir da dúvida inicial até as informações mais importantes sem se perder pelas telas.

- **Catálogo de animais:** reúne espécies cadastradas, com imagens, características e ferramentas de busca e filtro.
- **Triagem informativa:** apresenta perguntas sobre as características observadas e mostra orientações a partir das respostas. O resultado é preliminar, não uma identificação definitiva.
- **Orientações de primeiros socorros:** informa cuidados iniciais e atitudes que devem ser evitadas.
- **Histórico:** permite guardar registros localmente e tentar sincronizá-los com o Firebase quando há uma conta autenticada e conexão disponível.
- **Relatórios e compartilhamento:** oferece geração de PDF e compartilhamento de informações, inclusive localização quando ela está disponível e autorizada.
- **Hospitais de referência:** permite consultar unidades cadastradas, filtrar por tipo de soro e visualizar a proximidade quando o GPS está disponível.
- **Mapas e rotas:** mostra a localização das unidades em mapa interativo e oferece consulta de trajetos e abertura de navegação externa.
- **Login e administração:** utiliza Firebase para autenticação por e-mail/senha ou Google. Contas com permissão administrativa podem cadastrar, editar e excluir informações de espécies e hospitais.

**Um cuidado importante:** os soros mostrados no aplicativo são os **registrados no cadastro de cada hospital**, não uma confirmação de estoque em tempo real. A disponibilidade precisa ser confirmada com a unidade de saúde.

## Como construímos o ToxID

Usamos **Flutter e Dart** para desenvolver as telas e o funcionamento do aplicativo. O **Firebase** cuida da autenticação e dos dados sincronizados. Para localização e trajetos, integramos serviços de mapas e geolocalização.

| Tecnologia | Para que usamos |
| --- | --- |
| Flutter e Dart | Telas, navegação e regras do aplicativo |
| Firebase Authentication | Login com e-mail/senha e Google |
| Cloud Firestore | Armazenamento de espécies, hospitais e histórico sincronizado |
| Provider | Organização de estado e serviços |
| SharedPreferences | Preferências e dados armazenados localmente |
| flutter_map e OpenStreetMap | Mapa interativo |
| Geolocator | Localização do dispositivo, com permissão do usuário |
| OSRM | Consulta de rotas |
| pdf, printing e share_plus | Relatórios e compartilhamento |
| Vercel | Hospedagem da versão web compilada |

A organização principal do código fica assim:

```text
toxid/
├── lib/
│   ├── models/          # Modelos de dados
│   ├── screens/         # Telas do aplicativo
│   ├── services/        # Autenticação, dados, GPS e rotas
│   ├── domain/          # Regras de busca, filtros e outras funções
│   ├── widgets/         # Componentes reutilizados nas telas
│   ├── theme/           # Aparência do aplicativo
│   ├── firebase_options.dart
│   └── main.dart        # Ponto de entrada
├── assets/              # Dados e recursos visuais
├── android/             # Configurações do Android
├── web/                 # Configurações da versão web
├── test/                # Testes automatizados
├── firestore.rules      # Regras de acesso ao banco
└── pubspec.yaml         # Dependências Flutter
```

## Quer executar o projeto?

Você vai precisar do **Flutter SDK**, do **Dart SDK** compatível com o projeto, e de um emulador ou celular Android para testes no APK. Para a versão web, use um navegador compatível. As funcionalidades conectadas também exigem um projeto Firebase configurado.

### 1. Baixe o código

```bash
git clone https://github.com/erickdanfrei/ToxID.git
cd ToxID
```

Se o aplicativo Flutter estiver dentro de uma subpasta, entre nela antes de continuar. O lugar certo é onde está o arquivo `pubspec.yaml`.

### 2. Instale as dependências

```bash
flutter doctor
flutter pub get
```

### 3. Rode no celular ou emulador

```bash
flutter devices
flutter run
```

### 4. Ou abra no navegador

```bash
flutter run -d chrome
```

## Configurando o Firebase

O projeto usa **Firebase Authentication** e **Cloud Firestore**. Para executar com seu próprio Firebase:

1. Crie ou selecione um projeto no [Firebase Console](https://console.firebase.google.com/).
2. Ative o login por **E-mail/Senha** e **Google** em *Authentication*.
3. Configure os aplicativos Android e Web e gere as opções com `flutterfire configure`.
4. Confira o `android/app/google-services.json` correspondente ao seu aplicativo Android.
5. Para login na web, adicione o domínio da implantação (como `toxid.vercel.app`) aos domínios autorizados do Firebase Authentication.
6. Para login Google no Android, configure as impressões digitais **SHA-1/SHA-256** necessárias para a assinatura usada.
7. Revise as regras do Firestore e, quando estiverem prontas, publique-as:

```bash
firebase deploy --only firestore:rules
```

Os dados principais estão organizados em coleções como `especies` e `hospitais`. O histórico sincronizado fica vinculado ao usuário, no caminho `usuarios/{uid}/historico`.

O acesso administrativo depende de uma permissão `admin` atribuída de forma segura no Firebase. **Não coloque chaves privadas, senhas ou arquivos de conta de serviço no GitHub.**

## E quando fica sem internet?

Essa foi uma preocupação importante no projeto. O ToxID conta com dados iniciais incluídos no aplicativo, registros locais e recursos de cache. Assim, **parte das consultas e informações pode continuar disponível offline**.

Mas é importante ser claro sobre os limites: um novo login com Google, a sincronização com o Firebase, o carregamento de mapas ainda não armazenados e a busca de rotas pela internet podem não funcionar sem conexão. Imagens remotas também dependem de já terem sido carregadas ou armazenadas.

Por isso, preferimos dizer que o ToxID **tem recursos offline**, e não que tudo funciona 100% sem internet. O comportamento precisa ser testado separadamente no APK e na versão web.

## Como gerar o APK

Para criar um APK de produção:

```bash
flutter build apk --release
```

O arquivo ficará em `build/app/outputs/flutter-apk/app-release.apk`.

Se quiser arquivos menores, separados por arquitetura do dispositivo:

```bash
flutter build apk --release --split-per-abi
```

Para a maioria dos celulares Android atuais com processador ARM de 64 bits, o arquivo relevante é `app-arm64-v8a-release.apk`.

## Como atualizar a versão web

Na pasta do aplicativo Flutter, gere uma nova compilação:

```bash
flutter clean
flutter pub get
flutter build web --release
```

Para publicar manualmente pela Vercel CLI no PowerShell:

```powershell
cd .\build\web
vercel.cmd link
vercel.cmd --prod
```

Na vinculação, escolha **o projeto já existente** para manter o endereço atual. Se a Vercel estiver conectada ao GitHub, o processo de implantação também precisa estar preparado para compilar o Flutter: enviar commits para a `main` não cria automaticamente a pasta `build/web`.

## Testes e pontos que seguimos acompanhando

O repositório possui testes para partes do aplicativo, como modelos, catálogo, filtros, hospitais, rotas e recursos offline. Para rodá-los:

```bash
flutter analyze
flutter test
```

Também é necessário testar na prática os fluxos de login e logout, acesso administrativo, triagem, localização e navegação. A existência dos testes não significa, por si só, que tudo foi validado em todos os dispositivos.

Estamos atentos principalmente à estabilidade das rotas, às diferenças entre Android e Web, ao comportamento sem internet e à necessidade de manter os dados hospitalares conferidos.

## Quem faz parte do projeto

O ToxID é um trabalho desenvolvido em grupo na disciplina **Programação para Dispositivos Móveis**, do curso de **Ciência da Computação**, com orientação da professora **Layse Santos Souza**.

- Davi Bomfim de Oliveira
- Erick Thalles Dantas Freire
- Luís Felipe Carmelo da Silva
- Paula Ximena Antonio Franco
- Sara Jimena Barrera Mora

---

**O que queremos com o ToxID é simples:** tornar informações importantes mais acessíveis e ajudar as pessoas a buscar orientação e atendimento com mais rapidez — sempre lembrando que, em um acidente real, a prioridade é procurar assistência médica.


---

## Responsabilidades e Contribuições Individuais

**Fase 1: Estruturação e Pesquisa Inicial**
* **Erick:** Criação do repositório, gestão de colaboradores e pesquisa dos pontos 2.5 e 2.6.
* **Felipe:** Pesquisa dos pontos 2.7 e 2.8.
* **Paula:** Pesquisa dos pontos 2.1 e 2.2.
* **Sara:** Organização do repositório conforme a estrutura recomendada, redação do README e do CHANGELOG, e pesquisa dos pontos 2.3 e 2.4.

**Fase 2: Pesquisa, Benchmark e Personas**
* **Erick:** Criação dos arquivos `pesquisa.md`, `benchmark.md` e `personas.md` e desenvolvimento da parte de pesquisa.
* **Davi:** Desenvolvimento das soluções 1 e 2 do benchmark.
* **Felipe:** Desenvolvimento da solução 3 de benchmark.
* **Sara:** Criação da Persona 1.
* **Paula:** Criação da Persona 2.

**Fase 3: Funcionalidades e Requisitos**
* **Erick:** Criação do arquivo `requisitos.md` e desenvolvimento da seção 1 (Funcionalidades).
* **Davi:** Estruturação do CRUD no arquivo `requisitos.md`.
* **Felipe:** Estruturação dos requisitos não funcionais no arquivo  `requisitos.md`.
* **Sara:**  Estruturação dos requisitos funcionais no arquivo  `requisitos.md`..
* **Paula:** Estruturação da Priorização dos requisitos no arquivo  `requisitos.md`.


**Fase 4: Protótipos**
* **Erick:** Contribuição em ideias e elaboração documental.
* **Davi:**  Contribuição em ideias e elaboração documental.
* **Felipe:**  Contribuição em ideias e elaboração documental.
* **Sara:** Protótipo de alta fidelidade.
* **Paula:** Protótipo de baixa fidelidade.

**Fase 5: Unidade II (Modelagem e Documentação Técnica)**
* **Felipe:** Atualização do Diagrama de Casos de Uso com as regras da Unidade II (incluindo o tratamento de falhas), criação do diagrama de Classes com entidades, atributos, métodos, relacionamentos e enums (Arquivos em `docs/Diagrama_casos_de_uso e docs/Diagrama_de_classes` em PDF) e commit da pasta `lib/services` (autenticação, espécies, hospitais, histórico com sincronização, GPS, analytics e rotas).
