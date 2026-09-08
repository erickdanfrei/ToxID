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
