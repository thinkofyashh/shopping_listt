import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_listt/data/categories.dart';
import 'package:shopping_listt/data/dummy_item.dart';
import 'package:shopping_listt/widgets/new_item.dart';
import 'package:shopping_listt/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
   List<GroceryItem> groceryitem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaditem();
  }

  void loaditem() async {
    final url = Uri.https(
        "flutter-prep-d56a1-default-rtdb.firebaseio.com", "ShoppingList.json");
    final response = await http.get(url);
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadeditem = [];
    for (final item in listData.entries) {
      final category=categories.entries.firstWhere((catitem) => catitem.value.title==item.value["category"]).value;
      loadeditem.add(GroceryItem(id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category));
    }
    setState(() {
      groceryitem=loadeditem;
    });
  }

  void additem() async {
    await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    loaditem();
    //final url =Uri.https("flutter-prep-d56a1-default-rtdb.firebaseio.com","ShoppingList.json");
    //final response=await http.get(url);
    //print(response.body);
  }

  void removeitem(GroceryItem item) {
    setState(() {
      groceryitem.remove(item);
    });
  }

  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No items added yet.."),
    );
    if (groceryitem.isNotEmpty) {
      content = ListView.builder(
          itemCount: groceryitem.length,
          itemBuilder: (ctx, index) =>
              Dismissible(
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                  alignment: Alignment.centerRight,
                ),
                key: ValueKey(groceryitem[index].id),
                onDismissed: (Direction) {
                  removeitem(groceryitem[index]);
                },
                child: ListTile(
                  title: Text(groceryitem[index].name),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: groceryitem[index].category.color,
                  ),
                  trailing: Text(groceryitem[index].quantity.toString()),
                ),
              ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: additem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
