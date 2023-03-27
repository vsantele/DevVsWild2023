class Wave {
  int nbEnemyRight;
  int nbEnemyLeft;
  int healthMin;
  int healthMax;

  int currentEnemyRight = 0;
  int currentEnemyLeft = 0;

  Wave({
    required this.nbEnemyRight,
    required this.nbEnemyLeft,
    required this.healthMin,
    required this.healthMax,
  }) {
    currentEnemyRight = nbEnemyRight;
    currentEnemyLeft = nbEnemyLeft;
  }
}

var waves = [
  Wave(nbEnemyLeft: 5, nbEnemyRight: 5, healthMin: 1, healthMax: 2),
  Wave(nbEnemyLeft: 7, nbEnemyRight: 6, healthMin: 1, healthMax: 3),
  Wave(nbEnemyLeft: 8, nbEnemyRight: 7, healthMin: 1, healthMax: 3),
  Wave(nbEnemyLeft: 9, nbEnemyRight: 8, healthMin: 2, healthMax: 3),
  Wave(nbEnemyLeft: 10, nbEnemyRight: 9, healthMin: 2, healthMax: 3),
  Wave(nbEnemyLeft: 11, nbEnemyRight: 10, healthMin: 2, healthMax: 3),
  Wave(nbEnemyLeft: 12, nbEnemyRight: 11, healthMin: 2, healthMax: 3),
  Wave(nbEnemyLeft: 13, nbEnemyRight: 12, healthMin: 2, healthMax: 3),
  Wave(nbEnemyLeft: 14, nbEnemyRight: 13, healthMin: 2, healthMax: 3),
];
