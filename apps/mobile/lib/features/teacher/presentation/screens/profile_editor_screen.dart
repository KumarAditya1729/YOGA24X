import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/teacher_providers.dart';

class ProfileEditorScreen extends ConsumerStatefulWidget {
  const ProfileEditorScreen({super.key});

  @override
  ConsumerState<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends ConsumerState<ProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _headlineController;
  late TextEditingController _bioController;
  late TextEditingController _experienceController;
  late TextEditingController _languagesController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(teacherProfileControllerProvider).valueOrNull;
    
    _headlineController = TextEditingController(text: profile?.headline ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _experienceController = TextEditingController(text: profile?.yearsExperience.toString() ?? '0');
    _languagesController = TextEditingController(text: profile?.teachingLanguages.join(', ') ?? '');
    _countryController = TextEditingController(text: profile?.countryCode ?? '');
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _languagesController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'headline': _headlineController.text,
        'bio': _bioController.text,
        'yearsExperience': int.tryParse(_experienceController.text) ?? 0,
        'teachingLanguages': _languagesController.text.split(',').map((e) => e.trim()).toList(),
        'countryCode': _countryController.text,
      };

      final isCreate = ref.read(teacherProfileControllerProvider).valueOrNull == null;
      
      if (isCreate) {
        await ref.read(teacherProfileControllerProvider.notifier).createProfile(data);
      } else {
        await ref.read(teacherProfileControllerProvider.notifier).updateProfile(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _headlineController,
                decoration: const InputDecoration(
                  labelText: 'Professional Headline',
                  hintText: 'e.g. RYT 500 Vinyasa Specialist',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell students about yourself...',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country Code (e.g. US, IN)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _languagesController,
                decoration: const InputDecoration(
                  labelText: 'Languages (comma separated)',
                  hintText: 'English, Hindi, Spanish',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
