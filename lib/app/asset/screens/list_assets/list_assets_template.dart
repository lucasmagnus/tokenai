import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/components/templates/base_layout.dart';

class ListAssetsTemplate extends StatelessWidget {
  final List<Asset> assets;
  final RequestStatus listStatus;
  final VoidCallback onRefresh;

  const ListAssetsTemplate({
    super.key,
    required this.assets,
    required this.listStatus,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: CupertinoNavigationBar(
        middle: const Text('Assets'),
        transitionBetweenRoutes: true,
      ),
      padding: const EdgeInsets.all(16),
      body: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: listStatus is Loading && assets.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return assets.isEmpty
        ? const Center(child: Text('No assets found'))
        : ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return AssetCard(asset: asset);
            },
          );
  }
}

class AssetCard extends StatelessWidget {
  final Asset asset;

  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asset.code,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Issuer: ${asset.issuerWallet}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (asset.authorizationRequired)
                  _buildFlagChip('Authorization Required'),
                if (asset.authorizationRevocable)
                  _buildFlagChip('Authorization Revocable'),
                if (asset.clawbackEnabled)
                  _buildFlagChip('Clawback Enabled'),
                if (asset.authorizationImmutable)
                  _buildFlagChip('Authorization Immutable'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: CupertinoColors.systemGrey5,
    );
  }
} 