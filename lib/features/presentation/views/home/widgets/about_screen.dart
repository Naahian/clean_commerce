// screens/about_screen.dart
import 'package:clean_commerce/features/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Logo(),
            const SizedBox(height: 24),
            const _AppInfoSection(),
            const SizedBox(height: 32),
            const _TagsSection(),
            const SizedBox(height: 32),
            const SizedBox(height: 24),
            const _VersionInfo(),
          ],
        ),
      ),
    );
  }
}

// App Information Section
class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Clean Commerce',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Purpose',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A regular e-commerce app built specifically to demonstrate '
                'and practice Clean Architecture principles in Flutter development.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Main Feature',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Clean & Organized Source Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Every line of code follows strict separation of concerns, '
                'making this app a reference implementation for Clean Architecture.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Tags Section
class _TagsSection extends StatelessWidget {
  const _TagsSection();

  @override
  Widget build(BuildContext context) {
    final List<Tag> tags = [
      Tag(
        label: 'Clean Architecture',
        icon: Icons.architecture,
        color: Colors.teal,
      ),
      Tag(label: 'SOLID', icon: Icons.square_foot, color: Colors.blue),
      Tag(label: 'Supabase', icon: Icons.cloud_queue, color: Colors.green),
      Tag(label: 'Hive', icon: Icons.storage, color: Colors.orange),
      Tag(label: 'Riverpod', icon: Icons.auto_awesome, color: Colors.purple),
      Tag(
        label: 'GetIt',
        icon: Icons.integration_instructions,
        color: Colors.indigo,
      ),
    ];

    return Column(
      children: [
        const Text(
          'Tech Stack & Principles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: tags.map((tag) => _TagChip(tag: tag)).toList(),
        ),
      ],
    );
  }
}

class Tag {
  final String label;
  final IconData icon;
  final Color color;

  Tag({required this.label, required this.icon, required this.color});
}

class _TagChip extends StatelessWidget {
  final Tag tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tag.color.withOpacity(0.1), tag.color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: tag.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tag.icon, size: 18, color: tag.color),
          const SizedBox(width: 8),
          Text(
            tag.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: tag.color,
            ),
          ),
        ],
      ),
    );
  }
}

// Version Info
class _VersionInfo extends StatelessWidget {
  const _VersionInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Version 1.0.0',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2026 Clean Commerce',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}
