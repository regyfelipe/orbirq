import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChartData extends Equatable {
  final String label;
  final double value;
  final Color color;

  const ChartData(
    this.label,
    this.value, {
    this.color = Colors.blue,
  });

  @override
  List<Object?> get props => [label, value, color];
}
