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


