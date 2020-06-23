library navigate;

import 'dart:core';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class NavigateTransaction {
  final Function(BuildContext context, dynamic arg) pageBuilder;
  TransactionType transactionType;

  NavigateTransaction({this.pageBuilder, this.transactionType});

  RouteTransitionsBuilder build(TransactionType comeFromParam) {
    TransactionType pageTras =
        comeFromParam != null ? comeFromParam : this.transactionType;

    if (pageTras != TransactionType.fadeIn) {
      double x = 0.0;
      double y = 0.0;

      switch (pageTras) {
        case TransactionType.fromBottom:
          y = 1.0;
          break;
        case TransactionType.fromBottom:
          break;
        case TransactionType.fadeIn:
          break;
        case TransactionType.fromBottomCenter:
          break;
        case TransactionType.fromBottomRight:
          break;
        case TransactionType.fromBottomLeft:
          break;
        case TransactionType.custom:
          break;
        case TransactionType.fromTop:
          y = -1.0;
          break;
        case TransactionType.fromLeft:
          x = -1.0;
          break;
        case TransactionType.fromRight:
          x = 1.0;
          break;
      }

      if ((x != 0.0 && y == 0.0) || (y != 0.0 && x == 0.0)) {
        return (___, Animation<double> animation, ____, Widget child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
              return new SlideTransition(
                  position: Tween(begin: Offset(x, y), end: Offset(0.0, 0.0))
                      .animate(animation),
                  child: Opacity(opacity: animation.value, child: child));
            },
          );
        };
      } else {
        return (___, Animation<double> animation, ____, Widget child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
              return new ClipOval(
                  // position: Tween(begin: Offset(x, y), end: Offset(0.0, 0.0))
                  //     .animate(animation),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  clipper: _PageCome(
                      revalPercentage: animation.value, trasType: pageTras),
                  child: Opacity(opacity: animation.value, child: child));
            },
          );
        };
      }
    } else {
      return (___, Animation<double> animation, ____, Widget child) {
        return new FadeTransition(
          opacity: animation,
          child: child,
        );
      };
    }
  }
}

/* Clip Oval Transaction */
class _PageCome extends CustomClipper<ui.Rect> {
  final revalPercentage;
  final TransactionType trasType;

  _PageCome({this.revalPercentage = 0.7, this.trasType});

  @override
  ui.Rect getClip(ui.Size size) {
    // TODO: implement getClip
    double dx = (trasType == TransactionType.fromBottomRight)
        ? size.width
        : (trasType == TransactionType.fromBottomCenter)
            ? (size.width / 2)
            : 0.0;

    final escpactor = Offset(dx, size.height * 0.9);
    print("espactor" + escpactor.toString());

    double theta = atan(escpactor.dy / escpactor.dx);
    print("theta" + theta.toString());

    final distanceToCover = escpactor.dy / sin(theta);
    print("distance" + distanceToCover.toString());

    final radius = distanceToCover * revalPercentage;
    print("radius" + radius.toString());

    final diamerter =
        (radius * ((trasType == TransactionType.fromBottomLeft) ? 3.0 : 2.0));
    print("diamerter" + diamerter.toString());

    var rect = ui.Rect.fromLTWH(
        escpactor.dx - radius, escpactor.dy - radius, diamerter, diamerter);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Rect> oldClipper) {
    return true;
  }
}

/* enum of page translation type */
enum TransactionType {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
  fadeIn,
  fromBottomCenter,
  fromBottomLeft,
  fromBottomRight,
  custom,
}
