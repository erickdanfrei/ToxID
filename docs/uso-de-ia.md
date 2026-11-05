# Registro de Uso de IA

Aqui ficam registrados os usos de IA generativa no projeto ToxID (Unidade II): os prompts que mais ajudaram, os erros que a IA cometeu e como a gente resolveu cada um.

---

## Diagramas de Casos de Uso e de Classes

*Responsável:* Luís Felipe Carmelo da Silva
*Data:* 03/11/2026

### Como usei a IA

- Mandei o documento do estudo de caso do ToxID, já com a parte atualizada da Unidade II, e pedi pra IA ler com atenção antes de fazer qualquer coisa.
- Ela levantou os atores, os casos de uso e as classes a partir do que o documento exigia (funcionamento offline, sincronização com o Firebase, histórico, relatório em PDF, login com Google, GPS, botão de emergência).
- Só depois disso pedi pra ela desenhar os dois diagramas.
- Por fim, pedi pra ela revisar os próprios diagramas, e foi nessa revisão que os erros apareceram.
- Os diagramas finais saíram em PNG e em .drawio, pra poder editar no draw.io.

### Prompts que funcionaram melhor

- "Leia atentamente o documento." Isso fez a IA extrair os requisitos antes de propor qualquer diagrama.
- "Aceite as sugestões da unidade 2. Faça os diagramas da forma mais coerente que der." Deu direção pra ela seguir a Unidade II e resolver as contradições do documento.
- "Verifique os diagramas atentamente pra ver se não tem nada de errado." Foi o prompt mais útil, porque foi ele que revelou os erros da primeira versão.

### Erros que a IA cometeu e como resolvemos

| Erro | Como foi resolvido |
|---|---|
| "Ver detalhes do animal" estava como «include» de "Consultar galeria", mas abrir um animal é opcional | Virou «extend» |
| O SAMU estava ligado a casos de uso em que ele não participa (localizar hospital e botão de emergência) | O SAMU ficou ligado só a "Ligar para SAMU / hospital" |
| Duas setas de «extend» chegavam no mesmo ponto da caixa e ficavam confusas | Os pontos de entrada foram separados |
| Animal estava sem tipo, cor e região, que são necessários pros filtros da Unidade II | Atributos tipo, corPredominante e regiao adicionados |
| Associações sem o atributo correspondente (faltavam animalId na Ocorrencia e soroIds no Animal) | Atributos adicionados |
| Hospital e procedimento inicial estavam como associação, mas não são guardados na ocorrência (o hospital é calculado pela distância e o procedimento vem do tipo de acidente) | Viraram dependência (seta tracejada) |
| Método sem sentido: obterPorTipo() numa instância de ProcedimentoInicial | Trocado por obterPassos() |
| Os casos de uso não tinham o tratamento de falhas pedido na Unidade II (internet indisponível e GPS desativado) | Adicionado o caso de uso "Exibir erro (sem internet / GPS)", com «extend» para "Registrar ocorrência" e "Sincronizar dados" |
| Animal sem campo pro crédito da imagem, mas o documento exige creditar os autores das fotos e ilustrações | Atributo creditoImagem adicionado |
| Os tipos usados nos atributos (PerfilUsuario, TipoAcidente, TipoAnimal, StatusSync e NivelPericulosidade) não estavam definidos no diagrama | Os cinco enums foram desenhados no diagrama de classes |

### Decisão sobre a localização

O documento original do projeto diz que a geolocalização é temporária e não é armazenada, mas a Unidade II pede pra registrar a localização das ocorrências com GPS. Seguimos a Unidade II, então a classe Ocorrencia guarda latitude e longitude.

### Ferramentas

- Diagramas gerados com apoio da IA e exportados em PNG e .drawio.
- Edição e ajustes finais no [draw.io](https://app.diagrams.net).

---

## Dados de Espécies e Triagem (assets/data)

*Responsável:* Davi Bomfim de Oliveira Matos
*Data:* 03/11/2026

### Como usei a IA

- Pedi à IA que populasse o especies.json com os 10 animais peçonhentos mais relevantes para o Brasil (serpentes, aranhas e escorpiões), com informações extraídas do Manual de Diagnóstico e Tratamento de Acidentes por Animais Peçonhentos do Ministério da Saúde.
- Para o triagem.json, pedi que ela construísse a árvore de decisão respeitando o limite de 3 toques (RNF01) e usando as imagens SVG já disponíveis em assets/images/.
- Rodei o script tools/validar_dados.py para confirmar integridade (resultado: OK: 10 espécies, 3 hospitais, 5 nós de triagem, máximo de 3 toques).

### Prompts que funcionaram melhor

- "Popule o JSON com as espécies mais responsáveis por acidentes no Brasil segundo o SINAN. Inclua: id (slug), nome popular, nome científico, família, categoria, periculosidade, peconhenta (bool), soroSigla, soroNome, descricao, formato, imagem, cores, regioes e sintomas." Gerou o JSON no esquema correto na primeira tentativa.
- "Monte a árvore de triagem em JSON com no máximo 3 nós de profundidade. Cada folha deve ter o campo especie apontando para o id de uma espécie existente. Cada nó e opção deve ter uma imagem em assets/images/." A IA respeitou o limite e mapeou todos os IDs corretamente.

### Erros que a IA cometeu e como resolvemos

| Erro | Como foi resolvido |
|---|---|
| A IA associou o SAB (Soro Antibotrópico) à Cascavel, que pertence ao gênero Crotalus | Corrigido para SAC (Soro Anticrotálico) — o erro mais crítico de todo o projeto, pois num contexto real poderia comprometer a vida de uma vítima |
| A IA não diferenciou SALox (específico para aranha-marrom) de SAAr (antiarmadeira), colocando apenas SAAr para ambas | Corrigido: a aranha-marrom recebeu SALox/SAAr para indicar que o tratamento pode variar conforme disponibilidade do soro específico |
| O soroSigla da Surucucu veio como SAB em vez de SABL (Soro Antibotrópico-Laquético) | Corrigido para SABL, específico para o gênero Lachesis |
| A sucuri e a tarantula vieram com peconhenta: true e um soro fictício | Corrigidas para peconhenta: false e sem soro — essas espécies não são de importância médica por envenenamento |
| A triagem da cobra não separava a Cascavel das demais no primeiro nível, o que exigia mais de 3 toques para identificá-la | Reestruturada: o segundo nó para serpente pergunta "A cauda tem chocalho?", com SIM levando direto à Cascavel (apenas 2 toques) e NÃO seguindo para as demais serpentes (até 3 toques) |

### Decisões sobre os dados

- *Escopo intencional de 3 categorias:* o protótipo de alta fidelidade tinha 4 categorias (Répteis, Aracnídeos, Anfíbios, Insetos), mas o código implementou apenas as 3 responsáveis por > 95% dos acidentes com envenenamento no Brasil (serpentes, aranhas, escorpiões). Anfíbios e Insetos ficaram fora do escopo desta entrega por falta de soro específico disponível na rede pública — a decisão clínica ficaria confusa sem esse dado.
- *Dados de hospitais marcados como exemplo:* os 3 hospitais no hospitais.json têm observacao explicitando que são dados de exemplo com coordenadas aproximadas. Os telefones estão como null intencionalmente até que a equipe valide os dados reais com a SES-SE. Isso faz o botão "Ligar" não aparecer nos cards — comportamento correto enquanto os dados não forem validados.

---
## Telas de Emergência e Resultado

*Responsável:* Paula Ximena Antonio Franco
*Data:* 03/11/2026

### Como usei a IA

- Passei o protótipo de alta fidelidade (Figma) e pedi que a IA implementasse as telas TriagemScreen e ResultadoScreen em Flutter seguindo o tema escuro já definido em lib/core/tema.dart.
- Pedi revisão específica do fluxo de navegação para garantir que o botão físico "Voltar" do Android retrocedesse uma pergunta na triagem em vez de fechar a tela inteira.

### Prompts que funcionaram melhor

- "Implemente o PopScope na TriagemScreen para que, enquanto houver nós anteriores na pilha da triagem, o botão Voltar remova o último nó em vez de fechar a tela." Gerou o onPopInvokedWithResult correto com _trilha.removeLast().
- "O resultado da triagem deve funcionar para o caso especie == null (animal não identificado), exibindo orientações gerais sem travar." Gerou o _NaoIdentificado widget e o tratamento condicional em toda a ResultadoScreen.

### Erros que a IA cometeu e como resolvemos

| Erro | Como foi resolvido |
|---|---|
| A IA implementou a barra de navegação inferior com 3 abas (Emergência · Catálogo · Hospitais) conforme o protótipo, mas isso gerava conflito com o Navigator baseado em rotas já existente | Optou-se por manter o Navigator.pushNamed e a HomeScreen com menu vertical — mais simples e sem quebrar o fluxo de voltar na triagem. A barra inferior ficou como débito técnico para a Sprint 2 |
| A ResultadoScreen chamava Navigator.pushNamed para hospitais sem verificar se o contexto ainda estava montado, gerando erros assíncronos em builds rápidos | Adicionada verificação if (!context.mounted) return antes de cada Navigator.pushNamed nos callbacks assíncronos |
| O texto "Passo N (máximo 3)" aparecia como "Passo 4 (máximo 3)" quando o usuário chegava à folha da árvore — porque o nó final ainda era contado | Corrigido: o indicador de passo usa _trilha.length que representa o nó atual, não o próximo — a folha nunca é adicionada à trilha, já que redireciona direto para a ResultadoScreen |

---

## Hospitais, Localização e Primeiros Socorros
*Responsável:* Sara Jimena Barrera Mora
*Data:* 03/11/2026

### Como usei a IA

- Pedi à IA que implementasse o LocalizacaoService seguindo o RNF06 (localização temporária, sem armazenamento) e com tratamento para todos os cenários de falha: GPS desligado, permissão negada, permissão negada permanentemente, timeout e exceção genérica.
- Para a tela de primeiros socorros, pedi que ela listasse as 6 ações recomendadas e as 6 contraindicadas com base no Manual do Ministério da Saúde.

### Prompts que funcionaram melhor

- "Implemente o LocalizacaoService que lê o GPS uma única vez, calcula as distâncias para cada hospital com Geolocator.distanceBetween e descarta a posição em seguida. Nunca grave latitude/longitude em variável de instância, Firestore ou SharedPreferences." A IA respeitou a restrição e usou variável local no método.
- "Liste os 6 'O que NÃO fazer' em caso de picada de animal peçonhento, baseado no Manual de Diagnóstico e Tratamento do Ministério da Saúde." Gerou os itens corretos (torniquete, corte, sucção, aplicativos caseiros, bebida alcoólica, esperar sintomas piorarem).

### Erros que a IA cometeu e como resolvemos

| Erro | Como foi resolvido |
|---|---|
| A IA não adicionou timeLimit ao Geolocator.getCurrentPosition, fazendo o app travar se o GPS não conseguisse fixar posição | Adicionado timeLimit: Duration(seconds: 12) dentro do LocationSettings. Se o timeout for atingido, o serviço cai no catch e retorna a lista em ordem alfabética com aviso |
| A IA colocou o botão "Ligar" para o hospital sem verificar se h.telefone != null, causando null passado ao Discador.ligar | Envolvido em if (h.telefone != null) — o botão só aparece quando o hospital tem telefone cadastrado |
| O _semLocalizacao não ordenava os hospitais, deixando a lista em ordem aleatória quando o GPS falhava | Adicionada ordenação alfabética (a.hospital.nome.compareTo(b.hospital.nome)) no fallback |
| A tela SocorrosScreen não tinha o botão do Disque-Intoxicação (0800 722 6001), que é o serviço de apoio complementar ao SAMU | Botão OutlinedButton com Discador.ligar(context, '08007226001') adicionado ao final da lista |


---

## Arquitetura, Código Flutter e Firebase

*Responsável:* Erick Thalles Dantas Freire
*Data:* 03/11/2026

### Como usei a IA

- Passei o documento consolidado do ToxID (estudo de caso + requisitos + protótipo de alta fidelidade) e pedi que a IA gerasse a estrutura completa do projeto Flutter seguindo a stack obrigatória: Dart + Flutter + Firebase (Auth + Firestore).
- Pedi que ela gerasse os arquivos de uma vez (estrutura de pastas, pubspec.yaml, modelos, serviços, telas e assets), depois revisei cada arquivo manualmente antes de confirmar.
- Rodei python tools/validar_dados.py para checar integridade dos dados (10 espécies, 3 hospitais, 5 nós de triagem, máximo de 3 toques — tudo OK).

### Prompts que funcionaram melhor

- "Gere o projeto Flutter completo seguindo a arquitetura offline-first. O Firebase pode falhar; o Modo Emergência deve continuar funcionando 100% sem internet." Isso garantiu que a IA construísse o main.dart com try/catch ao redor do Firebase.initializeApp, e que o RepositorioDados carregasse os assets locais antes de qualquer sincronização com a nuvem.
- "Implemente o controle de acesso por papel sem expor o painel admin ao usuário comum." Resultou na verificação dupla (auth.logado e auth.ehAdmin) tanto na AdminScreen quanto nas regras do Firestore (firestore.rules).
- "O fluxo de emergência deve terminar em no máximo 3 toques. Crie um teste automatizado que valide isso." Gerou o test/dados_test.dart com o teste RNF01, que percorre recursivamente a árvore de triagem e verifica se a profundidade máxima é ≤ 3.

### Erros que a IA cometeu e como resolvemos

| Erro | Como foi resolvido |
|---|---|
| A IA gerou firebase_options.dart com as chaves reais de um projeto de exemplo — um risco de segurança | O arquivo foi substituído por um *placeholder* que lança UnsupportedError com instrução para rodar flutterfire configure. O projeto compila e roda 100% offline sem as chaves reais |
| A IA associou a Cascavel ao soro SAB (Soro Antibotrópico), que é o soro das jararacas | Corrigido para SAC (Soro Anticrotálico), que é o correto para o gênero Crotalus, conforme o Manual do Ministério da Saúde. Esse erro é perigoso num contexto de emergência real |
| A IA usou flutter.minSdkVersion no build.gradle, o que manteria o minSdk padrão (21) e violaria o RNF05 (minSdk 26 / Android 8.0) | O script tools/aplicar_android.py foi gerado para corrigir isso de forma idempotente: substitui flutter.minSdkVersion por 26 nos formatos .gradle e .gradle.kts |
| A IA colocou o campo imagem de cada espécie como URL externa — incompatível com o modo offline (RNF02) | Todas as imagens foram convertidas para caminhos de assets locais (assets/images/*.svg) e as ilustrações foram geradas via tools/gerar_imagens.py |
| O serviço de localização da IA armazenava as coordenadas do usuário no Firestore, violando a LGPD e o RNF06 | O LocalizacaoService foi reescrito: lê a posição uma única vez em memória, calcula as distâncias e descarta os dados. Nenhuma coordenada é gravada em banco, arquivo ou log |
| A IA não tinha timeLimit no Geolocator.getCurrentPosition, fazendo o app travar indefinidamente se o GPS não conseguisse fixar | Adicionado timeLimit: Duration(seconds: 12) e tratamento de exceção com fallback para listagem alfabética |
| O catch do _gravar no RepositorioDados tinha as cláusulas TimeoutException e FirebaseException na ordem errada, tornando o FirebaseException morto (dead_code_on_catch_subtype) | A ordem foi corrigida: FirebaseException primeiro, TimeoutException depois |

### Decisões técnicas importantes

- *Offline-first com dois estágios:* o app carrega os JSON embarcados (assets/data) ao inicializar, garantindo que o Modo Emergência e o Catálogo funcionem sem internet. Se o Firebase estiver ativo, os snapshots do Firestore passam a prevalecer — mas só se a coleção não estiver vazia. O Firestore mantém cache em disco, então os últimos dados sincronizados continuam disponíveis offline.
- *Papel admin validado em dois lugares:* no lado do app (AuthService.ehAdmin) e nas regras do Firestore (firestore.rules), que verificam o documento usuarios/{uid} diretamente. O usuário comum não consegue escalar privilégio mesmo manipulando o app.
- *Triagem como JSON, não como código:* a árvore de decisão está em assets/data/triagem.json, não hardcoded em Dart. Isso permite que a equipe atualize o fluxo sem recompilar o app. O teste dados_test.dart valida o JSON automaticamente.
- *Slug como ID:* o ID de cada espécie e hospital é gerado pela função gerarSlug() a partir do nome popular (ex.: "Aranha-marrom" → "aranha-marrom"). Isso garante IDs legíveis e consistentes entre o JSON local e o Firestore.

