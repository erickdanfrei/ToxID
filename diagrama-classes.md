# Diagrama de Classes (Modelos de Domínio) — ToxID

**Instituição:** Universidade Tiradentes (Unit)  
**Disciplina:** Programação para Dispositivos Móveis  
**Docente:** Layse Santos Souza  

---

## 1. Visão Geral da Arquitetura de Domínio

O domínio do ToxID é estruturado em entidades ricas que encapsulam dados, serialização com o Cloud Firestore e métodos de cálculo de negócios (ex.: fórmula geodésica de Haversine para distâncias hospitalares e classificação de risco).

---

## 2. Diagrama de Classes UML (Mermaid)

```mermaid
classDiagram
    class Species {
        +String id
        +String commonName
        +String scientificName
        +String category
        +String dangerLevel
        +String antivenom
        +List~String~ colors
        +List~String~ characteristics
        +String description
        +String distribution
        +String imageUrl
        +List~String~ firstAidDo
        +List~String~ firstAidDont
        +bool isVeryDangerous
        +toMap() Map~String, dynamic~
        +fromMap(Map map, String docId) Species
        +copyWith(...) Species
    }

    class Hospital {
        +String id
        +String name
        +String state
        +String city
        +String address
        +String phone
        +String emergencyPhone
        +double latitude
        +double longitude
        +List~String~ availableSerums
        +distanceFrom(double lat, double lng) double
        +estimatedMinutesFrom(double lat, double lng) int
        +toMap() Map~String, dynamic~
        +fromMap(Map map, String docId) Hospital
        +copyWith(...) Hospital
    }

    class AppUser {
        +String uid
        +String email
        +String displayName
        +String role
        +bool isAdmin
        +toMap() Map~String, dynamic~
        +fromMap(Map map, String docId) AppUser
    }

    class TriageStep {
        +String id
        +String title
        +String subtitle
        +List~TriageOption~ options
    }

    class TriageOption {
        +String label
        +String subtitle
        +String iconName
        +String nextStepId
        +String resultSpeciesId
    }

    class SpeciesService {
        -FirebaseFirestore firestore
        -List~Species~ speciesList
        -bool isLoading
        +getById(String id) Species
        +filterSpecies(...) List~Species~
        +createSpecies(Species s) Future~bool~
        +updateSpecies(Species s) Future~bool~
        +deleteSpecies(String id) Future~bool~
    }

    class HospitalService {
        -FirebaseFirestore firestore
        -List~Hospital~ hospitals
        -bool isLoading
        +getNearbyHospitals(...) List~Hospital~
        +createHospital(Hospital h) Future~bool~
        +updateHospital(Hospital h) Future~bool~
        +deleteHospital(String id) Future~bool~
    }

    class AuthService {
        -FirebaseAuth firebaseAuth
        -AppUser currentUser
        -bool isLoading
        +signInWithEmail(String email, String pass) Future~bool~
        +signInWithGoogle() Future~bool~
        +signOut() Future~void~
    }

    class Occurrence {
        +String id
        +String userId
        +String speciesId
        +DateTime timestamp
        +double latitude
        +double longitude
        +bool synced
        +toMap()
        +generateEmergencyShareText()
    }
    class HistoryService {
        +addOccurrence(Occurrence record)
        +syncWithFirebase()
    }
    HistoryService o-- Occurrence
    Occurrence ..> Species
    Occurrence ..> AppUser
    TriageStep "1" *-- "many" TriageOption : contém
    TriageOption ..> Species : referencia (resultSpeciesId)
    SpeciesService "1" o-- "many" Species : gerencia
    HospitalService "1" o-- "many" Hospital : gerencia
    AuthService "1" o-- "1" AppUser : autentica
    Species "1" ..> "many" Hospital : compatibilidade por soro
```

---

## 3. Métodos e Responsabilidades Principais

### `Species`
* **`toMap()`**: Serializa a instância Dart em documento JSON compativel com o Cloud Firestore.
* **`fromMap(map, docId)`**: Desserializa documentos recebidos do Firestore ou dos assets JSON locais.
* **`isVeryDangerous`**: Propriedade computada para acionar alertas de nível crítico na interface.

### `Hospital`
* **`distanceFrom(userLat, userLng)`**: Implementa a fórmula esférica de Haversine:
  $$d = 2R \cdot \arcsin\left(\sqrt{\sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1)\cos(\phi_2)\sin^2\left(\frac{\Delta\lambda}{2}\right)}\right)$$
  Calcula a distância em linha reta precisa em quilômetros sem requisições a APIs pagas.
* **`estimatedMinutesFrom(userLat, userLng)`**: Estima o tempo médio em minutos para deslocamento rodoviário (velocidade média de 50 km/h).
