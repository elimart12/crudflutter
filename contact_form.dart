import 'package:flutter/material.dart';
import 'contact.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;
  final Function(Contact) onSave;

  ContactForm({this.contact, required this.onSave});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.contact?.name ?? '');
    _phoneController =
        TextEditingController(text: widget.contact?.phone ?? '');
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id,
        name: _nameController.text,
        phone: _phoneController.text,
      );
      widget.onSave(contact);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact == null ? 'Agregar' : 'Editar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
              validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Guardar'))
          ]),
        ),
      ),
    );
  }
}
