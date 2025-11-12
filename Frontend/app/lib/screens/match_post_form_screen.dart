import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_post.dart';
import '../theme/app_theme.dart';

/// Screen for creating a new match post
class MatchPostFormScreen extends StatefulWidget {
  const MatchPostFormScreen({super.key});

  @override
  State<MatchPostFormScreen> createState() => _MatchPostFormScreenState();
}

class _MatchPostFormScreenState extends State<MatchPostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _venueController = TextEditingController();
  final _totalPlayersController = TextEditingController(text: '11');
  final _totalOversController = TextEditingController(text: '20');

  BallType _selectedBallType = BallType.redBall;
  MatchType _selectedMatchType = MatchType.friendlyMatch;
  DateTime? _selectedDateTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    _venueController.dispose();
    _totalPlayersController.dispose();
    _totalOversController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Match'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Team Information'),
                  const SizedBox(height: 16),
                  _buildTeamNameField(),
                  const SizedBox(height: 16),
                  _buildTotalPlayersField(),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Match Details'),
                  const SizedBox(height: 16),
                  _buildVenueField(),
                  const SizedBox(height: 16),
                  _buildTotalOversField(),
                  const SizedBox(height: 16),
                  _buildBallTypeSelector(),
                  const SizedBox(height: 16),
                  _buildMatchTypeSelector(),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Match Timing'),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(),

                  const SizedBox(height: 48),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppTheme.accentBlue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTeamNameField() {
    return TextFormField(
      controller: _teamNameController,
      decoration: const InputDecoration(
        labelText: 'Team Name',
        hintText: 'Enter your team name',
        prefixIcon: Icon(Icons.group),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your team name';
        }
        if (value.trim().length < 3) {
          return 'Team name must be at least 3 characters';
        }
        if (value.trim().length > 50) {
          return 'Team name must not exceed 50 characters';
        }
        return null;
      },
    );
  }

  Widget _buildTotalPlayersField() {
    return TextFormField(
      controller: _totalPlayersController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Total Players',
        hintText: 'Number of players per team',
        prefixIcon: Icon(Icons.people),
        border: OutlineInputBorder(),
        helperText: 'Enter number between 2 and 11',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter total players';
        }
        final players = int.tryParse(value);
        if (players == null) {
          return 'Please enter a valid number';
        }
        if (players < 2 || players > 11) {
          return 'Players must be between 2 and 11';
        }
        return null;
      },
    );
  }

  Widget _buildVenueField() {
    return TextFormField(
      controller: _venueController,
      decoration: const InputDecoration(
        labelText: 'Venue',
        hintText: 'Enter match venue',
        prefixIcon: Icon(Icons.location_on),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter venue';
        }
        if (value.trim().length < 3) {
          return 'Venue must be at least 3 characters';
        }
        if (value.trim().length > 100) {
          return 'Venue must not exceed 100 characters';
        }
        return null;
      },
    );
  }

  Widget _buildTotalOversField() {
    return TextFormField(
      controller: _totalOversController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Total Overs',
        hintText: 'Number of overs',
        prefixIcon: Icon(Icons.sports_cricket),
        border: OutlineInputBorder(),
        helperText: 'Enter number between 1 and 50',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter total overs';
        }
        final overs = int.tryParse(value);
        if (overs == null) {
          return 'Please enter a valid number';
        }
        if (overs < 1 || overs > 50) {
          return 'Overs must be between 1 and 50';
        }
        return null;
      },
    );
  }

  Widget _buildBallTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ball Type',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: BallType.values.map((ballType) {
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ballType.emoji),
                      const SizedBox(width: 4),
                      Text(ballType.displayName),
                    ],
                  ),
                  selected: _selectedBallType == ballType,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedBallType = ballType;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Type',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: MatchType.values.map((matchType) {
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(matchType.emoji),
                      const SizedBox(width: 4),
                      Text(matchType.displayName),
                    ],
                  ),
                  selected: _selectedMatchType == matchType,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedMatchType = matchType;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Card(
      child: InkWell(
        onTap: _selectDateTime,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match Date & Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedDateTime != null
                          ? DateFormat(
                              'EEEE, MMM d, yyyy • h:mm a',
                            ).format(_selectedDateTime!)
                          : 'Tap to select date and time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _selectedDateTime != null
                            ? Theme.of(context).textTheme.bodyMedium?.color
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _submitMatchPost,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.post_add),
        label: Text(_isLoading ? 'Posting...' : 'Post Match'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primaryGreen,
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _selectedDateTime ?? DateTime(now.year, now.month, now.day, 17, 0),
      ),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submitMatchPost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select match date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match timing must be in the future'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Match posted successfully!'),
        backgroundColor: AppTheme.successGreen,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Navigate to match browser
          },
        ),
      ),
    );

    // Go back to home
    Navigator.of(context).pop();
  }
}
