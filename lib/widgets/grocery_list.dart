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
  final List<GroceryItem> groceryitem=[];
  void additem() async{
    final newitem=await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));
    if(newitem==null){
      return;
    }
    setState(() {
      groceryitem.add(newitem);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: additem, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
          itemCount: groceryitem.length,
          itemBuilder: (ctx, index) => ListTile(
                title: Text(groceryitem[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: groceryitem[index].category.color,
                ),
                trailing: Text(groceryitem[index].quantity.toString()),
              )),
    );
  }
}
