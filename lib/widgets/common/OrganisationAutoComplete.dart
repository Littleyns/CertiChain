import 'package:chatflutter/services/organisations_manager_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/Organisation.dart';


class OrganisationAutocomplete extends StatelessWidget {
  final OrganisationsManagerService organisationsService;
  final InputDecoration  inputDecoration;
  final void Function(Organisation) onSelected;

  OrganisationAutocomplete({Key? key, required this.organisationsService, required this.inputDecoration, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Organisation>(
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
        List<Organisation> filtered = [];

        if (address.length > 40) {
          var name = await organisationsService.getOrganisationName(address);
          filtered = [
            Organisation(orgAddress: address, name: name, domain: Domain.Government)
          ];
        }
        return filtered;
      },
      onSelected: (Organisation org) {
        print("assigning sp ${org.name} ${org.orgAddress}");
        onSelected(org);
      },
      displayStringForOption: (Organisation option) => "${option.orgAddress} (${option.name})",
    );
  }
}

