import 'package:flutter/material.dart';
import 'package:shopping_listt/data/dummy_item.dart';
import 'package:shopping_listt/widgets/new_item.dart';
import 'package:shopping_listt/models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  final List<GroceryItem> groceryitem = [];

  void additem() async {
    final newitem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newitem == null) {
      return;
    }
    setState(() {
      groceryitem.add(newitem);
    });
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
          itemBuilder: (ctx, index) => Dismissible(
                background: Container(
                  color: Colors.red,
                  child:const Icon(Icons.delete),
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
