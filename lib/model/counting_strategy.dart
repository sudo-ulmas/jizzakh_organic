enum CountingStrategy {
  weight(name: 'кг'),
  count(name: 'шт'),
  set(name: 'компл');

  const CountingStrategy({required this.name});
  factory CountingStrategy.fromJson(String json) => switch (json) {
        'кг' => CountingStrategy.weight,
        'шт' => CountingStrategy.count,
        _ => CountingStrategy.set,
      };
  final String name;
}
