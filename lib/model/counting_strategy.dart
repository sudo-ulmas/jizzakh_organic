enum CountingStrategy {
  weight(name: 'кг'),
  count(name: 'шт');

  const CountingStrategy({required this.name});
  final String name;
}
