String searchKey(String value) {
  var text = value.trim().toLowerCase();
  const accented = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const plain = 'aaaaaeeeeiiiiooooouuuuc';
  for (var i = 0; i < accented.length; i++) {
    text = text.replaceAll(accented[i], plain[i]);
  }
  return text.replaceAll(RegExp(r'\s+'), ' ');
}
String categoryLabel(String value) => const {
  'reptiles':'Répteis', 'repteis':'Répteis',
  'aracnidos':'Aracnídeos', 'aracnideos':'Aracnídeos',
  'anfibios':'Anfíbios', 'insectos':'Insetos', 'insetos':'Insetos',
  'todas':'Todas', 'outros':'Outros',
}[searchKey(value)] ?? value.trim();
String dangerLabel(String value) => const {
  'muy peligrosa':'Muito perigosa', 'muito perigosa':'Muito perigosa',
  'peligrosa':'Perigosa', 'perigosa':'Perigosa',
  'bajo peligro':'Baixo perigo', 'baixo perigo':'Baixo perigo',
  'baixa periculosidade':'Baixo perigo',
  'no peligrosa':'Não perigosa', 'nao perigosa':'Não perigosa',
}[searchKey(value)] ?? value.trim();
String colorLabel(String value) => const {
  'negro':'Preto', 'preto':'Preto', 'rojizo':'Vermelho', 'rojo':'Vermelho',
  'avermelhado':'Vermelho', 'vermelho':'Vermelho',
  'amarillo':'Amarelo', 'amarelo':'Amarelo',
  'marron':'Marrom', 'marrom':'Marrom',
  'naranja':'Laranja', 'laranja':'Laranja',
  'blanco':'Branco', 'branco':'Branco', 'verde':'Verde',
}[searchKey(value)] ?? value.trim();
