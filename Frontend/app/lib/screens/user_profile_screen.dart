import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _favoriteTeamController;
  late TextEditingController _bioController;
  late TextEditingController _matchesController;
  late TextEditingController _runsController;
  late TextEditingController _wicketsController;
  late TextEditingController _battingAvgController;
  late TextEditingController _bowlingAvgController;
  late TextEditingController _centuriesController;
  late TextEditingController _halfCenturiesController;
  late TextEditingController _fiveWicketsController;
  late TextEditingController _highestScoreController;
  late TextEditingController _bestBowlingController;

  String _selectedRole = 'Fan';
  String _selectedBattingStyle = 'Right-hand';
  String _selectedBowlingStyle = 'Right-arm medium';
  DateTime? _dateOfBirth;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProfileProvider>();
    final profile = provider.userProfile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _countryController = TextEditingController(text: profile?.country ?? '');
    _favoriteTeamController = TextEditingController(
      text: profile?.favoriteTeam ?? '',
    );
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _matchesController = TextEditingController(
      text: profile?.matchesPlayed.toString() ?? '0',
    );
    _runsController = TextEditingController(
      text: profile?.totalRuns.toString() ?? '0',
    );
    _wicketsController = TextEditingController(
      text: profile?.totalWickets.toString() ?? '0',
    );
    _battingAvgController = TextEditingController(
      text: profile?.battingAverage.toString() ?? '0.0',
    );
    _bowlingAvgController = TextEditingController(
      text: profile?.bowlingAverage.toString() ?? '0.0',
    );
    _centuriesController = TextEditingController(
      text: profile?.centuries.toString() ?? '0',
    );
    _halfCenturiesController = TextEditingController(
      text: profile?.halfCenturies.toString() ?? '0',
    );
    _fiveWicketsController = TextEditingController(
      text: profile?.fiveWicketHauls.toString() ?? '0',
    );
    _highestScoreController = TextEditingController(
      text: profile?.highestScore.toString() ?? '0',
    );
    _bestBowlingController = TextEditingController(
      text: profile?.bestBowling ?? '',
    );

    if (profile != null) {
      _selectedRole = profile.role ?? 'Fan';
      _selectedBattingStyle = profile.battingStyle ?? 'Right-hand';
      _selectedBowlingStyle = profile.bowlingStyle ?? 'Right-arm medium';
      _dateOfBirth = profile.dateOfBirth;
    }

    _isEditing = profile == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _matchesController.dispose();
    _runsController.dispose();
    _wicketsController.dispose();
    _battingAvgController.dispose();
    _bowlingAvgController.dispose();
    _centuriesController.dispose();
    _halfCenturiesController.dispose();
    _fiveWicketsController.dispose();
    _highestScoreController.dispose();
    _bestBowlingController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _favoriteTeamController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, child) {
          if (!provider.hasProfile && !_isEditing) {
            return _buildEmptyState();
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProfileHeader(provider),
                const SizedBox(height: 24),
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                _buildContactSection(),
                const SizedBox(height: 24),
                _buildLocationSection(),
                const SizedBox(height: 24),
                _buildPlayingStyleSection(),
                const SizedBox(height: 24),
                _buildStatisticsSection(),
                const SizedBox(height: 24),
                _buildCricketInfoSection(),
                const SizedBox(height: 24),
                _buildBioSection(),
                if (_isEditing) ...[
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  if (provider.hasProfile) ...[
                    const SizedBox(height: 12),
                    _buildCancelButton(),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 100,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white38
                : Colors.black26,
          ),
          const SizedBox(height: 24),
          Text(
            'Create Your Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in your details to personalize your experience',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Profile'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfileProvider provider) {
    final profile = provider.userProfile;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.successGreen,
              child: Text(
                profile?.initials ??
                    (_nameController.text.isNotEmpty
                        ? _nameController.text.substring(0, 1).toUpperCase()
                        : '?'),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile?.name ?? 'Your Name',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (profile?.role != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(profile!.role!),
                backgroundColor: AppTheme.infoBlue.withValues(alpha: 0.2),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppTheme.infoBlue),
                const SizedBox(width: 12),
                Text(
                  'Personal Information',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.badge),
              ),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(
                _dateOfBirth == null
                    ? 'Date of Birth'
                    : 'DOB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              ),
              subtitle: _dateOfBirth != null
                  ? Text('Age: ${_calculateAge(_dateOfBirth!)} years')
                  : null,
              trailing: _isEditing ? const Icon(Icons.calendar_today) : null,
              onTap: _isEditing ? _selectDate : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.sports_cricket),
              ),
              items: ['Player', 'Coach', 'Umpire', 'Scorer', 'Fan']
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.contact_phone, color: AppTheme.successGreen),
                const SizedBox(width: 12),
                Text(
                  'Contact Information',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.warningOrange),
                const SizedBox(width: 12),
                Text(
                  'Location',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home),
              ),
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      prefixIcon: Icon(Icons.flag),
                    ),
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayingStyleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports, color: AppTheme.infoBlue),
                const SizedBox(width: 12),
                Text(
                  'Playing Style',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBattingStyle,
              decoration: const InputDecoration(
                labelText: 'Batting Style',
                prefixIcon: Icon(Icons.sports_cricket),
              ),
              items: ['Right-hand', 'Left-hand']
                  .map(
                    (style) =>
                        DropdownMenuItem(value: style, child: Text(style)),
                  )
                  .toList(),
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _selectedBattingStyle = value!;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBowlingStyle,
              decoration: const InputDecoration(
                labelText: 'Bowling Style',
                prefixIcon: Icon(Icons.sports),
              ),
              items:
                  [
                        'Right-arm fast',
                        'Right-arm medium fast',
                        'Right-arm medium',
                        'Right-arm spin',
                        'Left-arm fast',
                        'Left-arm medium fast',
                        'Left-arm medium',
                        'Left-arm spin',
                      ]
                      .map(
                        (style) =>
                            DropdownMenuItem(value: style, child: Text(style)),
                      )
                      .toList(),
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _selectedBowlingStyle = value!;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: AppTheme.successGreen),
                const SizedBox(width: 12),
                Text(
                  'Career Statistics',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _matchesController,
                    decoration: const InputDecoration(
                      labelText: 'Matches',
                      prefixIcon: Icon(Icons.sports_cricket),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _runsController,
                    decoration: const InputDecoration(
                      labelText: 'Total Runs',
                      prefixIcon: Icon(Icons.trending_up),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _wicketsController,
                    decoration: const InputDecoration(
                      labelText: 'Wickets',
                      prefixIcon: Icon(Icons.close),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _battingAvgController,
                    decoration: const InputDecoration(
                      labelText: 'Bat Avg',
                      prefixIcon: Icon(Icons.analytics),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _centuriesController,
                    decoration: const InputDecoration(
                      labelText: '100s',
                      prefixIcon: Icon(Icons.star),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _halfCenturiesController,
                    decoration: const InputDecoration(
                      labelText: '50s',
                      prefixIcon: Icon(Icons.star_half),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _highestScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Highest Score',
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _fiveWicketsController,
                    decoration: const InputDecoration(
                      labelText: '5 Wickets',
                      prefixIcon: Icon(Icons.military_tech),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bestBowlingController,
              decoration: const InputDecoration(
                labelText: 'Best Bowling (e.g., 5/23)',
                prefixIcon: Icon(Icons.sports),
              ),
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCricketInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_cricket, color: AppTheme.successGreen),
                const SizedBox(width: 12),
                Text(
                  'Cricket Preferences',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _favoriteTeamController,
              decoration: const InputDecoration(
                labelText: 'Favorite Team',
                prefixIcon: Icon(Icons.emoji_events),
              ),
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: AppTheme.infoBlue),
                const SizedBox(width: 12),
                Text(
                  'About Me',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself...',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _saveProfile,
      icon: const Icon(Icons.save),
      label: const Text('Save Profile'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _isEditing = false;
          // Reset controllers to original values
          final provider = context.read<UserProfileProvider>();
          final profile = provider.userProfile;
          if (profile != null) {
            _nameController.text = profile.name;
            _emailController.text = profile.email ?? '';
            _phoneController.text = profile.phone ?? '';
            _addressController.text = profile.address ?? '';
            _cityController.text = profile.city ?? '';
            _countryController.text = profile.country ?? '';
            _favoriteTeamController.text = profile.favoriteTeam ?? '';
            _bioController.text = profile.bio ?? '';
            _matchesController.text = profile.matchesPlayed.toString();
            _runsController.text = profile.totalRuns.toString();
            _wicketsController.text = profile.totalWickets.toString();
            _battingAvgController.text = profile.battingAverage.toString();
            _bowlingAvgController.text = profile.bowlingAverage.toString();
            _centuriesController.text = profile.centuries.toString();
            _halfCenturiesController.text = profile.halfCenturies.toString();
            _fiveWicketsController.text = profile.fiveWicketHauls.toString();
            _highestScoreController.text = profile.highestScore.toString();
            _bestBowlingController.text = profile.bestBowling ?? '';
            _selectedRole = profile.role ?? 'Fan';
            _selectedBattingStyle = profile.battingStyle ?? 'Right-hand';
            _selectedBowlingStyle = profile.bowlingStyle ?? 'Right-arm medium';
            _dateOfBirth = profile.dateOfBirth;
          }
        });
      },
      icon: const Icon(Icons.cancel),
      label: const Text('Cancel'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<UserProfileProvider>();
      final profile = UserProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        dateOfBirth: _dateOfBirth,
        favoriteTeam: _favoriteTeamController.text.trim().isEmpty
            ? null
            : _favoriteTeamController.text.trim(),
        role: _selectedRole,
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        battingStyle: _selectedBattingStyle,
        bowlingStyle: _selectedBowlingStyle,
        matchesPlayed: int.tryParse(_matchesController.text) ?? 0,
        totalRuns: int.tryParse(_runsController.text) ?? 0,
        totalWickets: int.tryParse(_wicketsController.text) ?? 0,
        battingAverage: double.tryParse(_battingAvgController.text) ?? 0.0,
        bowlingAverage: double.tryParse(_bowlingAvgController.text) ?? 0.0,
        centuries: int.tryParse(_centuriesController.text) ?? 0,
        halfCenturies: int.tryParse(_halfCenturiesController.text) ?? 0,
        fiveWicketHauls: int.tryParse(_fiveWicketsController.text) ?? 0,
        highestScore: int.tryParse(_highestScoreController.text) ?? 0,
        bestBowling: _bestBowlingController.text.trim().isEmpty
            ? null
            : _bestBowlingController.text.trim(),
      );

      if (provider.hasProfile) {
        provider.updateProfile(profile);
      } else {
        provider.createProfile(profile);
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }
}
