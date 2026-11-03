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
