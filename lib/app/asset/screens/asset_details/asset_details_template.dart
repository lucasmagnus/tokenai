import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/components/atoms/detail_item.dart';
import 'package:tokenai/components/atoms/feature_chip.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';

import 'components/asset_action_bottom_sheet.dart';
import 'components/asset_header.dart';

class AssetDetailsTemplate extends StatelessWidget {
  final Asset asset;
  final AssetBloc assetBloc;

  const AssetDetailsTemplate({super.key, required this.asset, required this.assetBloc});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: CupertinoNavigationBar(
        middle: Text(
          asset.code,
          style: TextStyle(color: Theme.of(context).kTextColor),
        ),
        transitionBetweenRoutes: true,
        backgroundColor: Theme.of(context).kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetHeader(asset: asset, assetBloc: assetBloc,),
            _buildDetails(context),
            _buildFeatures(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).kBackgroundColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).kTextColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Asset Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  'Asset Code',
                  asset.code,
                  Icons.code,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  'Issuer Wallet',
                  asset.issuerWallet,
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  'Created At',
                  asset.createdAt.toString().split(' ')[0],
                  Icons.calendar_today,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  'Last Updated',
                  asset.updatedAt.toString().split(' ')[0],
                  Icons.update,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).kTextColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).kBackgroundColorLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.featured_play_list_outlined,
                  color: Theme.of(context).kTextColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Asset Features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (asset.authorizationRequired)
                  _buildFeatureChip(
                    'Authorization Required',
                    Icons.security,
                    Colors.blue,
                  ),
                if (asset.authorizationRevocable)
                  _buildFeatureChip(
                    'Authorization Revocable',
                    Icons.sync,
                    Colors.green,
                  ),
                if (asset.clawbackEnabled)
                  _buildFeatureChip(
                    'Clawback Enabled',
                    Icons.replay,
                    Colors.orange,
                  ),
                if (asset.authorizationImmutable)
                  _buildFeatureChip(
                    'Authorization Immutable',
                    Icons.lock,
                    Colors.red,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
