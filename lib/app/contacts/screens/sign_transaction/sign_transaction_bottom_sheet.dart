import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/constants/all.dart';

class SignTransactionBottomSheet extends StatelessWidget {
  final String xdr;
  final VoidCallback onSign;

  const SignTransactionBottomSheet({
    super.key,
    required this.xdr,
    required this.onSign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).kBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sign Transaction',
                style: TextStyle(
                  color: Theme.of(context).kTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).kTextColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Transaction XDR',
            style: TextStyle(
              color: Theme.of(context).kTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).kBackgroundColorLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).kPrimaryColor),
            ),
            child: Text(
              xdr,
              style: TextStyle(
                color: Theme.of(context).kTextColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSign,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Sign Transaction',
                style: TextStyle(
                  color: Theme.of(context).kBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
