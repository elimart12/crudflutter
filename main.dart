import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'contact.dart';
import 'contact_form.dart';

void main() {
  runApp(MaterialApp(
    home: ContactListScreen(),
  ));
}

class ContactListScreen extends StatefulWidget {
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late DBHelper dbHelper;
  List<Contact> contacts = [];

  @override
  void initState() {
    dbHelper = DBHelper();
    _loadContacts();
    super.initState();
  }

  Future<void> _loadContacts() async {
    final list = await dbHelper.getContacts();
    setState(() {
      contacts = list;
    });
  }

  void _navigateToForm({Contact? contact}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactForm(
          contact: contact,
          onSave: (c) async {
            if (c.id == null) {
              await dbHelper.insert(c);
            } else {
              await dbHelper.update(c);
            }
            _loadContacts();
          },
        ),
      ),
    );
  }

  void _deleteContact(int id) async {
    await dbHelper.delete(id);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contactos')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (_, index) {
          final c = contacts[index];
          return ListTile(
            title: Text(c.name),
            subtitle: Text(c.phone),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => _navigateToForm(contact: c)),
              IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteContact(c.id!)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
