import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_listt/data/categories.dart';
import 'package:shopping_listt/models/category.dart';
import 'package:shopping_listt/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  var enteredName = '';
  var enteredQuantity = 1;
  var selectedcategory = categories[Categories.vegetables]!;
  final formkey = GlobalKey<FormState>();

  void saveitem() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!
          .save(); // this will make sure that the value is valide .
      print(enteredName);
      print(enteredQuantity);
      print(selectedcategory);
      final url = Uri.https(
        "flutter-prep-d56a1-default-rtdb.firebaseio.com",
        "ShoppingList.json",
      );
     final response=await http.post (url, headers: {
        'Content-Type': 'application/json',
      }, body: json.encode({
        'name': enteredName,
        'quantity': enteredQuantity,
        'category': selectedcategory.title
      }));
      print(response.statusCode);
      print(response.body);

      if(!context.mounted){
        return;
      }
      Navigator.of(context).pop();
    }
  }

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add a new items"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value == value.isEmpty ||
                        value
                            .trim()
                            .length <= 1 ||
                        value
                            .trim()
                            .length > 50) {
                      return "Must be Between 1 and 50 characters.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value == value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Must be a valid,positive number.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // enteredName=value!;
                          enteredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: DropdownButtonFormField(
                            value: selectedcategory,
                            items: [
                              for (final category in categories.entries)
                                DropdownMenuItem(
                                    value: category.value,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 16,
                                          width: 16,
                                          color: category.value.color,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(category.value.title)
                                      ],
                                    ))
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedcategory = value!;
                              });
                            }))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          formkey.currentState!.reset();
                        },
                        child: const Text("Reset")),
                    ElevatedButton(
                        onPressed: saveitem, child: const Text("Add an item"))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
