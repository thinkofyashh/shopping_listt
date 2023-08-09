import 'package:flutter/material.dart';
import 'package:shopping_listt/models/category.dart';
class GroceryItem{
  const GroceryItem({required this.id,required this.name,required this.quantity,required this.category});
  final String id;
  final String name;
  final double quantity;
  final Category category;

}
