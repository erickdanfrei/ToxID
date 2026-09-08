# Pesquisa: Contexto e Usuários (ToxID)

## Informações relevantes sobre o problema
* O Brasil possui alta incidência de ataques de animais peçonhentos, registrando milhares de casos anuais no país.
* O Ministério da Saúde, através de dados epidemiológicos (2010-2024), aponta que a maioria dos acidentes notificados envolve escorpiões (cerca de 59%), seguidos por serpentes e aranhas.
* O tratamento definitivo e a neutralização da peçonha exigem a aplicação do soro antiveneno específico (como SAE ou SAEsc) o mais rápido possível.

## Necessidades e dificuldades dos usuários
* A população rural e trabalhadores agrícolas, sob forte estresse durante os acidentes, precisam realizar triagens rápidas sem conhecer a taxonomia dos animais.
* O uso de dispositivos sob o sol intenso das lavouras dificulta a leitura, exigindo interfaces com alto contraste e sem reflexos.
* Bombeiros e técnicos de zoonoses necessitam de credibilidade técnica absoluta, demandando o nome científico e informações precisas durante o uso profissional.

## Dados que podem influenciar o aplicativo
* O limite de armazenamento de 20MB é estrito para que o download ocorra via Bluetooth ou redes com internet limitada.
* O fluxo principal de diagnóstico de emergência é limitado a um máximo de 3 interações ou telas.
* A aplicação exige arquitetura *offline-first*, garantindo funcionamento ininterrupto em matas e zonas rurais sem cobertura de rede.

## Fontes utilizadas
* **Ministério da Saúde (Portal Gov.br):** Boletim Epidemiológico de Morbimortalidade por animais peçonhentos no Brasil.
* **Sistema de Informação de Agravos de Notificação (SINAN):** Sistema utilizado para mapeamento e dados epidemiológicos.
* **Instituto Butantan:** Referência técnica para primeiros socorros, acervos fotográficos públicos e indicação de soros hiperimunes.

## 3 Descobertas importantes e influência no projeto
1. **Zonas de Exclusão Digital:** A maioria dos acidentes ocorre em áreas sem cobertura de internet móvel. 
   * **Influência:** O app terá imagens vetorizadas ou de baixa resolução embutidas diretamente no APK (assets), não dependendo de carregamento na nuvem para identificação visual.
2. **Choque e Falta de Conhecimento Técnico:** Vítimas leigas não conseguem descrever a espécie com precisão. 
   * **Influência:** Criação de um algoritmo em árvore de decisão no "Modo Emergência", com perguntas visuais diretas e botões gigantes (ex: "O rabo tem chocalho?").
3. **Logística Restrita de Soros:** Antivenenos não ficam em postos de saúde básicos, apenas em hospitais de referência. 
   * **Influência:** O aplicativo fará o rastreio via geolocalização temporária para indicar exclusivamente a unidade de saúde mais próxima equipada com o soro correto.
