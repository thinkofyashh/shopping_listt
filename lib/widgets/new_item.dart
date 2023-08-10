import 'package:flutter/material.dart';
import 'package:shopping_listt/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  final formkey=GlobalKey<FormState>();
  void saveitem(){
    formkey.currentState!.validate();
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
                  if(value==null || value==value.isEmpty || value.trim().length<=1 || value.trim().length>50){
                    return "Must be Between 1 and 50 characters.";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text("Quantity"),

                      ),
                      initialValue: "1",
                        validator: (value) {
                          if(value==null || value==value.isEmpty || int.tryParse(value)==null || int.tryParse(value)!<=0){
                            return "Must be a valid,positive number.";
                          }
                          return null;
                        }
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child:DropdownButtonFormField(items: [
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
                  ], onChanged:(value){}))
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                TextButton(onPressed: (){
                  formkey.currentState!.reset();
                }, child:const Text("Reset")),
                ElevatedButton(onPressed:saveitem, child:const Text("Add an item"))
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
