import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/chat/blocs/chat/chat_bloc.dart';
import 'package:tokenai/app/chat/domain/models/chat_message.dart';
import 'package:tokenai/app/contacts/screens/sign_transaction/sign_transaction_bottom_sheet.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/app/core/services/stellar_service.dart';
import 'package:tokenai/components/atoms/all.dart';
import 'package:tokenai/components/templates/base_layout.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/services/snackbar.dart';

class ChatTemplate extends StatefulWidget {
  final ChatBloc _chatBloc;
  final TextEditingController? messageController;

  const ChatTemplate(this._chatBloc, {super.key, this.messageController});

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> {
  final TextEditingController _messageController = TextEditingController();
  final _stellarService = StellarService(SecureStorageServiceImpl());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget._chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: _chatBlocListener,
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return BaseLayout(
              appBar: CupertinoNavigationBar(
                middle: Text(
                  'Chat',
                  style: TextStyle(color: Theme.of(context).kTextColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 24),
                  onPressed: () => _clearConversation(context),
                ),
                transitionBetweenRoutes: true,
                backgroundColor: Theme.of(context).kBackgroundColor,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return _buildMessageBubble(context, message, state);
                      },
                    ),
                  ),
                  _buildMessageInput(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _chatBlocListener(BuildContext context, ChatState state) {
    state.status.when(
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }

  void _clearConversation(BuildContext context) {
    context.read<ChatBloc>().add(const ClearConversation());
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message, ChatState state) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
            if (message.xdr != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8, top: 8),
                child: Button(
                  label: 'Sign transaction',
                  loading: message.loading ?? false,
                  onPressed: () {
                    _showSignTransactionBottomSheet(message, state);
                  },
                  type: ButtonType.TERTIARY,
                ),
              ),
            const SizedBox(height: 4),
            Text(message.time, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatState state) {
    final isLoading = state.status is Loading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask AI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).kBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(context),
                    ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(message));
    _messageController.clear();
  }

  void _showSignTransactionBottomSheet(ChatMessage message, ChatState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SignTransactionBottomSheet(
            xdr: message.xdr!,
            onSign: () => _handleSignTransaction(message, state),
          ),
    );
  }

  Future<void> _handleSignTransaction(ChatMessage message, ChatState state) async {
    try {
      Navigator.pop(context);
      setState(() => message.loading = true);

      // Sign and submit the transaction
      await _stellarService.signTransaction(message.xdr!);

      setState(() {
        message.loading = false;
        message.xdr = null;
      });

      // Add payment confirmation message
      widget._chatBloc.add(const PaymentConfirmed());
    } catch (e) {
      setState(() => message.loading = false);
      SnackBarService.of(context).error(e, 'Failed to sign transaction');
    }
  }
}
