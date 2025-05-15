import 'package:tokenai/app/contacts/domain/models/contact.dart';

abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final Contact contact;

  AddContact(this.contact);
} 