import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/domain/models/transaction.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

abstract interface class AssetRepository {
  Future<RequestStatus> create({
    required String code,
    required Map<String, bool> flags
  });

  Future<RequestStatus<List<Asset>>> listAssets();

  Future<RequestStatus<List<Transaction>>> listTransactions();

  Future<RequestStatus> mint({
    required String code,
    required double amount,
  });

  Future<RequestStatus> burn({
    required String code,
    required double amount,
  });

  Future<RequestStatus<String>> payment({
    required String userWallet,
    required String contactWallet,
    required String amount,
    required String issuer,
    required String code,
  });
}
