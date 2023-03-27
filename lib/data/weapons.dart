class Weapon {
  final String name;
  final int damage;
  final double fireRate;
  final double bulletSpeed;
  final int price;

  const Weapon({
    required this.name,
    required this.damage,
    required this.fireRate,
    required this.bulletSpeed,
    required this.price,
  });
}

var weapons = const [
  Weapon(
    name: 'TypeError',
    damage: 1,
    fireRate: 0.8,
    bulletSpeed: 400,
    price: 20,
  ),
  Weapon(
    name: 'CastError',
    damage: 1,
    fireRate: 0.8,
    bulletSpeed: 300,
    price: 20,
  ),
  Weapon(
    name: 'Unhandled Exception',
    damage: 1,
    fireRate: 0.5,
    bulletSpeed: 500,
    price: 20,
  ),
  Weapon(
    name: 'Segmentation fault',
    damage: 2,
    fireRate: 1.5,
    bulletSpeed: 700,
    price: 20,
  ),
  Weapon(
    name: 'Stack Overflow',
    damage: 2,
    fireRate: 1.5,
    bulletSpeed: 600,
    price: 20,
  ),
  Weapon(
    name: 'Null Pointer',
    damage: 2,
    fireRate: 1.5,
    bulletSpeed: 500,
    price: 20,
  ),
  Weapon(
    name: 'Out of Memory',
    damage: 3,
    fireRate: 1.5,
    bulletSpeed: 800,
    price: 20,
  ),
  Weapon(
    name: 'Divide by Zero',
    damage: 3,
    fireRate: 1.3,
    bulletSpeed: 700,
    price: 20,
  ),
  Weapon(
    name: 'Bad Request',
    damage: 4,
    fireRate: 1.2,
    bulletSpeed: 800,
    price: 20,
  ),
  Weapon(
    name: 'Not Found',
    damage: 4,
    fireRate: 1.5,
    bulletSpeed: 700,
    price: 20,
  ),
  Weapon(
    name: 'Forbidden',
    damage: 5,
    fireRate: 1,
    bulletSpeed: 1000,
    price: 20,
  ),
  Weapon(
    name: 'Not Implemented',
    damage: 5,
    fireRate: 1.5,
    bulletSpeed: 900,
    price: 20,
  ),
  Weapon(
    name: 'Bad Gateway',
    damage: 5,
    fireRate: 1.5,
    bulletSpeed: 800,
    price: 20,
  ),
  Weapon(
    name: 'Service Unavailable',
    damage: 6,
    fireRate: 1.5,
    bulletSpeed: 1100,
    price: 20,
  ),
  Weapon(
    name: 'Gateway Timeout',
    damage: 6,
    fireRate: 1.5,
    bulletSpeed: 1000,
    price: 20,
  ),
];
