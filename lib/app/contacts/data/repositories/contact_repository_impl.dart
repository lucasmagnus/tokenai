import 'package:dio/dio.dart';
import 'package:tokenai/app/contacts/domain/models/contact.dart';
import 'package:tokenai/app/contacts/domain/repositories/contact_repository.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/constants/endpoints.dart';
import 'package:tokenai/interfaces/http.dart';

class ContactRepositoryImpl implements ContactRepository {
  final Http _http;

  ContactRepositoryImpl({required Http http}) : _http = http;

  @override
  Future<List<Contact>> getContacts() async {
    try {
      final wallet = await SecureStorageServiceImpl().getPublicKey();
      final response = await _http.get(url: '${Endpoints.contacts}/$wallet');
      final List<dynamic> data = response;
      return data.map((json) => Contact.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load contacts');
    }
  }

  @override
  Future<Contact> createContact(String name, String wallet) async {
    try {
      final userWallet = await SecureStorageServiceImpl().getPublicKey();
      final response = await _http.post(
        url: Endpoints.contacts,
        data: {
          'name': name,
          'wallet': wallet,
          'userWallet': userWallet,
        },
      );
      return Contact.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create contact');
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await _http.delete(url: '${Endpoints.contacts}/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete contact');
    }
  }
} 