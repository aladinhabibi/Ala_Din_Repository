/// Object equipable by a [Character].
abstract class Item {}

/// Mixin for items that can deal damage.
mixin Weapon on Item {
  int get damageValue;
}

/// Mixin for items that can provide defense.
mixin Armor on Item {
  int get defenseValue;
}

/// Weapon items that can be equipped in hands.
class Sword extends Item with Weapon {
  @override
  final int damageValue;
  Sword(this.damageValue);
}

class Axe extends Item with Weapon {
  @override
  final int damageValue;
  Axe(this.damageValue);
}

/// Armor items that can be equipped in various slots.
class Helmet extends Item with Armor {
  @override
  final int defenseValue;
  Helmet(this.defenseValue);
}

class ChestPlate extends Item with Armor {
  @override
  final int defenseValue;
  ChestPlate(this.defenseValue);
}

class Leggings extends Item with Armor {
  @override
  final int defenseValue;
  Leggings(this.defenseValue);
}

class Boots extends Item with Armor {
  @override
  final int defenseValue;
  Boots(this.defenseValue);
}

/// Entity equipping [Item]s.
class Character {
  Item? leftHand;
  Item? rightHand;
  Item? hat;
  Item? torso;
  Item? legs;
  Item? shoes;

  /// Returns all the [Item]s equipped by this [Character].
  Iterable<Item> get equipped =>
      [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

  /// Returns the total damage of this [Character].
  int get damage {
    int totalDamage = 0;
    for (final item in equipped) {
      if (item is Weapon) {
        totalDamage += item.damageValue;
      }
    }
    return totalDamage;
  }

  /// Returns the total defense of this [Character].
  int get defense {
    int totalDefense = 0;
    for (final item in equipped) {
      if (item is Armor) {
        totalDefense += item.defenseValue;
      }
    }
    return totalDefense;
  }

  /// Equips the provided [item], meaning putting it to the corresponding slot.
  ///
  /// If there's already a slot occupied, then throws a [OverflowException].
  void equip(Item item) {
    if (item is Weapon) {
      if (leftHand == null) {
        leftHand = item;
      } else if (rightHand == null) {
        rightHand = item;
      } else {
        throw OverflowException();
      }
    } else if (item is Helmet) {
      if (hat == null) {
        hat = item;
      } else {
        throw OverflowException();
      }
    } else if (item is ChestPlate) {
      if (torso == null) {
        torso = item;
      } else {
        throw OverflowException();
      }
    } else if (item is Leggings) {
      if (legs == null) {
        legs = item;
      } else {
        throw OverflowException();
      }
    } else if (item is Boots) {
      if (shoes == null) {
        shoes = item;
      } else {
        throw OverflowException();
      }
    }
  }
}

/// [Exception] indicating there's no place left in the [Character]'s slot.
class OverflowException implements Exception {}

void main() {
 // Implement mixins to differentiate [Item]s into separate categories to be
  // equipped by a [Character]: weapons should have some damage property, while
  // armor should have some defense property.
  //
  // [Character] can equip weapons into hands, helmets onto hat, etc.



  // Create a character
  final hero = Character();

  // Create some items
  final sword = Sword(10);
  final axe = Axe(15);
  final helmet = Helmet(5);
  final chestplate = ChestPlate(12);

  // Equip items
  hero.equip(sword);
  hero.equip(helmet);
  hero.equip(chestplate);

  print('Hero damage: ${hero.damage}'); // Should print 10
  print('Hero defense: ${hero.defense}'); // Should print 17

  // Equip second weapon
  hero.equip(axe);
  print('Hero damage after second weapon: ${hero.damage}'); // Should print 25

  // Try to equip a third weapon (should throw exception)
  try {
    final spear = Sword(8);
    hero.equip(spear);
  } catch (e) {
    print('Cannot equip third weapon: $e');
  }
}
