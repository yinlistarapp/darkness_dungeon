import 'dart:ui';

import 'package:darkness_dungeon/core/flying_attack_object.dart';
import 'package:darkness_dungeon/core/player/player.dart';
import 'package:darkness_dungeon/core/util/Direction.dart';
import 'package:darkness_dungeon/core/util/animated_object_once.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flame/position.dart';

extension PlayerExtensions on Player {
  void simpleAttackMelee(
    double damage, {
    double heightArea = 32,
    double widthArea = 32,
    FlameAnimation.Animation attackEffectRightAnim,
    FlameAnimation.Animation attackEffectBottomAnim,
    FlameAnimation.Animation attackEffectLeftAnim,
    FlameAnimation.Animation attackEffectTopAnim,
  }) {
    Rect positionAttack;
    FlameAnimation.Animation anim = attackEffectRightAnim;
    double pushLeft = 0;
    double pushTop = 0;
    switch (lastDirection) {
      case Direction.top:
        positionAttack = Rect.fromLTWH(
            position.left, position.top - heightArea, widthArea, heightArea);
        if (attackEffectTopAnim != null) anim = attackEffectTopAnim;
        pushTop = heightArea * -1;
        break;
      case Direction.right:
        positionAttack = Rect.fromLTWH(
            position.left + widthArea, position.top, widthArea, heightArea);
        if (attackEffectRightAnim != null) anim = attackEffectRightAnim;
        pushLeft = widthArea;
        break;
      case Direction.bottom:
        positionAttack = Rect.fromLTWH(
            position.left, position.top + heightArea, widthArea, heightArea);
        if (attackEffectBottomAnim != null) anim = attackEffectBottomAnim;
        pushTop = heightArea;
        break;
      case Direction.left:
        positionAttack = Rect.fromLTWH(
            position.left - widthArea, position.top, widthArea, heightArea);
        if (attackEffectLeftAnim != null) anim = attackEffectLeftAnim;
        pushLeft = widthArea * -1;
        break;
    }

    gameRef.add(AnimatedObjectOnce(animation: anim, position: positionAttack));

    gameRef.enemies.where((i) => i.isVisibleInMap()).forEach((enemy) {
      if (enemy.position.overlaps(positionAttack)) {
        enemy.receiveDamage(damage);
        enemy.translate(pushLeft, pushTop);
      }
    });
  }

  void simpleAttackRange({
    FlameAnimation.Animation animationRight,
    FlameAnimation.Animation animationLeft,
    FlameAnimation.Animation animationTop,
    FlameAnimation.Animation animationBottom,
    FlameAnimation.Animation animationDestroy,
    double width,
    double height,
    double speed = 1.5,
    double damage = 1,
  }) {
    Position start;
    FlameAnimation.Animation attackRangeAnimation;
    gameRef.add(FlyingAttackObject(
      direction: lastDirection,
      flyAnimation: attackRangeAnimation,
      destroyAnimation: animationDestroy,
      initPosition: start,
      height: height,
      width: width,
      damage: damage,
      speed: speed,
    ));
  }
}
