import 'package:dima_project/layout_dimension.dart';
import 'package:flutter/material.dart';

class EditFieldWidget extends StatelessWidget {
    final TextEditingController controller;
    final String initialValue;
    final double width;
    final bool isUsername;
    final String label;
    final bool edit;
    final Function editCallback;
    final GlobalKey<FormState> formKey;

    const EditFieldWidget({
      super.key, 
      required this.controller, 
      required this.initialValue, 
      required this.width, 
      required this.isUsername, 
      required this.label, 
      required this.edit, 
      required this.editCallback, 
      required this.formKey});
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    controller.text = initialValue;

    return Row(
      children: [
        SizedBox(
          width: width < limitWidth ? 230 : 320,
          child: Form(
            key: formKey,
            child: TextFormField(    
              style: !edit ? TextStyle(color: Colors.grey) : null,     
              controller: controller,
              decoration: InputDecoration(  
                labelText: label,
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                enabled: edit,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2
                  ),
                ),
                filled: true,
                fillColor: !edit ? Colors.grey.shade500.withOpacity(0.3) : null,
                hintText: !isUsername ? '(Optional)' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              validator: (value) {              
                if (value != null && value.length > 30) {
                  return 'Max 30 characters';
                }
                if (isUsername && value != null && value.isEmpty) {                  
                  return 'Please enter a username';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        !edit ? Expanded(
          child: ElevatedButton(
            key: Key('editButton'),
            child: Icon(Icons.edit_rounded),
            onPressed: () {
              editCallback(null);
            },
          )
        ): Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ElevatedButton(
                  key: Key('saveButton'),
                  child: Icon(Icons.check_rounded),
                  onPressed: () {
                    if (formKey.currentState!.validate()){
                      editCallback(true);
                    }
                  },
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: ElevatedButton(
                  key: Key('cancelButton'),
                  child: Icon(Icons.clear_rounded),
                  onPressed: () {                 
                    editCallback(false);
                  },
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}