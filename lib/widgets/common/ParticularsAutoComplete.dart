import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/Particular.dart';
import '../../services/particulars_manager_service.dart';

class ParticularAutocomplete extends StatelessWidget {
  final ParticularsManagerService particularsService;
  final InputDecoration  inputDecoration;
  final void Function(Particular) onSelected;

  ParticularAutocomplete({Key? key, required this.particularsService, required this.inputDecoration, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Particular>(
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return Expanded(

          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.black),
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: inputDecoration,
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        String address = textEditingValue.text;
        if (textEditingValue.text.split(" ").length == 2) {
          address = textEditingValue.text.split(" ")[0];
        }
        List<Particular> filtered = [];

        if (address.length > 40) {
          var name = await particularsService.getParticularName(address);
          filtered = [
            Particular(particularAddress: address, username: name, favouriteOrgs: [])
          ];
        }
        return filtered;
      },
      onSelected: (Particular sp) {
        print("assigning sp ${sp.username} ${sp.particularAddress}");
        onSelected(sp);
      },
      displayStringForOption: (Particular option) => "${option.particularAddress} (${option.username})",
    );
  }
}

