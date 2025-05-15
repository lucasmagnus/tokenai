import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/domain/models/transaction.dart';
import 'package:tokenai/app/asset/domain/repositories/asset_repository.dart';
import 'package:tokenai/app/asset/domain/usecases/list_transactions_usecase.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

part 'asset_event.dart';

part 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository _assetRepository;
  final ListTransactionsUsecase _listTransactionsUsecase;

  AssetBloc({required AssetRepository assetRepository})
    : _assetRepository = assetRepository,
      _listTransactionsUsecase = ListTransactionsUsecase(assetRepository),
      super(AssetState.initial()) {
    on<CreateAsset>(_createAsset);
    on<ListAssets>(_listAssets);
    on<ListTransactions>(_listTransactions);
    on<MintAsset>(_mintAsset);
    on<BurnAsset>(_burnAsset);
    on<Payment>(_payment);
  }

  void _createAsset(CreateAsset event, Emitter emit) async {
    emit(state.copyWith(createStatus: const RequestStatus.loading()));
    try {
      final response = await _assetRepository.create(
        code: event.code,
        flags: event.flags,
      );
      response.when(
        idle: () {},
        loading: () {},
        success: (data) async {
          emit(state.copyWith(createStatus: RequestStatus.success(data)));

          final assetsResponse = await _assetRepository.listAssets();
          final transactionsResponse = await _listTransactionsUsecase();

          if (!emit.isDone) {
            assetsResponse.when(
              idle: () {},
              loading: () {},
              success: (assets) {
                transactionsResponse.when(
                  idle: () {},
                  loading: () {},
                  success: (transactions) {
                    emit(
                      state.copyWith(
                        assets: assets,
                        transactions: transactions,
                      ),
                    );
                  },
                  error: (code, message, exception) {
                    emit(
                      state.copyWith(
                        transactionsStatus: RequestStatus.error(
                          code: code,
                          message: message,
                          exception: exception,
                        ),
                      ),
                    );
                  },
                );
              },
              error: (code, message, exception) {
                emit(
                  state.copyWith(
                    listStatus: RequestStatus.error(
                      code: code,
                      message: message,
                      exception: exception,
                    ),
                  ),
                );
              },
            );
          }
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              createStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          createStatus: RequestStatus.error(
            exception: error is Exception ? error : Exception(error.toString()),
          ),
        ),
      );
    }
  }

  void _listAssets(ListAssets event, Emitter emit) async {
    emit(state.copyWith(listStatus: const RequestStatus.loading()));
    try {
      final response = await _assetRepository.listAssets();
      response.when(
        idle: () {},
        loading: () {},
        success: (assets) {
          emit(
            state.copyWith(
              listStatus: RequestStatus.success(assets),
              assets: assets,
            ),
          );
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              listStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          listStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to list assets',
            exception: e,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          listStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to list assets',
            exception: Exception(e.toString()),
          ),
        ),
      );
    }
  }

  void _listTransactions(ListTransactions event, Emitter emit) async {
    emit(state.copyWith(transactionsStatus: const RequestStatus.loading()));
    try {
      final response = await _listTransactionsUsecase();
      response.when(
        idle: () {},
        loading: () {},
        success: (transactions) {
          emit(
            state.copyWith(
              transactionsStatus: RequestStatus.success(transactions),
              transactions: transactions,
            ),
          );
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              transactionsStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          transactionsStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to list transactions',
            exception: e,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          transactionsStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to list transactions',
            exception: Exception(e.toString()),
          ),
        ),
      );
    }
  }

  void _mintAsset(MintAsset event, Emitter emit) async {
    emit(state.copyWith(mintStatus: const RequestStatus.loading()));
    try {
      final response = await _assetRepository.mint(
        code: event.code,
        amount: event.amount,
      );
      response.when(
        idle: () {},
        loading: () {},
        success: (data) async {
          emit(state.copyWith(mintStatus: RequestStatus.success(data)));

          final assetsResponse = await _assetRepository.listAssets();
          final transactionsResponse = await _listTransactionsUsecase();

          assetsResponse.when(
            idle: () {},
            loading: () {},
            success: (assets) {
              transactionsResponse.when(
                idle: () {},
                loading: () {},
                success: (transactions) {
                  emit(
                    state.copyWith(assets: assets, transactions: transactions),
                  );
                },
                error: (code, message, exception) {
                  emit(
                    state.copyWith(
                      transactionsStatus: RequestStatus.error(
                        code: code,
                        message: message,
                        exception: exception,
                      ),
                    ),
                  );
                },
              );
            },
            error: (code, message, exception) {
              emit(
                state.copyWith(
                  listStatus: RequestStatus.error(
                    code: code,
                    message: message,
                    exception: exception,
                  ),
                ),
              );
            },
          );
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              mintStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          mintStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to mint asset',
            exception: e,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          mintStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to mint asset',
            exception: Exception(e.toString()),
          ),
        ),
      );
    }
  }

  void _burnAsset(BurnAsset event, Emitter emit) async {
    emit(state.copyWith(burnStatus: const RequestStatus.loading()));
    try {
      final response = await _assetRepository.burn(
        code: event.code,
        amount: event.amount,
      );
      response.when(
        idle: () {},
        loading: () {},
        success: (data) async {
          emit(state.copyWith(burnStatus: RequestStatus.success(data)));

          final assetsResponse = await _assetRepository.listAssets();
          final transactionsResponse = await _listTransactionsUsecase();

          assetsResponse.when(
            idle: () {},
            loading: () {},
            success: (assets) {
              transactionsResponse.when(
                idle: () {},
                loading: () {},
                success: (transactions) {
                  emit(
                    state.copyWith(assets: assets, transactions: transactions),
                  );
                },
                error: (code, message, exception) {
                  emit(
                    state.copyWith(
                      transactionsStatus: RequestStatus.error(
                        code: code,
                        message: message,
                        exception: exception,
                      ),
                    ),
                  );
                },
              );
            },
            error: (code, message, exception) {
              emit(
                state.copyWith(
                  listStatus: RequestStatus.error(
                    code: code,
                    message: message,
                    exception: exception,
                  ),
                ),
              );
            },
          );
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              burnStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          burnStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to burn asset',
            exception: e,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          burnStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to burn asset',
            exception: Exception(e.toString()),
          ),
        ),
      );
    }
  }

  void _payment(Payment event, Emitter emit) async {
    emit(state.copyWith(paymentStatus: const RequestStatus.loading()));
    try {
      final response = await _assetRepository.payment(
        userWallet: event.userWallet,
        contactWallet: event.contactWallet,
        amount: event.amount,
        issuer: event.issuer,
        code: event.code,
      );
      response.when(
        idle: () {},
        loading: () {},
        success: (xdr) {
          emit(state.copyWith(paymentStatus: RequestStatus.success(xdr)));
        },
        error: (code, message, exception) {
          emit(
            state.copyWith(
              paymentStatus: RequestStatus.error(
                code: code,
                message: message,
                exception: exception,
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          paymentStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to create payment',
            exception: e,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          paymentStatus: RequestStatus.error(
            code: 500,
            message: 'Failed to create payment',
            exception: Exception(e.toString()),
          ),
        ),
      );
    }
  }
}
