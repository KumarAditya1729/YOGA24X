// ==============================================================================
// Yoga24X AI Engineering OS — Goal Management & Achievements Screen
// Displays Active Goals, Milestones Checklist, & Glowing Badges Showcase
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wellness_models.dart';
import '../../providers/goals_provider.dart';

class GoalManagementScreen extends ConsumerStatefulWidget {
  const GoalManagementScreen({super.key});

  @override
  ConsumerState<GoalManagementScreen> createState() => _GoalManagementScreenState();
}

class _GoalManagementScreenState extends ConsumerState<GoalManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _badges = [
    {'name': 'Spinal Warrior', 'desc': 'Completed 10 Spinal Decompression flows', 'icon': Icons.accessibility_new, 'unlocked': true, 'color': Colors.amber},
    {'name': '7-Day Zen Streak', 'desc': 'Meditated for 7 consecutive days', 'icon': Icons.self_improvement, 'unlocked': true, 'color': Colors.teal},
    {'name': 'Hydration Master', 'desc': 'Met 3000ml water goal for 14 days', 'icon': Icons.water_drop, 'unlocked': true, 'color': Colors.blue},
    {'name': 'Surya Namaskar 108', 'desc': 'Performed 108 Sun Salutations in one session', 'icon': Icons.wb_sunny, 'unlocked': false, 'color': Colors.orange},
    {'name': 'Chakra Awakened', 'desc': 'Completed all 7 Chakra Meditation journeys', 'icon': Icons.spa, 'unlocked': false, 'color': Colors.purple},
    {'name': 'Sattvic Yogi', 'desc': 'Maintained Sattvic nutrition streak for 30 days', 'icon': Icons.eco, 'unlocked': false, 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalsNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Achievements', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.flag_outlined), text: 'Active Goals'),
            Tab(icon: Icon(Icons.military_tech_outlined), text: 'Badges & Honors'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGoalsTab(state, theme),
          _buildBadgesTab(theme),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateGoalDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('New Goal'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }

  Widget _buildGoalsTab(GoalsState state, ThemeData theme) {
    if (state.status == GoalsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.goals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('No Active Goals Set', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Create personalized wellness milestones to track your yoga & health journey!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _showCreateGoalDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create First Goal'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.goals.length,
      itemBuilder: (context, index) {
        final goal = state.goals[index];
        final progressPct = (goal.progress / (goal.targetValue > 0 ? goal.targetValue : 1)).clamp(0.0, 1.0);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Chip(
                      label: Text(goal.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                if (goal.description != null) ...[
                  const SizedBox(height: 6),
                  Text(goal.description!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress: ${goal.progress.toInt()} / ${goal.targetValue.toInt()} ${goal.unit}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${(progressPct * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPct,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressPct >= 1.0 ? Colors.green : theme.colorScheme.primary),
                  ),
                ),
                if (goal.milestones != null && goal.milestones!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Milestones Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  ...goal.milestones!.map((m) {
                    final isDone = m['completed'] == true;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? Colors.green : Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(m['title'] as String, style: TextStyle(decoration: isDone ? TextDecoration.lineThrough : null, color: isDone ? Colors.grey : Colors.black87)),
                        ],
                      ),
                    );
                  }),
                ],
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => ref.read(goalsNotifierProvider.notifier).updateGoalProgress(goal.id, {'progress': (goal.progress + 10).clamp(0, goal.targetValue)}),
                      icon: const Icon(Icons.add_task),
                      label: const Text('+10 Progress'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () => ref.read(goalsNotifierProvider.notifier).deleteGoal(goal.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadgesTab(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        final badge = _badges[index];
        final isUnlocked = badge['unlocked'] == true;
        final color = badge['color'] as Color;

        return Card(
          elevation: isUnlocked ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isUnlocked ? BorderSide(color: color, width: 2) : BorderSide.none,
          ),
          color: isUnlocked ? Colors.white : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: isUnlocked ? color.withOpacity(0.2) : Colors.grey.shade300,
                      child: Icon(
                        badge['icon'] as IconData,
                        size: 38,
                        color: isUnlocked ? color : Colors.grey.shade500,
                      ),
                    ),
                    if (!isUnlocked)
                      Container(
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.lock, color: Colors.white, size: 20),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  badge['name'] as String,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isUnlocked ? Colors.black87 : Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  badge['desc'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController(text: '100');
    String category = 'YOGA';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Wellness Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Goal Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'YOGA', child: Text('Yoga Practice')),
                DropdownMenuItem(value: 'MEDITATION', child: Text('Meditation')),
                DropdownMenuItem(value: 'NUTRITION', child: Text('Nutrition & Water')),
                DropdownMenuItem(value: 'STRENGTH', child: Text('Physical Strength')),
              ],
              onChanged: (v) => category = v ?? 'YOGA',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Value (e.g. 100 min or days)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref.read(goalsNotifierProvider.notifier).createGoal({
                  'title': titleController.text,
                  'category': category,
                  'targetValue': double.tryParse(targetController.text) ?? 100.0,
                  'unit': category == 'YOGA' ? 'min' : 'days',
                  'milestones': [
                    {'title': 'Complete first 25%', 'completed': false},
                    {'title': 'Reach halfway mark (50%)', 'completed': false},
                    {'title': 'Final push (100%)', 'completed': false},
                  ],
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }
}
