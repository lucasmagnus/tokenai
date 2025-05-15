import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/contacts/domain/models/contact.dart';
import 'package:tokenai/app/contacts/domain/repositories/contact_repository.dart';

// Events
abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final String name;
  final String wallet;

  AddContact({required this.name, required this.wallet});
}

class DeleteContact extends ContactEvent {
  final String id;

  DeleteContact({required this.id});
}

// States
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;

  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}

// Bloc
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;

  ContactBloc(this._contactRepository) : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
    on<AddContact>(_onAddContact);
    on<DeleteContact>(_onDeleteContact);
  }

  Future<void> _onLoadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoading());
      final contacts = await _contactRepository.getContacts();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoading());
      await _contactRepository.createContact(event.name, event.wallet);
      final contacts = await _contactRepository.getContacts();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _onDeleteContact(DeleteContact event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoading());
      await _contactRepository.deleteContact(event.id);
      final contacts = await _contactRepository.getContacts();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
} 