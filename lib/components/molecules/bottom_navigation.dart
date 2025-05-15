import 'package:flutter/material.dart';
import 'package:tokenai/app/chat/blocs/chat/chat_bloc.dart';
import 'package:tokenai/app/chat/screens/chat/chat_template.dart';
import 'package:tokenai/constants/all.dart';
import 'package:get_it/get_it.dart';

class BottomNavigation extends StatefulWidget {
  final ValueSetter<int>? onTabTapped;
  final int currentIndex;
  final bool hasNotifications;

  const BottomNavigation({
    super.key,
    this.onTabTapped,
    this.hasNotifications = false,
    required this.currentIndex,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final TextEditingController _messageController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _openChatScreen(BuildContext context) {
    setState(() {
      _isExpanded = true;
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).kBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ChatTemplate(
                  GetIt.I.get<ChatBloc>(),
                  messageController: _messageController,
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      setState(() {
        _isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Colors.transparent),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).kBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color:
                      _currentIndex == 0
                          ? Theme.of(context).kTextColor
                          : Theme.of(context).kTextSecondaryColor,
                ),
                onPressed:
                    () => setState(() {
                      _currentIndex = 0;
                      widget.onTabTapped?.call(0);
                    }),
              ),
              IconButton(
                icon: Icon(
                  Icons.people,
                  color:
                      _currentIndex == 2
                          ? Theme.of(context).kTextColor
                          : Theme.of(context).kTextSecondaryColor,
                ),
                onPressed:
                    () => setState(() {
                      _currentIndex = 2;
                      widget.onTabTapped?.call(2);
                    }),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color:
                      _currentIndex == 3
                          ? Theme.of(context).kTextColor
                          : Theme.of(context).kTextSecondaryColor,
                ),
                onPressed:
                    () => setState(() {
                      _currentIndex = 3;
                      widget.onTabTapped?.call(3);
                    }),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _messageController,
                      onTap: () => _openChatScreen(context),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12,
                        ),
                        hintText: 'Ask AI...',
                        hintStyle: TextStyle(color: Theme.of(context).kTextColor),
                        fillColor: Theme.of(context).kBackgroundColorLight,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).kBackgroundColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).kTextColor,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
