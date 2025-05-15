import 'package:tokenai/app/contacts/domain/models/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts();
  Future<void> createContact(String name, String wallet);
  Future<void> deleteContact(String id);
}