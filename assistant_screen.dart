import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // رسالة ترحيب
    _messages.add(ChatMessage(
      text:
          'مرحباً بك في المساعد القانوني لتطبيق دليل.\nيمكنك سؤالي عن أي موضوع قانوني في السعودية، الإمارات، الكويت، مصر، أو الأردن.\n\nملاحظة: إجاباتي استرشادية وليست استشارة قانونية رسمية.',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: DateTime.now(),
      ));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // محاكاة رد الذكاء الاصطناعي (لاحقاً يتم ربطه بنموذج حقيقي)
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    final reply = _generateDemoReply(text);

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(
          text: reply,
          isUser: false,
          time: DateTime.now(),
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  String _generateDemoReply(String question) {
    final q = question.toLowerCase();
    if (q.contains('عقد عمل') || q.contains('فصل') || q.contains('استقالة')) {
      return 'بخصوص عقود العمل:\n\nفي معظم الدول المستهدفة، ينتهي عقد العمل باتفاق الطرفين أو بانتهاء المدة أو لأسباب مشروعة ينص عليها النظام.\n\nأنصحك بالرجوع إلى نظام العمل في الدولة المختارة أو استشارة محامٍ مختص للحصول على إجابة دقيقة حسب حالتك.';
    }
    if (q.contains('إيجار') || q.contains('مستأجر')) {
      return 'عقود الإيجار تخضع عادة لقانون الإيجارات أو القانون المدني في كل دولة.\n\nيُفضل تحديد مدة الإيجار وقيمة الأجرة وطريقة السداد بوضوح في العقد.\n\nهذه إجابة عامة، يُرجى مراجعة النظام المحلي أو محامٍ.';
    }
    return 'شكراً لسؤالك.\n\nحالياً أعمل بنسخة تجريبية. في الإصدار الكامل سأتمكن من البحث في القوانين المحدثة وتقديم إجابات أدق مع ذكر المصادر.\n\nتنويه هام: هذه المعلومات استرشادية وليست بديلاً عن استشارة محامٍ مرخص.';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد القانوني'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingIndicator();
                }
                final msg = _messages[index];
                return _MessageBubble(message: msg);
              },
            ),
          ),
          // حقل الإدخال
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك القانوني...',
                        filled: true,
                        fillColor: AppTheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppTheme.textPrimary,
            height: 1.5,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('يكتب...'),
          ],
        ),
      ),
    );
  }
}
