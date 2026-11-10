# Mapeamento do Firestore

| Caminho | Modelo | Conteúdo e acesso |
|---|---|---|
| especies/{id} | Species | Nome popular/científico, categoria, perigo, cores, características, soro e orientações. Leitura pública. Escrita administrativa. |
| hospitais/{id} | Hospital | Nome, endereço, coordenadas, telefone e soros. Leitura pública. Escrita administrativa. |
| usuarios/{uid}/historico/{id} | Occurrence | Identificação, data ISO, userId e coordenadas opcionais. Leitura e gravação exclusivas do proprietário. |

Species e Hospital usam toMap e fromMap para os documentos. Occurrence preserva coordenadas ausentes como null. O campo synced representa a confirmação local da gravação. A chave do documento permanece a mesma nas tentativas de sincronização.

AppUser é construído a partir do Firebase Auth. A autorização administrativa vem da custom claim admin. As regras implantáveis estão em firestore.rules.
