part of 'asset_bloc.dart';

class AssetState extends Equatable {
  final RequestStatus createStatus;
  final RequestStatus listStatus;
  final RequestStatus transactionsStatus;
  final RequestStatus mintStatus;
  final RequestStatus burnStatus;
  final RequestStatus paymentStatus;
  final List<Asset> assets;
  final List<Transaction> transactions;
  final bool isNameValid;

  const AssetState({
    required this.listStatus,
    required this.transactionsStatus,
    required this.mintStatus,
    required this.burnStatus,
    required this.paymentStatus,
    required this.assets,
    required this.transactions,
    this.createStatus = const RequestStatus.idle(),
    this.isNameValid = false
  });

  factory AssetState.initial() {
    return const AssetState(
      createStatus: RequestStatus.idle(),
      listStatus: RequestStatus.idle(),
      transactionsStatus: RequestStatus.idle(),
      mintStatus: RequestStatus.idle(),
      burnStatus: RequestStatus.idle(),
      paymentStatus: RequestStatus.idle(),
      assets: [],
      transactions: [],
    );
  }

  @override
  List<Object> get props => [
        createStatus,
        listStatus,
        transactionsStatus,
        mintStatus,
        burnStatus,
        paymentStatus,
        assets,
        transactions,
        isNameValid,
      ];

  AssetState copyWith({
    RequestStatus? createStatus,
    RequestStatus? listStatus,
    RequestStatus? transactionsStatus,
    RequestStatus? mintStatus,
    RequestStatus? burnStatus,
    RequestStatus? paymentStatus,
    List<Asset>? assets,
    List<Transaction>? transactions,
    bool? isNameValid,
  }) {
    return AssetState(
      createStatus: createStatus ?? this.createStatus,
      listStatus: listStatus ?? this.listStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      mintStatus: mintStatus ?? this.mintStatus,
      burnStatus: burnStatus ?? this.burnStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      assets: assets ?? this.assets,
      transactions: transactions ?? this.transactions,
      isNameValid: isNameValid ?? this.isNameValid,
    );
  }
}
