import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/asset/blocs/asset/asset_bloc.dart';
import 'package:tokenai/app/asset/domain/models/asset.dart';
import 'package:tokenai/app/contacts/domain/models/contact.dart';
import 'package:tokenai/app/contacts/screens/sign_transaction/sign_transaction_bottom_sheet.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/services/stellar_service.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/services/snackbar.dart';
import 'package:tokenai/utils/stellar_utils.dart';

class MakePaymentScreen extends StatefulWidget {
  static const ROUTE_NAME = 'make-payment';
  static const CONTACT_ARG = 'contact';

  final AssetBloc assetBloc;
  final Contact contact;

  const MakePaymentScreen(this.assetBloc, this.contact, {super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  Asset? _selectedAsset;
  bool _isLoading = false;
  final _stellarService = StellarService(SecureStorageServiceImpl());

  @override
  void initState() {
    super.initState();
    widget.assetBloc.add(const ListAssets());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (_formKey.currentState!.validate() && _selectedAsset != null) {
      setState(() => _isLoading = true);

      try {
        final userWallet = await SecureStorageServiceImpl().getPublicKey();
        if (userWallet == null) {
          throw Exception('User wallet not found');
        }

        widget.assetBloc.add(
          Payment(
            userWallet: userWallet,
            contactWallet: widget.contact.wallet,
            amount: _amountController.text,
            issuer: _selectedAsset!.issuerWallet,
            code: _selectedAsset!.code,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        SnackBarService.of(context).error(e, 'Failed to create payment');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleSignTransaction(String xdr) async {
    try {
      Navigator.pop(context); // Close bottom sheet
      setState(() => _isLoading = true);

      // Sign and submit the transaction
      await _stellarService.signTransaction(xdr);

      if (!mounted) return;

      // Show success message
      SnackBarService.of(context).success('Payment sent successfully');

      Navigator.pop(context); // Return to contacts list
    } catch (e) {
      if (!mounted) return;
      SnackBarService.of(context).error(e, 'Failed to sign transaction');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSignTransactionBottomSheet(String xdr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SignTransactionBottomSheet(
            xdr: xdr,
            onSign: () => _handleSignTransaction(xdr),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.assetBloc,
      child: BlocListener<AssetBloc, AssetState>(
        bloc: widget.assetBloc,
        listener: makePaymentBlocListener,
        child: BaseLayout(
          appBar: CupertinoNavigationBar(
            middle: Text(
              'Make Payment',
              style: TextStyle(color: Theme.of(context).kTextColor),
            ),
            transitionBetweenRoutes: true,
            backgroundColor: Theme.of(context).kBackgroundColor,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Recipient',
                  style: TextStyle(
                    color: Theme.of(context).kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).kBackgroundColorLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contact.name,
                        style: TextStyle(
                          color: Theme.of(context).kTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.contact.wallet,
                        style: TextStyle(
                          color: Theme.of(context).kTextColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Asset',
                  style: TextStyle(
                    color: Theme.of(context).kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<AssetBloc, AssetState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).kBackgroundColorLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Asset>(
                          value: _selectedAsset,
                          isExpanded: true,
                          hint: Text(
                            'Select an asset',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).kTextColor.withOpacity(0.7),
                            ),
                          ),
                          items:
                              state.assets.map((asset) {
                                return DropdownMenuItem(
                                  value: asset,
                                  child: Text(
                                    '${asset.code} (${formatBalance(asset.balance)})',
                                    style: TextStyle(
                                      color: Theme.of(context).kTextColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedAsset = value);
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Amount',
                  style: TextStyle(
                    color: Theme.of(context).kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(
                      color: Theme.of(context).kTextColor.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).kBackgroundColorLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Button(
                  label: 'Confirm payment',
                  type: ButtonType.PRIMARY,
                  onPressed: _handlePayment,
                  loading: _isLoading,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void makePaymentBlocListener(context, state) {
    state.paymentStatus.when(
      success: (data) {
        _showSignTransactionBottomSheet(data);
      },
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }
}
