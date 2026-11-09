## "01/09/2026"
### "Análise de estudo de caso ToxID"


## "08/09/2026"
### "Pesquisa, Benchmark e Personas"



## "14/09/2026"
### "Funcionalidades e requisitos"


## "21 e 22/09/2026"
### "Começo da criação dos protótipos de baixa e alta fidelidade e Justificativas."



## "29/09/2026"
### "Atualização nas justificativas e finalização dos protótipos"



## "03/11/2026"
### Adição do Diagrama de Casos de Uso com as novas regras de negócio da Unidade II (sincronização com Firebase, registro de ocorrência com GPS, botão de emergência, perfil de técnico/bombeiro e tratamento de falhas); do diagrama de Classes com Usuario, Ocorrencia, Animal, Soro, NoTriagem, ProcedimentoInicial e Hospital, mais os enums usados nos atributos; e da seção sobre os diagramas no `docs/uso-de-ia.md`.

### Também houve correções dos Casos de uso: "Ver detalhes do animal" passou de `«include»` para `«extend»` e o SAMU ficou ligado só ao caso de uso de ligação. E da Classes: adicionados `creditoImagem`, `formato` e os campos de filtro do `Animal`; hospital e procedimento viraram dependência; diagrama redesenhado no padrão UML (composição, autoassociação em `NoTriagem` e campos de ligação removidos)

## "09/11/2026"
### Adição da configuração inicial e infraestrutura
### Adição da pasta `lib/services` com os serviços do app:
  - `auth_service.dart`: login com Firebase Auth (e-mail/senha e Google). O perfil de administrador vem da claim `admin` do token. Sem Firebase configurado, o login só informa a falha.
  - `species_service.dart` e `hospital_service.dart`: CRUD de espécies e hospitais no Firestore (coleções `especies` e `hospitais`), com carga inicial pelo `seed_data.dart` e fallback offline.
  - `history_service.dart`: histórico local separado por usuário, sincronizado com `usuarios/{uid}/historico` quando há conexão, com nova tentativa a cada 30 segundos.
  - `location_service.dart`: leitura pontual do GPS (limite de 15 s). Se o GPS estiver desligado ou negado, devolve vazio e a triagem continua.
  - `analytics_service.dart`: eventos do Firebase Analytics (espécie vista, triagem, hospital visto, ligação e compartilhamento de emergência), sem interromper o app se falhar.
  - `hospital_route_service.dart`: rota de carro até o hospital pelo OSRM, com validação das coordenadas.
  - `nearby_hospital_service.dart`: busca de hospitais no OpenStreetMap com cache de 10 minutos. A tela de hospitais hoje usa só o cadastro do Firebase.
  - `seed_data.dart`: 12 espécies e 7 hospitais iniciais pro app funcionar offline.
