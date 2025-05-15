import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/asset/domain/models/transaction.dart';
import 'package:tokenai/app/asset/screens/asset_details/asset_details_screen.dart';
import 'package:tokenai/app/asset/screens/create_asset/create_asset_screen.dart';
import 'package:tokenai/app/asset/utils/asset_colors.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/app/core/navigation/route_navigator.dart';
import 'package:tokenai/app/core/utils/formatters.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/utils/stellar_utils.dart';

class HomeTemplate extends StatelessWidget {
  final List<Asset> assets;
  final List<Transaction> transactions;
  final RequestStatus listStatus;
  final RequestStatus transactionsStatus;
  final VoidCallback onRefresh;

  const HomeTemplate({
    super.key,
    required this.assets,
    required this.transactions,
    required this.listStatus,
    required this.transactionsStatus,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: CupertinoNavigationBar(
        middle: Text(
          'TokenAI',
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        transitionBetweenRoutes: true,
        backgroundColor: Theme.of(context).kBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (listStatus is Loading && assets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listStatus is Error && assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${(listStatus as Error).exception?.toString() ?? 'Unknown error'}',
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Assets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: assets.length + 1,
              itemBuilder: (context, index) {
                if (index == assets.length) {
                  return _buildCreateCard(context);
                }

                final asset = assets[index];
                return _buildAssetCard(context, asset);
              },
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recent Operations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          _buildTransactionsList(context),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset) {
    final colors = AssetColors.getColorsForAsset(asset.code);
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                RouteNavigator.pushNamed(
                  routeName: AssetDetailsScreen.ROUTE_NAME,
                  arguments: asset,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          asset.code,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'TokenAI',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      Formatters.formatAmount(asset.balance),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCard(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            RouteNavigator.pushNamed(routeName: CreateAssetScreen.ROUTE_NAME);
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 48, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Create New Asset',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    if (transactionsStatus is Loading && transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final reversedTransactions = List<Transaction>.from(transactions.reversed);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reversedTransactions.length,
      itemBuilder: (context, index) {
        final transaction = reversedTransactions[index];
        return _buildTransactionItem(context, transaction);
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final isDebit = transaction.isDebit;
    final formattedAmount = Formatters.formatAmount(transaction.amount);
    final formattedDate = Formatters.formatDate(transaction.createdAt);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).kBackgroundColorLight,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isDebit
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
          child: Icon(
            isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebit ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          '${transaction.assetCode ?? 'XLM'} to ${formatWallet(transaction.account)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formattedDate),
        trailing: Text(
          '${isDebit ? '-' : '+'} $formattedAmount',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDebit ? Colors.red : Colors.green,
            fontSize: 14
          ),
        ),
      ),
    );
  }
}
