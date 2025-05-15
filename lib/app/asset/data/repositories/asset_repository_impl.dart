import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/domain/models/transaction.dart';
import 'package:tokenai/app/asset/domain/repositories/asset_repository.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/constants/endpoints.dart';
import 'package:tokenai/interfaces/http.dart';
import 'package:dio/dio.dart';

class AssetRepositoryImpl implements AssetRepository {
  final Http _http;

  AssetRepositoryImpl({required Http http}) : _http = http;

  @override
  Future<RequestStatus> create({
    required String code,
    required Map<String, bool> flags,
  }) async {
    try {
      final publicKey = await SecureStorageServiceImpl().getPublicKey();
      final response = await _http.post(
        url: Endpoints.assets,
        data: {'code': code, 'flags': flags, 'issuer': publicKey?.trim()},
      );

      return Success(response);
    } on Exception catch (error) {
      print(error);
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus<List<Asset>>> listAssets() async {
    try {
      final publicKey = await SecureStorageServiceImpl().getPublicKey();
      final url = '${Endpoints.assets}/list/${publicKey?.trim()}';
      final response = await _http.get(url: url);

      if (response is List) {
        final assets = response.map((json) => Asset.fromJson(json)).toList();
        return Success(assets);
      }

      return Error(exception: Exception('Invalid response format'));
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus<List<Transaction>>> listTransactions() async {
    try {
      final publicKey = await SecureStorageServiceImpl().getPublicKey();
      final url = '${Endpoints.assets}/transactions/${publicKey?.trim()}';
      final response = await _http.get(url: url);

      if (response is Map && response['data'] is List) {
        final transactions =
            (response['data'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList();
        return Success(transactions);
      }

      return Error(exception: Exception('Invalid response format'));
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus> mint({
    required String code,
    required double amount,
  }) async {
    try {
      final response = await _http.post(
        url: '${Endpoints.assets}/mint',
        data: {'code': code, 'amount': amount},
      );

      return Success(response);
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus> burn({
    required String code,
    required double amount,
  }) async {
    try {
      final response = await _http.post(
        url: '${Endpoints.assets}/burn',
        data: {'code': code, 'amount': amount},
      );

      return Success(response);
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus<String>> payment({
    required String userWallet,
    required String contactWallet,
    required String amount,
    required String issuer,
    required String code,
  }) async {
    try {
      final response = await _http.post(
        url: '${Endpoints.assets}/payment',
        data: {
          'userWallet': userWallet,
          'contactWallet': contactWallet,
          'amount': amount,
          'issuer': issuer,
          'code': code,
        },
      );

      return Success(response['data']['xdr']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create payment');
    }
  }
}
