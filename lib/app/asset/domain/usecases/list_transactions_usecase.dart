import 'package:tokenai/app/asset/domain/models/transaction.dart';
import 'package:tokenai/app/asset/domain/repositories/asset_repository.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

class ListTransactionsUsecase {
  final AssetRepository _repository;

  ListTransactionsUsecase(this._repository);

  Future<RequestStatus<List<Transaction>>> call() async {
    return await _repository.listTransactions();
  }
} 