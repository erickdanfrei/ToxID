import '../models/species.dart';
import '../models/hospital.dart';

/// Provedor de dados offline estáticos embarcados no app.
/// Garante que o ToxID funcione em áreas rurais isoladas (RNF02: Operação 100% offline).
class SeedData {
  static final List<Species> initialSpecies = [
    const Species(
      id: 'esp-001',
      commonName: 'Cascavel Sul-Americana',
      scientificName: 'Crotalus durissus',
      category: 'Répteis',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAC - Soro Anticrotálico',
      colors: ['Marrom', 'Amarelo', 'Preto'],
      characteristics: ['Tiene Cascabel', 'Tenía manchas o rombos'],
      description:
          'Serpente venenosa com chocalho córneo característico na ponta da cauda. Veneno neurotóxico, miotóxico e coagulante.',
      distribution: 'Cerrado, Caatinga e áreas abertas do Brasil.',
      imageUrl: 'assets/visual/esp-001.webp',
      firstAidDo: [
        'Mantenha a vítima em repouso e calma',
        'Mantenha o membro acometido estendido e imóvel',
        'Lave a região apenas com água corrente e sabão neutro',
        'Procure atendimento médico e hospitalar imediatamente'
      ],
      firstAidDont: [
        'NÃO faça torniquetes ou garrotes (risco grave de necrose)',
        'NÃO corte, perfure ou queime o local da mordida',
        'NÃO tente chupar ou sugar o veneno com a boca',
        'NÃO aplique substâncias caseiras como pó de café, folhas ou álcool'
      ],
    ),
    const Species(
      id: 'esp-002',
      commonName: 'Jararaca / Jararacuçu',
      scientificName: 'Bothrops jararacussu',
      category: 'Répteis',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAB - Soro Antibotrópico',
      colors: ['Marrom', 'Preto', 'Amarelo'],
      characteristics: ['Tenía manchas o rombos', 'Manchas em forma de V invertido'],
      description:
          'Responsável por mais de 85% dos acidentes ofídicos no Brasil. Veneno proteolítico com edema intenso, necrose e hemorragias.',
      distribution: 'Mata Atlântica e matas úmidas em quase todo o país.',
      imageUrl: 'assets/visual/esp-002.webp',
      firstAidDo: [
        'Retire anéis, pulseiras e sapatos antes que a região inche',
        'Mantenha a vítima hidratada com pequenos goles de água',
        'Leve imediatamente a um pronto-socorro de referência'
      ],
      firstAidDont: [
        'NÃO amarre a perna ou o braço atingido',
        'NÃO corte a pele no ferimento',
        'NÃO ofereça bebidas alcoólicas'
      ],
    ),
    const Species(
      id: 'esp-003',
      commonName: 'Surucucu Pico-de-Jaca',
      scientificName: 'Lachesis muta',
      category: 'Répteis',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SABL - Soro Antibotrópico-Laquético',
      colors: ['Marrom', 'Laranja', 'Preto'],
      characteristics: ['Tenía manchas o rombos', 'Escamas pontiagudas eriçadas'],
      description:
          'Maior serpente peçonhenta das Américas (até 3,5m). Causa choque autonômico vagal com queda severa de pressão e diarreia.',
      distribution: 'Florestas tropicais da Amazônia e Mata Atlântica úmida.',
      imageUrl: 'assets/visual/esp-003.webp',
      firstAidDo: [
        'Lave com água e sabão',
        'Deite a vítima e mantenha-a sob vigilância estrita',
        'Encaminhe com máxima urgência ao hospital'
      ],
      firstAidDont: [
        'NÃO aplique compressas quentes ou gelo',
        'NÃO perfure a área afetada'
      ],
    ),
    const Species(
      id: 'esp-004',
      commonName: 'Coral Verdadeira',
      scientificName: 'Micrurus corallinus',
      category: 'Répteis',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAEl - Soro Antielapídico',
      colors: ['Vermelho', 'Preto', 'Branco', 'Amarelo'],
      characteristics: ['Tenia anillos de colores'],
      description:
          'Padrão característico de anéis coloridos completos ao redor do corpo. Veneno neurotóxico pré-sináptico de efeito rápido.',
      distribution: 'Território nacional em áreas de floresta e cerrados.',
      imageUrl: 'assets/visual/esp-004.webp',
      firstAidDo: [
        'Monitore a respiração da vítima a cada minuto',
        'Transporte imediato ao hospital com unidade de terapia intensiva',
        'Fotografe o animal de longe se seguro'
      ],
      firstAidDont: [
        'NÃO tente manusear ou capturar a serpente',
        'NÃO garroteie o membro'
      ],
    ),
    const Species(
      id: 'esp-005',
      commonName: 'Escorpião Amarelo',
      scientificName: 'Tityus serrulatus',
      category: 'Aracnídeos',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAEsc - Soro Antiescorpiônico',
      colors: ['Amarelo', 'Marrom'],
      characteristics: ['Era de un solo color', 'Corpo amarelo e serrilha na cauda'],
      description:
          'Causa dor intensa no ponto de inoculação, sudorese e risco de edema pulmonar agudo, especialmente letal em crianças.',
      distribution: 'Presente em áreas urbanas e rurais no Sudeste, Nordeste e Centro-Oeste.',
      imageUrl: 'assets/visual/esp-005.webp',
      firstAidDo: [
        'Aplique compressas mornas no local da picada para diminuir a dor',
        'Dê analgésico oral simples se indicado',
        'Leve a vítima urgente para avaliação soroterápica'
      ],
      firstAidDont: [
        'NÃO passe querosene, ervas ou álcool',
        'NÃO faça torniquetes'
      ],
    ),
    const Species(
      id: 'esp-006',
      commonName: 'Escorpião do Nordeste',
      scientificName: 'Tityus stigmurus',
      category: 'Aracnídeos',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAEsc - Soro Antiescorpiônico',
      colors: ['Amarelo', 'Marrom'],
      characteristics: ['Mancha triangular escura dorsal'],
      description:
          'Coloração amarelo-palha com triângulo castanho escuro no dorso. Grande responsável por acidentes escorpiônicos no Nordeste.',
      distribution: 'Região Nordeste brasileira.',
      imageUrl: 'assets/visual/esp-006.webp',
      firstAidDo: [
        'Compressas mornas no ferimento',
        'Transporte para centro médico'
      ],
      firstAidDont: [
        'NÃO aperte nem faça sangrias'
      ],
    ),
    const Species(
      id: 'esp-007',
      commonName: 'Aranha Armadeira',
      scientificName: 'Phoneutria nigriventer',
      category: 'Aracnídeos',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SAAr - Soro Antiaraquídico',
      colors: ['Marrom', 'Preto'],
      characteristics: ['Ergue as patas dianteiras', 'Tenía manchas o rombos'],
      description:
          'Aranha agressiva que não tece teia aérea regular; assume postura de ataque erguendo as pernas dianteiras. Dor violenta imediata.',
      distribution: 'Habitante comum de bananeiras, lenha e entulhos.',
      imageUrl: 'assets/visual/esp-007.webp',
      firstAidDo: [
        'Lave com água e sabão neutro',
        'Compressa morna para aliviar o espasmo doloroso',
        'Procure hospital de referência'
      ],
      firstAidDont: [
        'NÃO fure ou esprema o local'
      ],
    ),
    const Species(
      id: 'esp-008',
      commonName: 'Viúva Negra',
      scientificName: 'Latrodectus curacaviensis',
      category: 'Aracnídeos',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SALatr - Soro Antilatrodéctico',
      colors: ['Preto', 'Vermelho'],
      characteristics: ['Mancha em ampulheta vermelha no abdômen'],
      description:
          'Aranha pequena com abdômen esférico lustroso e mancha vermelha. Envenenamento causa rigidez muscular abdominal e taquicardia.',
      distribution: 'Restingas litorâneas e ambientes campestres.',
      imageUrl: 'assets/visual/esp-008.webp',
      firstAidDo: [
        'Mantenha repouso absoluto',
        'Busque hospitalização imediata'
      ],
      firstAidDont: [
        'NÃO queime nem coloque emplastros químicos'
      ],
    ),
    const Species(
      id: 'esp-009',
      commonName: 'Lagarta Lonomia (Taturana)',
      scientificName: 'Lonomia obliqua',
      category: 'Insetos',
      dangerLevel: 'Muito perigosa',
      antivenom: 'SALon - Soro Antilonômico',
      colors: ['Marrom', 'Verde', 'Laranja'],
      characteristics: ['Espinhos em formato de pinheiro no dorso'],
      description:
          'Lagarta gregária que vive em troncos. Contato com suas cerdas inocula toxina potente que desfaz o fibrinogênio causando hemorragias graves.',
      distribution: 'Regiões Sul, Sudeste e Centro-Oeste.',
      imageUrl: 'assets/visual/esp-009.webp',
      firstAidDo: [
        'Lave abundantemente a área com água corrente fria',
        'Leve a lagarta (em pote seguro) se possível para identificação',
        'Vá imediatamente ao hospital para exames de coagulação'
      ],
      firstAidDont: [
        'NÃO esfregue a área afetada',
        'NÃO use fitas adesivas abrasivas para arrancar espinhos'
      ],
    ),
    const Species(
      id: 'esp-010',
      commonName: 'Abelha Africanizada',
      scientificName: 'Apis mellifera scutellata',
      category: 'Insetos',
      dangerLevel: 'Perigosa',
      antivenom: 'Tratamento de Choque Anafilático / Suporte Clínico',
      colors: ['Amarelo', 'Preto'],
      characteristics: ['Listrada em preto e amarelo'],
      description:
          'Extrema agressividade coletiva. Ataques com centenas de ferroadas podem levar à insuficiência renal aguda e anafilaxia fatal.',
      distribution: 'Presente em todo o território nacional.',
      imageUrl: 'assets/visual/esp-010.webp',
      firstAidDo: [
        'Raspe os ferrões horizontalmente com lâmina, cartão ou unha (não aperte)',
        'Aplique compressas frias para diminuir o inchaço',
        'Procure socorro rápido em caso de picadas múltiplas ou dificuldade para respirar'
      ],
      firstAidDont: [
        'NÃO esprema a bolsa de veneno do ferrão com pinças'
      ],
    ),
    const Species(
      id: 'esp-011',
      commonName: 'Sapo Cururu',
      scientificName: 'Rhinella marina',
      category: 'Anfíbios',
      dangerLevel: 'Perigosa',
      antivenom: 'Lavagem Imediata e Suporte Sintomático',
      colors: ['Marrom', 'Amarelo'],
      characteristics: ['Grandes glândulas atrás dos olhos', 'Pele verrucosa'],
      description:
          'Possui veneno leitoso nas glândulas paratóides que é expelido quando comprimido. Causa irritação grave em olhos e mucosas.',
      distribution: 'Ampla ocorrência no Brasil em áreas alagadas e quintais.',
      imageUrl: 'assets/visual/esp-011.webp',
      firstAidDo: [
        'Lavar olhos ou boca atingidos com soro ou água abundante por 15 minutos',
        'Procurar avaliação médica se persistir ardência'
      ],
      firstAidDont: [
        'NÃO esfregar os olhos com as mãos contaminadas'
      ],
    ),
    const Species(
      id: 'esp-012',
      commonName: 'Rã Flecha Dourada',
      scientificName: 'Phyllobates terribilis',
      category: 'Anfíbios',
      dangerLevel: 'Muito perigosa',
      antivenom: 'Suporte Intensivo Imediato',
      colors: ['Amarelo', 'Laranja'],
      characteristics: ['Era de un solo color', 'Coloração amarelo brilhante'],
      description:
          'Anfíbio dotado de alcaloides venenosos na pele (batracotoxina). Pequeníssima quantidade é suficiente para paralisar músculos vitais.',
      distribution: 'Florestas tropicais neotropicais.',
      imageUrl: 'assets/visual/esp-012.webp',
      firstAidDo: [
        'Lavagem imediata com água',
        'Encaminhamento emergencial ao hospital'
      ],
      firstAidDont: [
        'NÃO tocar no animal sem proteção adequada'
      ],
    ),
  ];

  static final List<Hospital> initialHospitals = [
    const Hospital(
      id: 'hosp-001',
      name: 'Hospital Estadual de Urgências de Goiás Dr. Valdemiro Cruz (HUGO)',
      state: 'Goiás',
      city: 'Goiânia',
      address: 'Av. 1ª Radial, s/n - St. Pedro Ludovico',
      phone: '(62) 3201-4300',
      emergencyPhone: '192',
      latitude: -16.7118,
      longitude: -49.2555,
      availableSerums: ['SAB', 'SAC', 'SAEsc', 'SAAr'],
    ),
    const Hospital(
      id: 'hosp-002',
      name: 'HUGOL - Hospital de Urgências Gov. Otávio Lage de Siqueira',
      state: 'Goiás',
      city: 'Goiânia',
      address: 'Av. Anhanguera, 14527 - Santos Dumont',
      phone: '(62) 3270-6300',
      emergencyPhone: '192',
      latitude: -16.6341,
      longitude: -49.3496,
      availableSerums: ['SAB', 'SAC', 'SABL', 'SAEl', 'SAEsc', 'SAAr', 'SALon'],
    ),
    const Hospital(
      id: 'hosp-003',
      name: 'Hospital das Clínicas da UFG / EBSERH',
      state: 'Goiás',
      city: 'Goiânia',
      address: 'Primeira Avenida, s/n - Setor Leste Universitário',
      phone: '(62) 3269-8200',
      emergencyPhone: '192',
      latitude: -16.6784,
      longitude: -49.2435,
      availableSerums: ['SAB', 'SAC', 'SAEsc', 'SAAr'],
    ),
    const Hospital(
      id: 'hosp-004',
      name: 'Hospital Estadual Alberto Rassi (HGG)',
      state: 'Goiás',
      city: 'Goiânia',
      address: 'Av. Anhanguera, 6479 - St. Oeste',
      phone: '(62) 3209-9800',
      emergencyPhone: '192',
      latitude: -16.6802,
      longitude: -49.2731,
      availableSerums: ['SAB', 'SAC', 'SAEsc'],
    ),
    const Hospital(
      id: 'hosp-005',
      name: 'Hospital Vital Brazil - Instituto Butantan',
      state: 'São Paulo',
      city: 'São Paulo',
      address: 'Av. Vital Brasil, 1500 - Butantã',
      phone: '(11) 2627-9529',
      emergencyPhone: '192',
      latitude: -23.5674,
      longitude: -46.7198,
      availableSerums: ['SAB', 'SAC', 'SABL', 'SAEl', 'SAEsc', 'SAAr', 'SALatr', 'SALon'],
    ),
    const Hospital(
      id: 'hosp-006',
      name: 'Hospital João XXIII - FHEMIG (CIATox-MG)',
      state: 'Minas Gerais',
      city: 'Belo Horizonte',
      address: 'Alameda Ezequiel Dias, 225 - Santa Efigênia',
      phone: '(31) 3239-9200',
      emergencyPhone: '192',
      latitude: -19.9248,
      longitude: -43.9317,
      availableSerums: ['SAB', 'SAC', 'SABL', 'SAEl', 'SAEsc', 'SAAr', 'SALon'],
    ),
    const Hospital(
      id: 'hosp-007',
      name: 'Hospital de Urgência de Sergipe (HUSE)',
      state: 'Sergipe',
      city: 'Aracaju',
      address: 'Av. Tancredo Neves, s/n - Capucho',
      phone: '(79) 3216-2600',
      emergencyPhone: '192',
      latitude: -10.9416,
      longitude: -37.0722,
      availableSerums: ['SAB', 'SAC', 'SAEsc', 'SAAr'],
    ),
  ];
}
