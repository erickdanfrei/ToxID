#ToxID

2.1. Problema  


2.2. Público e usuários  
 

2.3. Contexto de uso   
 

2.4. Objetivo e proposta de valor  



2.5. Personalidade, identidade e experiência  
Analise:


• Palavras conceituais:
Termos como Epidemiologia, peçonha, SAE,SAEsc, Gênero Lachesis, Butantan, SINAN  trazem um rigor mais técnico, sanitário e científico.Essa características impactarão na solução: Na arquitetura onde precisa atender necessidade de dois grupos. Para Técnicos e para trabalhadores rurais, onde os termos devem ser traduzidos para pessoas leigas sobre o assunto.


• Personalidade da identidade:
Definida como: “Rústica, de campo, mas séria”, funcionando como uma “bússola de sobrevivência”. Essa características impactarão na solução: Transmite solidez e utilidade prática. O produto deve evitar elementos supérfluos, animações complexas ou menus escondidos. A ideia de "bússola" exige uma navegação direta, indicando sempre o caminho imediato de ação (identificar e buscar socorro).


• Tom da interface:
Extremamente funcional e offline-first (não pode depender de internet no meio da mata). Botões grandes, fontes fortes, tempo de carregamento de imagem minimizado. Essa características impactarão na solução: Tipografia e Layout: Uso de fontes fortes, pesos em negrito e botões em formato de bloco (touch targets amplos) para facilitar o clique por pessoas com mãos sujas de terra, luvas de trabalho ou dedos trêmulos sob estresse. E na Performance Tecnológica: Exige execução leve em smartphones de entrada (Android 8.0+) e limite estrito do APK em 20MB. As imagens e ilustrações científicas vetorizadas precisam de otimização pesada (WebP/SVG) para garantir carregamento instantâneo.


• Tom da experiência do usuário 
Feita para o momento do susto. Tudo funciona 100% offline no meio da mata, e a resposta vem em até 3 toques na tela, trocando textos longos por imagens diretas (como "Tem chocalho?").


• Forma como o aplicativo deseja ser lembrado 
Como um "escudo digital". Transmite segurança ao usar apenas fotos oficiais confiáveis, respeitar a privacidade e direcionar a pessoa rápido ao hospital correto. 



2.6. Funcionalidades e características já definidas  

Funcionalidade: Triagem rápida de emergência em até 3 toques

Necessidade atendida: Atende à necessidade de resposta imediata no momento do acidente ou pânico, permitindo que o trabalhador rural identifique o tipo de animal peçonhento sem precisar navegar por menus complexos ou ler textos longos.

Funcionalidade: Funcionamento 100% offline-first com assets e imagens embarcadas no aplicativo

Necessidade atendida: Supre a falta de conectividade à internet em lavouras, matas e zonas rurais isoladas, garantindo que o app continue totalmente operacional onde os acidentes costumam acontecer.

Funcionalidade: Mapeamento e geolocalização do hospital de referência mais próximo

Necessidade atendida: Resolve a urgência de encontrar o local correto para aplicação do soro antiveneno específico (SAE/SAEsc), indicando a rota para socorro sem armazenar os dados de localização do usuário.

Funcionalidade: Galeria de imagens com busca por características visuais (cor, forma e presença de chocalho)

Necessidade atendida: Atende quem não conhece a biologia dos animais ou não sabe o nome da espécie, permitindo uma identificação intuitiva por comparação visual rápida.

Funcionalidade: Exibição de nomes científicos, taxonomia e informações de soros

Necessidade atendida: Atende à demanda técnica de profissionais da saúde, técnicos de zoonoses e bombeiros, conferindo credibilidade e servindo como ferramenta para treinamento e apoio em ocorrências.

Funcionalidade: Modo escuro de alto contraste (preto e verde-musgo) com botões e fontes ampliados

Necessidade atendida: Facilita a leitura e navegação sob sol forte em ambientes externos e garante usabilidade para trabalhadores que estejam usando luvas ou com as mãos sujas.

Funcionalidade: Otimização de dados para limite de APK em até 20MB e uso de ilustrações científicas oficiais (Butantan/Funed)

Necessidade atendida: Viabiliza o download e compartilhamento (via Bluetooth) em celulares básicos ou redes móveis fracas, além de garantir precisão técnica e segurança no diagnóstico sem o uso de fotos genéricas.


2.7. Restrições e condições  

 

O protótipo deve possuir até 4 telas: Grade de fotos de animais com busca por cor ou formato; Foto grande e legível com periculosidade e soro antiveneno específico (como SAE ou SAEsc); "O que aconteceu?" com botões gigantes (Picada de cobra / Aranha / Escorpião); Localização do hospital de referência mais próximo para aplicação do soro. 

 

 

O APK não pode ultrapassar 20MB de armazenamento, pois será usado em áreas com pouca/sem internet ou via Bluetooth. As fotos devem ser otimizadas em baixa resolução. Ou seja, é proibido usar imagens de bancos de imagens genéricas (não são confiáveis para a identificação); Devem ser usadas fotos de acervos públicos ou ilustrações científicas vetorizadas (Instituto Butantan/Funed); É necessário a utilização de cores escuras para transmitir seriedade e também para não refletir luz solar intensa. 

 

 

O app deve rodar em smartphones básicos com Android 8.0 ou superior. 

 

Deve ocorrer em 3 interações : 

  

Abrir o App => Tocar em "Não sei o que me picou" => Responder 1 pergunta visual ("O rabo tem chocalho?") => Receber o diagnóstico e o botão de ligar para emergência.  

 

O fluxo de emergência não pode ter mais de 3 telas. 

 

Necessário Dark Mode com alto contraste (preto/verde-musgo) para leitura em ambiente externo sem reflexo. 

 

2.8. Pontos de atenção  

Ao final da análise, o grupo deverá responder:  

• Quais são os 3 aspectos do estudo de caso que consideramos mais  importantes para o sucesso do aplicativo?  

Identificação de animais peçonhentos por imagens, para evitar acidentes com animais peçonhentos e facilitar o processo de recuperação/descoberta do usuário. 
 
Modo offline, para permitir que os usuários acessem as funcionalidades de maneira eficiente e simples. 

Localização de hospitais próximos, para facilitar o processo de resgate/ recuperação para as vítimas de possíveis ataques. 
