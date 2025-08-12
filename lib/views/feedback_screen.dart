import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humanidades360/l10n/app_localizations.dart'; // Asegúrate de importar tus localizaciones

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showFrequentQuestions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const FrequentQuestionsBottomSheet(),
    );
  }

  void _submitFeedback() {
    final localizations = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica para enviar el feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.fs_feedbackThankYou)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cs_feedback),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: localizations.fs_feedbackName,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.fs_feedbackNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localizations.fs_feedbackEmail,
                  prefixIcon: const Icon(Icons.email)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.fs_feedbackEmailRequired;
                  }
                  if (!value.contains('@')) {
                    return localizations.fs_feedbackEmailInvalid;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: localizations.fs_feedbackMessage,
                  alignLabelWithHint: true),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.fs_feedbackMessageRequired;
                  }
                  if (value.length < 10) {
                    return localizations.fs_feedbackMessageTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text(localizations.fs_feedbackSubmit),
              ),
              TextButton(
                onPressed: _showFrequentQuestions,
                child: Text(localizations.fs_feedbackFrequentQuestions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FrequentQuestionsBottomSheet extends StatelessWidget {
  const FrequentQuestionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.fs_feedbackFrequentQuestions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Aquí puedes añadir tus preguntas frecuentes
          ExpansionTile(
            title: Text(localizations.fs_faqQuestion1),
            children: [Text(localizations.fs_faqAnswer1)],
          ),
          ExpansionTile(
            title: Text(localizations.fs_faqQuestion2),
            children: [Text(localizations.fs_faqAnswer2)],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.fs_close),
          ),
        ],
      ),
    );
  }
}