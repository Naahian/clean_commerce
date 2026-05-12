import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEdit;
  final VoidCallback? onTap;
  final bool isDanger;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.isEdit = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isDanger ? colorScheme.errorContainer : colorScheme.primary;
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDanger ? colorScheme.errorContainer : colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onTap == null ? null : _buildIconButton(color),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Container _buildIconButton(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withAlpha(30), width: 1),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          isEdit ? Icons.edit_outlined : Icons.arrow_forward_rounded,
          size: 18,
          color: color,
        ),
        tooltip: isEdit ? 'Edit $label' : null,
        padding: EdgeInsets.all(6),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
