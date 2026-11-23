# Declaração de uso de Inteligência Artificial generativa

**Projeto:** ToxID  
**Disciplina:** Programação para Dispositivos Móveis

## Ferramenta utilizada

Durante o desenvolvimento do ToxID, utilizamos o **ChatGPT, da OpenAI**, como ferramenta de apoio. Seu uso incluiu explicações, sugestões, geração e revisão de trechos de código e elaboração de documentação. Como o apoio ocorreu em diferentes conversas, não mantivemos um registro completo dos modelos e versões utilizados.

## Etapas e finalidades de uso

| Etapa do trabalho | Finalidade do uso da IA |
| --- | --- |
| Planejamento | Organizar requisitos, identificar pendências e propor uma divisão das tarefas entre os integrantes. |
| Desenvolvimento em Flutter e Dart | Gerar e revisar trechos de código para telas, formulários, filtros, serviços e operações de cadastro, consulta, edição e exclusão. |
| Integração com Firebase | Orientar a configuração do projeto, a autenticação e o controle de acesso de administradores, além de auxiliar no diagnóstico de falhas. |
| Funcionamento offline | Propor e implementar alterações para persistência local de catálogos, fotos e histórico, com sincronização quando houver conexão. |
| Interface e recursos visuais | Apoiar ajustes de layout, textos em português, apresentação de imagens e configuração do ícone do aplicativo. |
| Mapas e localização | Auxiliar na integração do mapa, na utilização de coordenadas e na apresentação de hospitais e rotas. |
| Correção de erros e testes | Interpretar mensagens de erro, sugerir correções e elaborar testes e roteiros de verificação. |
| Compilação e distribuição | Orientar a configuração de Java, Gradle, Kotlin e Android SDK, a geração do APK e a análise de seu tamanho. |
| Documentação e apresentação | Auxiliar na redação do README, nas orientações de uso, na organização de commits, no roteiro de apresentação e nesta declaração. |

## Participação e responsabilidade da equipe

A IA participou da produção de conteúdo e de código; seu uso não se limitou à correção ortográfica. As decisões sobre o que incorporar ao projeto e a responsabilidade pela versão entregue pertencem à equipe.

As sugestões da ferramenta não constituem comprovação de funcionamento. Cada alteração incorporada deve ser compreendida e verificada pelos integrantes, com testes na versão final do aplicativo. Testes sugeridos ou gerados pela IA não devem ser apresentados como executados sem evidência de sua execução.

No ToxID, as informações sobre animais peçonhentos, orientações de atendimento e hospitais exigem conferência em fontes oficiais. Respostas de IA não substituem essas fontes nem confirmam disponibilidade atual de soros nas unidades de saúde.

## Limites desta declaração

Esta declaração registra o apoio do ChatGPT no desenvolvimento e na documentação do projeto. Ela não certifica que todas as funcionalidades estejam concluídas, que o aplicativo funcione integralmente offline ou que todo o código tenha sido validado.

Antes da entrega acadêmica, os integrantes devem conferir este registro e acrescentar outras ferramentas de IA eventualmente utilizadas, informando sua finalidade e, quando conhecida, a versão ou o modelo.

## Registro técnico exigido pela disciplina

**Local deste arquivo no repositório:** `docs/uso-de-ia.md`.

O enunciado do Projeto da Unidade II exige o registro dos prompts mais eficientes, dos erros gerados pela IA e de como foram solucionados, além da justificativa das bibliotecas escolhidas. As seções abaixo complementam a declaração anterior.

### Prompts que orientaram o trabalho

Os prompts abaixo foram reformulados para reunir o contexto e os objetivos das solicitações feitas durante o desenvolvimento. Eles preservam a intenção das interações, mas não são transcrições literais. Organizamos cada um em torno de um problema concreto, das restrições do projeto e do resultado esperado.

#### 1. Revisão do catálogo e dos filtros

> Analise a tela do catálogo e a lógica de filtragem das espécies no projeto Flutter enviado. Verifique se as categorias e características usadas nos filtros correspondem aos valores dos modelos e da base de dados. Padronize os textos em português e preserve o layout e as imagens existentes. Apresente as alterações necessárias e explique como testar a busca, a combinação de filtros e a opção de limpar a seleção.

**Objetivo:** corrigir a experiência de consulta sem reduzir o problema à tradução dos botões. O ponto principal era fazer a interface e os dados utilizarem os mesmos critérios.

#### 2. Persistência das coordenadas dos hospitais

> Investigue o fluxo de edição de latitude e longitude, desde os campos do formulário até a gravação e a leitura do hospital. Verifique a conversão dos valores, a validação das coordenadas e os nomes dos campos no modelo e no Firestore. Preserve os demais dados do cadastro. Explique como confirmar que a localização continua correta depois de salvar, sair da tela e abrir o hospital novamente.

**Objetivo:** acompanhar o dado durante todo o fluxo de edição, para identificar se a falha estava no formulário, no modelo ou na persistência.

#### 3. Diagnóstico da compilação Android

> Com base nos logs e nos arquivos de configuração fornecidos, analise em conjunto as versões de Flutter, Java, Gradle, Android Gradle Plugin, Kotlin e NDK. Identifique a causa de cada incompatibilidade e proponha uma configuração coerente para gerar o APK. Evite atualizações indiscriminadas e preserve as configurações que já funcionam. Indique os arquivos a alterar, a ordem dos comandos e os resultados que confirmam a correção.

**Objetivo:** substituir tentativas isoladas por um diagnóstico do ambiente completo. Os logs posteriores de geração dos APKs permitiram confirmar o avanço daquela configuração.

#### 4. Cadastro de imagens pelo administrador

> Revise o cadastro de espécies para permitir que o administrador selecione uma imagem da galeria e volte a visualizá-la após fechar e reabrir o aplicativo. Considere o plano Spark do Firebase, o tamanho do APK e a necessidade de consulta offline. Compare as opções de armazenamento, explique suas limitações e proponha validação de formato e tamanho. Diferencie o salvamento no aparelho da sincronização da imagem com outros dispositivos.

**Objetivo:** tratar a foto como parte do cadastro, considerando persistência, consumo de espaço e disponibilidade sem rede, além da exibição na tela.

#### 5. Funcionamento sem conexão

> Analise o projeto enviado e identifique quais funcionalidades dependem de internet. Proponha alterações para que o catálogo, as imagens incluídas, as informações dos hospitais e o histórico possam ser consultados sem conexão, preservando a interface existente. Explique como persistir alterações locais e sincronizá-las posteriormente sem perder registros. Separe as funções locais das que ainda exigem rede, como autenticação inicial, mapas e rotas, e apresente um roteiro de testes em modo avião.

**Objetivo:** transformar o pedido de uso offline em requisitos verificáveis. Essa análise também ajudou a reconhecer que disponibilizar dados locais não equivale a oferecer mapas e rotas integralmente offline.

#### 6. Preservação do visual e dos dados existentes

> Compare a versão alterada com o projeto e o protótipo fornecidos. Identifique mudanças que removeram espécies, hospitais ou imagens, ou que modificaram a organização das telas sem necessidade. Preserve os recursos existentes e concentre as alterações nas funcionalidades solicitadas. Ao final, relacione o que foi mantido, o que mudou e o que precisa de conferência visual no aparelho.

**Objetivo:** evitar que a implementação de uma funcionalidade prejudicasse partes que já atendiam ao projeto, especialmente o catálogo e a apresentação das informações.

#### 7. Redução do tamanho do APK

> Analise o relatório de tamanho do APK e identifique quais componentes mais contribuem para o tamanho final. Proponha medidas para buscar o limite de 20 MB sem remover funcionalidades essenciais ou as imagens necessárias à consulta offline. Diferencie APK universal e APK por arquitetura, indique os comandos compatíveis com o Flutter utilizado e explique como medir o resultado após cada alteração.

**Objetivo:** orientar a redução de tamanho a partir de evidências. A análise e a compilação precisaram ser separadas após a tentativa de combinar opções incompatíveis no mesmo comando.

#### 8. Documentação alinhada ao enunciado

> Compare a documentação de uso de IA com o enunciado da disciplina. Mantenha a declaração da ferramenta utilizada, das etapas e das finalidades de uso. Acrescente os prompts relevantes, os problemas encontrados nas respostas, as correções adotadas e as justificativas das bibliotecas. Escreva de forma clara e natural, sem atribuir testes, resultados ou responsabilidades individuais que não estejam registrados.

**Objetivo:** produzir um registro útil para a avaliação e para a defesa oral, mostrando tanto a contribuição da IA quanto o trabalho de análise e verificação que cabe ao grupo.

O que tornou essas solicitações mais úteis foi a combinação de contexto, restrições e critérios de verificação. Informar o erro completo, os arquivos envolvidos e o comportamento esperado ajudou a obter respostas mais específicas e a perceber quando uma sugestão não resolvia o problema.

### Erros e limitações das respostas da IA

Nem todas as sugestões funcionaram na primeira tentativa. Algumas precisaram de ajustes após a leitura dos logs e a comparação com o comportamento esperado. A tabela reúne esses problemas e diferencia as correções confirmadas daquelas que ainda precisam ser verificadas na versão final. Quando a origem da falha não ficou clara, isso também foi registrado.

| Problema identificado | Correção ou encaminhamento | Evidência e situação |
| --- | --- | --- |
| A primeira versão desta documentação continha somente a declaração e foi orientada para a raiz do repositório. Faltavam os itens específicos do enunciado. | Ler o PDF e complementar o arquivo com prompts, erros, soluções e justificativas, indicando `docs/uso-de-ia.md`. | Corrigido nesta revisão documental. |
| Versões assistidas por IA apresentaram filtros em espanhol, embora a interface fosse destinada ao português. Também foi relatado que os filtros não funcionavam. | Revisar os rótulos e a lógica de comparação das categorias e características; preparar a versão com filtros em português. | A falha foi relatada com captura de tela. A equipe deve registrar o teste funcional da versão final, pois a entrega de um arquivo corrigido não prova sua execução. |
| Após alterações, imagens de espécies deixaram de aparecer e foram substituídas por textos de ilustração. | Preservar as imagens incluídas no projeto e revisar caminhos, declaração de assets e tratamento de falha de imagens remotas. | Foram produzidas versões com restauração de fotos. É necessário conferir todas as espécies na versão entregue, inclusive sem conexão. |
| A compilação mostrou que `species_form_screen.dart` continha uma classe `SpeciesService`, imports inválidos e nenhuma definição utilizável de `SpeciesFormScreen`. | Separar o serviço do formulário e restaurar a classe da tela, evitando copiar o conteúdo de um serviço para o arquivo da interface. | O log demonstra o problema, mas não permite determinar se ocorreu na geração, na montagem do pacote ou na aplicação manual. A correção foi preparada; esse build específico não teve confirmação posterior no histórico considerado. |
| A orientação para reduzir o APK combinou `--analyze-size` e `--split-debug-info`, combinação recusada pelo Flutter utilizado. | Executar a análise de tamanho separadamente da compilação com símbolos externos. | O erro foi apresentado no terminal. Depois houve geração do relatório de tamanho e relato de APK com 11 MB, referentes àquela versão. |
| A proposta de funcionamento offline não cobriu mapa de ruas e cálculo de rotas offline de Sergipe. | Separar as funcionalidades locais das dependentes de rede e explicitar a necessidade de dados cartográficos e de um motor de rotas offline. | Limitação reconhecida. Não declarar o aplicativo inteiro como 100% offline sem implementar e testar essa parte. |

### Problemas de integração e ambiente investigados com apoio da IA

Também usamos a ferramenta para entender problemas do ambiente e da integração entre serviços. Eles aparecem abaixo porque fizeram parte do desenvolvimento, embora não seja possível atribuí-los automaticamente ao código gerado pela IA.

| Problema | Procedimento adotado | Resultado registrado |
| --- | --- | --- |
| Java 25 incompatível com o Gradle usado pelo projeto (`Unsupported class file major version 69`). | Localizar o JDK 17 instalado e configurar o Flutter para utilizá-lo. | `flutter doctor -v` passou a mostrar Temurin 17. |
| Gradle, AGP e Kotlin abaixo das versões mínimas exigidas pelo Flutter instalado. | Ajustar as versões em conjunto e verificar os componentes Android necessários. | Logs posteriores registraram a geração dos APKs por arquitetura. Isso não garante compatibilidade automática após novas atualizações. |
| Firebase não inicializado e arquivo de opções com mensagem de configuração pendente. | Configurar o projeto pelo FlutterFire e conferir a inicialização e os arquivos da plataforma Android. | Houve confirmação de funcionamento em uma etapa e novos relatos de falha em outras versões. A versão final requer verificação própria. |
| Erros de compilação web em dependências antigas do Firebase, como `PromiseJsImpl` e `handleThenable`. | Revisar as dependências relacionadas em conjunto, usando a resolução do Pub, e tratar as incompatibilidades restantes da aplicação. | A atualização das dependências foi registrada, seguida de outro erro de API em `CardTheme`. Não equivale a comprovação de execução completa no Chrome. |

### Justificativa das bibliotecas escolhidas

A tabela registra o papel das bibliotecas identificadas nas versões trabalhadas do projeto. As versões exatas devem ser conferidas em `pubspec.yaml` e `pubspec.lock` da entrega final. Flutter, Dart e Firebase fazem parte da stack exigida pela disciplina; as demais escolhas apoiam funcionalidades específicas.

| Biblioteca ou tecnologia | Justificativa no ToxID | Limite ou cuidado considerado |
| --- | --- | --- |
| Flutter e Dart | Construir telas, navegação, formulários e regras da aplicação com uma base de código comum. | Alterações de API podem exigir ajustes no código e nos plugins. |
| `firebase_core` | Inicializar a conexão com o projeto Firebase. | Configuração correta por plataforma; sua indisponibilidade não deve bloquear a consulta local. |
| `firebase_auth` | Autenticar usuários e obter a identidade usada no controle de acesso. | Primeiro login e revalidação dependem de rede; autenticação não substitui regras de autorização. |
| `cloud_firestore` | Persistir e sincronizar espécies, hospitais e registros entre dispositivos. | Regras de segurança, cotas e conflitos precisam ser tratados. Cache não garante todos os dados na primeira abertura offline. |
| `google_sign_in` | Oferecer entrada com conta Google integrada ao fluxo de autenticação. | Exige configuração de plataforma e conectividade para autenticação inicial. |
| `provider` | Disponibilizar serviços e atualizar a interface quando o estado muda. | Evitar duplicar fontes de estado e descartar os serviços corretamente. |
| `shared_preferences` | Persistir preferências e, na implementação local proposta, catálogos e filas serializados para reabertura sem rede. | É uma solução simples para volume pequeno; não substitui um banco transacional nem um backup. Não deve ser descrita como SQLite. |
| `flutter_map` | Exibir o mapa interativo e os marcadores dos hospitais. | A biblioteca de visualização não fornece, por si só, mapas ou rotas offline. |
| `latlong2` | Representar coordenadas e apoiar cálculos de distância geográfica. | Distância em linha reta não corresponde ao percurso rodoviário. |
| `geolocator` | Consultar a localização do aparelho e apoiar a ordenação dos hospitais por proximidade. | Depende de permissão e disponibilidade do serviço de localização; pode falhar sem impedir a consulta da lista. |
| `url_launcher` | Abrir chamadas, links e navegação em aplicativos externos. | O recurso de destino pode depender da rede telefônica, da internet ou de outro aplicativo instalado. |
| `pdf` e `printing` | Gerar e disponibilizar relatórios em PDF. | A geração pode ser local; impressão e envio dependem do meio escolhido. |
| `share_plus` | Abrir o compartilhamento do sistema para arquivos e informações. | Compartilhar não garante envio offline pelo aplicativo de destino. |
| `image_picker` | Selecionar fotos da galeria no formulário de espécies, conforme a proposta de cadastro local. | Foi acrescentado à versão offline proposta; sua integração e o novo APK precisam ser testados. |
| `firebase_analytics` | Registrar eventos de uso quando a funcionalidade estiver habilitada. | Não é necessário para a consulta offline; avaliar privacidade e necessidade dos eventos. |
| `flutter_launcher_icons` | Gerar os recursos de ícone Android a partir da imagem escolhida. | É ferramenta de desenvolvimento; o ícone adaptativo também precisa ser conferido no aparelho. |
| `flutter_test` e `flutter_lints` | Apoiar testes automatizados e análise de qualidade do código. | Testes só contam como executados quando há saída ou evidência correspondente. |

### Validação e acompanhamento pelo grupo

O histórico contém um resultado de quatro testes aprovados em `species_photos_offline_test.dart` e logs de geração de APK em versões anteriores. Esses resultados não validam automaticamente mudanças posteriores. O pacote com núcleo offline foi entregue com verificações estáticas e roteiro de testes, sem execução de Flutter ou compilação naquele ambiente.

Para concluir o registro da versão apresentada, o grupo deve acrescentar:

- O commit ou a versão do projeto efetivamente testada.
- A data, o responsável e o resultado de `flutter analyze`, `flutter test` e da compilação.
- Os resultados de login, permissões do administrador, CRUD e sincronização.
- Os resultados em modo avião, incluindo primeira abertura, fotos e persistência após reiniciar.
- Os problemas ainda existentes e as limitações explicadas na apresentação.

A identificação dos responsáveis deve refletir o trabalho real de cada integrante e seus commits. Não foram atribuídas correções individuais sem registro que sustente essa atribuição.
