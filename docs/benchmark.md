# ToxID — Benchmark de Soluções Existentes

*Objetivo:* aprofundar a compreensão do problema (identificação de animais peçonhentos e indicação de soro) analisando soluções já existentes no mercado/academia, para orientar as personas e as decisões de produto do ToxID.

---

## Solução 1 — Snake Classifier (protótipo acadêmico com IA)

Aplicativo mobile desenvolvido em trabalho acadêmico (WCAMA/SBC, 2021), que usa redes neurais com transfer learning para classificar a espécie de serpente peçonhenta de forma instantânea a partir de uma foto, tendo atingido uma acurácia próxima de 90% no modelo treinado. Fonte: sol.sbc.org.br/index.php/wcama/article/view/15746.

*Principais funcionalidades*
- Captura de foto da cobra pela câmera do celular.
- Classificação automática da espécie via rede neural (Transfer Learning/TensorFlow Lite).
- Resultado instantâneo com a espécie identificada.

*Pontos positivos*
- Elimina a necessidade de o usuário saber características técnicas (cor, forma da cauda, etc.) — basta fotografar.
- Abordagem tecnicamente sofisticada, com bom desempenho de acurácia em ambiente controlado.
- Rapidez: uma única interação (tirar a foto) já entrega o resultado.

*Pontos negativos*
- Depende de a vítima conseguir fotografar o animal com qualidade — inviável em muitos acidentes reais (animal já fugiu, ambiente escuro, mata, pânico da vítima).
- Não há evidência de funcionamento 100% offline nem de indicação do soro antiveneno correspondente — o foco é só a classificação da espécie.
- Escopo limitado a serpentes; não cobre escorpiões, aranhas etc.
- É um protótipo acadêmico, sem lançamento comercial nem manutenção contínua conhecida.

*Aspectos de interface/UX*
- Não há informações públicas detalhadas de UI; o fluxo aparente é câmera → resultado, ou seja, minimalista, mas sem etapas de emergência (hospital, ligação) nem modo para quem não consegue fotografar.

*O que aproveitar/melhorar no ToxID*
- Aproveitar: a ideia de reduzir a decisão a poucas interações e a validação por acurácia.
- Melhorar: o ToxID deve oferecer uma alternativa quando não é possível fotografar o animal (árvore de decisão por perguntas visuais), e sempre encadear a identificação à indicação do soro e ao hospital de referência — coisas que essa solução não cobre.

---

## Solução 2 — Aplicativo da Funed (identificação de serpentes/cobras corais de Minas Gerais)

Desenvolvido pela Fundação Ezequiel Dias (Funed), é um app baseado em um fluxo de perguntas que conduz o usuário, a partir de características observáveis da serpente, a descobrir se ela é ou não peçonhenta — usando traços como presença de fosseta loreal, cor e forma da cauda. Existe também uma versão específica para cobras corais, cujas chaves de identificação seguem perguntas dicotômicas (como a presença de chocalho na cauda) baseadas em características morfológicas. Fonte: funed.mg.gov.br e saude.mg.gov.br.

*Principais funcionalidades*
- Fluxo de perguntas (chave dicotômica) sobre características físicas da serpente.
- Glossário técnico (tipos de dentição: áglifa, opistóglifa, proteróglifa, solenóglifa).
- Lista de locais de atendimento em caso de acidente.
- Módulo específico para diferenciar corais verdadeiras de corais falsas.

*Pontos positivos*
- Não depende de foto — funciona por observação e memória do usuário, o que é mais realista em campo.
- Linguagem lúdica e acessível, usada até em contexto pedagógico com crianças.
- Base científica robusta, validada por bibliografia e biólogos da instituição.
- Cobre tanto o público leigo (moradores rurais, trilheiros) quanto profissionais de saúde.

**Pontos negativos**
- Escopo restrito a serpentes (não cobre escorpiões, aranhas, lacraias).
- Focado geograficamente em Minas Gerais, o que limita a cobertura de espécies de outras regiões.
- Não há indicação clara de geolocalização do hospital mais próximo (só uma lista estática de locais de atendimento).
- Não há confirmação pública de funcionamento offline-first nem de otimização de tamanho de APK.

**Aspectos de interface/UX**
- Fluxo pergunta-a-pergunta, aparentemente com linguagem simples e ilustrações, adequado a diferentes níveis de letramento — mas sem menção a modo escuro/alto contraste para uso sob sol forte, um ponto central do ToxID.

**O que aproveitar/melhorar no ToxID**
- Aproveitar: a lógica de chave dicotômica por perguntas visuais (ex.: "tem chocalho?") é exatamente o modelo do "Modo Emergência" do ToxID, e o glossário técnico serve de referência para a camada "técnica" voltada a bombeiros e técnicos de zoonoses.
- Melhorar: expandir de serpentes para múltiplas classes de animais peçonhentos, trocar a lista estática de hospitais por geolocalização do ponto mais próximo, e aplicar a identidade visual rústica/alto contraste pensada para uso a pleno sol.

---

## Solução 3 — Acidentes Tóxicos com Animais Peçonhentos (CIT/UFRGS – TelessaúdeRS)

App lançado em 2015 pelo Centro de Informação Toxicológica do Rio Grande do Sul em parceria com a UFRGS. Segundo reportagem sobre o lançamento, o aplicativo já ajudava milhares de pessoas na prevenção de acidentes com cobras, aranhas, escorpiões e lagartas, reunindo informações sobre os principais animais peçonhentos do estado e dicas básicas de prevenção (evitar acúmulo de entulho, checar calçados, usar botas e luvas em atividades de campo). Fonte: wp.ufpel.edu.br (Em Pauta/UFPel) e ufrgs.br/telessauders.

**Principais funcionalidades**
- Catálogo informativo dos principais animais peçonhentos do RS (cobras, aranhas, escorpiões, lagartas).
- Dicas preventivas de convivência rural/campo.
- Vínculo institucional com uma central de atendimento telefônico gratuita (0800) para orientação em caso de acidente.

**Pontos positivos**
- Cobre múltiplas classes de animais (não só serpentes), o que se aproxima do escopo do ToxID.
- Forte caráter preventivo/educativo, não só reativo a um acidente já ocorrido.
- Respaldo institucional de saúde pública, o que dá credibilidade à informação.
- Suporte humano complementar via central telefônica.

**Pontos negativos**
- É essencially um catálogo informativo — não há árvore de decisão de identificação rápida nem indicação de soro específico.
- Escopo regional (Rio Grande do Sul), limitando a utilidade em outras regiões do país.
- Não há geolocalização de hospital de referência nem fluxo de emergência estruturado em poucas telas.
- Sem informações públicas sobre funcionamento offline ou tamanho do app.

**Aspectos de interface/UX**
- Formato de consulta/catálogo, mais adequado a estudo prévio do que a uso no momento de pânico de um acidente — não há evidência de um "modo emergência" com poucos toques.

**O que aproveitar/melhorar no ToxID**
- Aproveitar: a cobertura multi-espécie (cobras, aranhas, escorpiões, lacraias) e o conteúdo preventivo, que pode compor a camada "educativa" da galeria de imagens do ToxID.
- Melhorar: transformar o catálogo estático em um fluxo de decisão rápido (Modo Emergência em até 3 telas), acoplar a indicação de soro específico (SAE/SAEsc) e substituir a central telefônica isolada por um botão de emergência integrado ao mapa de hospital mais próximo.

---

## O que o ToxID poderá fazer de diferente ou melhor

Comparando as três soluções, nenhuma delas entrega ao mesmo tempo: (1) identificação rápida por árvore de decisão, (2) indicação do soro específico, (3) cobertura de múltiplas classes de animais, (4) geolocalização do hospital de referência e (5) funcionamento 100% offline com interface pensada para uso externo sob sol forte. O ToxID pode se diferenciar por:

1. **Fluxo de emergência unificado e curto:** nenhuma solução analisada resolve identificação + soro + hospital em até 3 telas/interações — o Snake Classifier para na espécie, a Funed para na identificação e o CIT/UFRGS para no catálogo informativo.

2. **Cobertura multi-espécie com profundidade técnica:** unir a abrangência de classes do app do CIT/UFRGS com a profundidade técnica (nomenclatura científica, chaves dicotômicas) do app da Funed, mas para todo o Brasil e não só uma região/estado.

3. **Offline-first de verdade:** nenhuma das três soluções documenta publicamente imagens embarcadas no APK ou cache local — um diferencial crítico para uso em mata/lavoura sem sinal.

4. **Geolocalização acionável:** substituir listas estáticas de pontos de atendimento (Funed, CIT/UFRGS) por um mapa dinâmico do hospital mais próximo com soro disponível.

5. **Identidade visual para uso a pleno sol:** nenhuma referência encontrada menciona modo escuro de alto contraste pensado para leitura sob luz solar direta — um ponto de diferenciação de UX do ToxID (paleta preto/verde-musgo).

6. **Dois níveis de profundidade num só app:** atender tanto o uso técnico/consulta (bombeiros, técnicos de zoonoses — como no glossário da Funed) quanto o uso emergencial de altíssimo estresse (população rural), sem obrigar o usuário técnico a passar pelo fluxo simplificado nem vice-versa.
