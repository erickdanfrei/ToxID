# Funcionalidades e Requisitos (ToxID)

## 1. Funcionalidades

1. **Modo Emergência (Triagem Visual)**
   * **Descrição:** Algoritmo de árvore de decisão com perguntas visuais simples (ex: "O rabo tem chocalho?").
   * **Necessidade:** Identificação rápida do animal por vítimas em pânico.
   * **Justificativa:** É o núcleo de sobrevivência do app, permitindo o diagnóstico sem conhecimento técnico prévio.

2. **Indicação de Soro Específico**
   * **Descrição:** Exibição destacada do antiveneno exato (SAE, SAEsc) de acordo com o animal identificado.
   * **Necessidade:** Garantir que a vítima ou o socorrista exija o tratamento correto.
   * **Justificativa:** A aplicação do soro correto é o fator determinante para a sobrevivência em acidentes ofídicos e aracnídeos.

3. **Localização de Hospital de Referência**
   * **Descrição:** Mapa temporário indicando a unidade de saúde mais próxima capacitada para aplicação do soro.
   * **Necessidade:** Evitar que a vítima perca tempo indo a postos de saúde básicos que não possuem antiveneno.
   * **Justificativa:** Otimiza o tempo de socorro, fator crítico em envenenamentos.

4. **Catálogo Visual Offline**
   * **Descrição:** Galeria de imagens científicas vetorizadas de animais peçonhentos embarcada no aplicativo.
   * **Necessidade:** Consulta de espécies sem depender de conexão com a internet.
   * **Justificativa:** Essencial para uso em áreas rurais e matas, garantindo o funcionamento em zonas de exclusão digital.

5. **Busca e Filtros Dinâmicos**
   * **Descrição:** Pesquisa no catálogo por cor, formato morfológico ou região.
   * **Necessidade:** Facilitar a busca para usuários que conseguiram observar características do animal.
   * **Justificativa:** Acelera a identificação quando o usuário não sabe o nome popular da espécie.

6. **Alerta de Primeiros Socorros (O que NÃO fazer)**
   * **Descrição:** Tela de alerta visual contra práticas perigosas (ex: torniquetes, cortes no local).
   * **Necessidade:** Impedir o agravamento do quadro clínico da vítima por desinformação.
   * **Justificativa:** Previne amputações e complicações circulatórias severas antes do atendimento médico.

7. **Detalhamento Taxonômico (Modo Técnico)**
   * **Descrição:** Exibição do nome científico e família taxonômica na ficha do animal.
   * **Necessidade:** Consulta técnica precisa para bombeiros e agentes de zoonoses.
   * **Justificativa:** Atribui credibilidade científica e serve como material de treinamento em ocorrências oficiais.

8. **Botão de Discagem Rápida**
   * **Descrição:** Atalho gigante para acionar serviços de emergência (SAMU/192).
   * **Necessidade:** Chamar socorro imediato sem precisar fechar o app e abrir o discador.
   * **Justificativa:** Reduz o atrito e o tempo de resposta em cenários de extremo estresse.
  
## 2. Requisitos Funcionais
  **●	RF01:** O sistema deve fornecer um botão de acesso rápido ao "Modo Emergência" na tela inicial.
  
  **●	RF02:** O sistema deve apresentar um fluxo de perguntas com imagens lado a lado no Modo Emergência.
  
  **●	RF03:** O sistema deve identificar o animal ao final das respostas da árvore de decisão.
  
  **●	RF04:** O sistema deve exibir, em destaque, o nome do soro antiveneno específico correspondente à espécie.
  
  **●	RF05:** O sistema deve listar os hospitais de referência mais próximos utilizando a localização temporária do dispositivo.
  
  **●	RF06:** O sistema deve conter um catálogo visual pesquisável de animais peçonhentos.
  
  **●	RF07:** O sistema deve permitir o filtro de animais por características físicas (cor, forma) e região.
  
  **●	RF08:** O sistema deve exibir instruções visuais de primeiros socorros ao finalizar o diagnóstico.
  
  **●	RF09:** O sistema deve exibir alertas vermelhos sobre procedimentos contraindicados em acidentes.
  
  **●	RF10:** O sistema deve incluir o nome científico e taxonomia na página de detalhes de cada espécie.
  
  **●	RF11:** O sistema deve permitir a discagem direta para a emergência via protocolo tel:.
  
  **●	RF12:** O sistema deve carregar todas as imagens do catálogo a partir do armazenamento local (assets).


## 3. Requisitos Não Funcionais

* **RNF01 Usabilidade**: O fluxo principal de emergência deve ser concluído em, no máximo, três interações na tela.

* **RNF02 Conectividade**: O aplicativo deve ser offline-first, operando todas as funções de diagnóstico sem internet.

* **RNF03 Armazenamento**: O tamanho total do pacote de instalação (APK) não deve ultrapassar 20MB.

* **RNF04 Acessibilidade/Interface**: A interface deve utilizar Dark Mode de alto contraste (preto e verde-musgo) para legibilidade sob sol intenso.

* **RNF05 Compatibilidade**: O aplicativo deve ser executável em smartphones básicos a partir do Android 8.0.

* **RNF06 Segurança e Privacidade**: O uso da geolocalização deve ser estritamente temporário e não armazenado em banco de dados, respeitando a LGPD.

  
## 4. CRUD

* 	**C (Criar):** Não aplicável.
  
* **R (Consultar):** Consulta de dados de espécies, imagens, sintomas, antivenenos e locais de hospitais.

* **U (Atualizar):** Não aplicável.
* **D (Excluir):** Não aplicável.

**Justificativa:** O ToxID é projetado como uma "bússola de sobrevivência" de consulta rápida (Read-only) para momentos de crise. O usuário final (vítimas em pânico, agricultores ou bombeiros em campo) não precisa e não deve ter permissão para criar, editar ou excluir dados médicos ou taxonômicos sensíveis diretamente pelo aplicativo.


## 5. Priorização


  ### Essenciais :

* **Modo Emergência (Triagem Visual):** Atende aos requisitos **RF01**, **RF02**, **RF03** e **RNF01**.

* **Indicação de Soro Específico:** Atende ao requisito **RF04**.

* **Localização do Hospital de Referência:** Atende aos requisitos **RF05** e **RNF06**.

* **Botão de Discagem Rápida:** Atende ao requisito **RF11**.

* ** Nota:** Para que essas funções essenciais operem em campo, elas dependem dos requisitos estruturais **RNF02** (offline), **RNF03** (APK 20 MB), **RNF04** (alto contraste) e **RNF05** (Android 8.0+).

### Importantes :

* **Catálogo Visual Offline:** Atende aos requisitos **RF06** e **RF12**.

* **Alerta de Primeiros Socorros (O que NÃO fazer):** Atende aos requisitos **RF08** e **RF09**.

### Secundárias :

* **Busca e Filtros Dinâmicos:** Atende ao requisito **RF07**.

* **Detalhamento Taxonômico (Modo Técnico):** Atende ao requisito **RF10**.


  
 
