import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification_entity.dart';
import '../viewmodels/notifications_viewmodel.dart';

class NotificationDetailScreen extends ConsumerStatefulWidget {
  final NotificationEntity notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  ConsumerState<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.notification.isRead) {
        ref
            .read(notificationsProvider.notifier)
            .markAsRead(widget.notification.id);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: Colors.black87,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                widget.notification.iconPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.notification.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      _formatFullDateTime(widget.notification.createdAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _MessageBubble(message: _buildFullMessage()),
                ],
              ),
            ),
          ),

          _buildInputBar(),
        ],
      ),
    );
  }

  String _buildFullMessage() {
    switch (widget.notification.type) {
      case NotificationType.orderValidated:
        return 'Votre commande a atteint l\'étape Validée: nous procèderons à l\'installation de votre fibre.';
      case NotificationType.materialPreparation:
        return 'Votre commande a atteint l\'étape Préparation: nous préparons le matériel nécessaire pour votre installation.';
      case NotificationType.technicianOnRoute:
        return 'Votre commande a atteint l\'étape Technicien en route: notre technicien est en chemin vers votre domicile.';
      case NotificationType.installationInProgress:
        return 'Votre commande a atteint l\'étape Installation: le technicien procède actuellement à l\'installation.';
      case NotificationType.testVerification:
        return 'Votre commande a atteint l\'étape Test et vérification: le technicien effectue les tests de connexion.';
      case NotificationType.installationComplete:
        return 'Votre commande a atteint l\'étape Terminée: votre installation est complète. Profitez de votre connexion !';
      case NotificationType.general:
        return widget.notification.message;
    }
  }

  String _formatFullDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday =
        dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (isToday) {
      return 'Aujourd\'hui $time';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} $time';
    }
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(Icons.add, size: 20, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Message texte - SMS',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Icon(Icons.mic_none, size: 24, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
