import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/providers/user_data_provider.dart';
import 'package:whisperly/utils/dynamic_size.dart';
import 'package:whisperly/utils/validators.dart';
import 'package:whisperly/widgets/field_header.dart';
import 'package:whisperly/widgets/form_error_message.dart';

class AddContactField extends StatefulWidget {
  const AddContactField({super.key, required this.onReturnPressed});
  final VoidCallback onReturnPressed;

  @override
  State<AddContactField> createState() => _AddContactFieldState();
}

class _AddContactFieldState extends State<AddContactField> {
  final addContactFormKey = GlobalKey<FormState>();
  final TextEditingController contactCodeController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  setLoading(bool newValue) {
    setState(() {
      isLoading = newValue;
    });
  }

  addContact(UserDataProvider userDataProvider, String contactCode) async {
    errorMessage = null;
    setLoading(true);
    if (addContactFormKey.currentState!.validate()) {
      errorMessage = await userDataProvider.addContact(contactCode);
    } else {
      setLoading(false);
      return;
    }
    setLoading(false);
    if (errorMessage == null) {
      widget.onReturnPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserDataProvider userDataProvider = Provider.of<UserDataProvider>(context);

    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Stack(
        children: [
          Positioned(
            child: FieldHeader(
              title: "Add contact",
              onReturnPressed: widget.onReturnPressed,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: DynamicSize.getDynamicSmallerSizeWithMultiplier(
                      screenSize, 0.5),
                  child: Padding(
                    padding: EdgeInsets.all(
                        DynamicSize.getDynamicSmallerSizeWithMultiplier(
                            screenSize, 0.05)),
                    child: Form(
                      key: addContactFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: contactCodeController,
                            textAlign: TextAlign.center,
                            validator: (input) =>
                                Validators.validateContactCode(input),
                            onChanged: (_) => setState(() {
                              errorMessage = null;
                            }),
                            decoration: InputDecoration(
                              label: const Text('Contact code'),
                              prefixIcon: const Icon(Icons.code),
                              suffixIcon: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        addContact(userDataProvider,
                                            contactCodeController.text);
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5))
                                    : const Icon(Icons.add),
                              ),
                            ),
                          ),
                          FormErrorMessage(errorMessage: errorMessage)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
