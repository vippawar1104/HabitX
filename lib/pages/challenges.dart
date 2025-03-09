import 'package:flutter/material.dart';

class Challenge {
  final String title;
  final String description;
  final String duration;
  final int participants;
  final double progress;
  final bool isFeatured;
  bool isJoined;

  Challenge({
    required this.title,
    required this.description,
    required this.duration,
    required this.participants,
    required this.progress,
    this.isFeatured = false,
    this.isJoined = false,
  });
}

class UserBadge {
  final String rank;
  final Color color;
  final IconData icon;

  const UserBadge({
    required this.rank,
    required this.color,
    required this.icon,
  });
}

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final String userName = "Vipul Pawar";
  int completedChallenges = 2;  // This will track the number of completed challenges

  final List<Challenge> _challenges = [
    Challenge(
      title: '30 Days of Meditation',
      description: 'Meditate for at least 10 minutes every day',
      duration: '30 days',
      participants: 1458,
      progress: 0.0,
      isJoined: true,
    ),
    Challenge(
      title: 'Early Bird',
      description: 'Wake up before 6 AM for 21 days',
      duration: '21 days',
      participants: 892,
      progress: 0.0,
    ),
    Challenge(
      title: 'Digital Detox',
      description: 'Limit social media use to 30 minutes per day',
      duration: '14 days',
      participants: 2341,
      progress: 0.0,
    ),
    Challenge(
      title: '100 Days of Consistency',
      description: 'Complete your chosen habit every day for 100 days',
      duration: '100 days',
      participants: 5234,
      progress: 0.0,
      isFeatured: true,
    ),
  ];

  UserBadge getBadge() {
    if (completedChallenges >= 10) {
      return const UserBadge(
        rank: "Legendary",
        color: Colors.purple,
        icon: Icons.military_tech,
      );
    } else if (completedChallenges >= 5) {
      return const UserBadge(
        rank: "Knight",
        color: Colors.blue,
        icon: Icons.shield,
      );
    } else if (completedChallenges >= 2) {
      return const UserBadge(
        rank: "Newbie",
        color: Colors.green,
        icon: Icons.hiking,
      );
    } else {
      return const UserBadge(
        rank: "Novice",
        color: Colors.orange,
        icon: Icons.emoji_events_outlined,
      );
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void _showCreateChallengeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a New Challenge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                String duration = durationController.text;
                if (title.isNotEmpty && description.isNotEmpty && duration.isNotEmpty) {
                  setState(() {
                    _challenges.add(Challenge(
                      title: title,
                      description: description,
                      duration: duration,
                      participants: 0,
                      progress: 0.0,
                    ));
                  });
                  titleController.clear();
                  descriptionController.clear();
                  durationController.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New challenge created!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields!')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildUserBadge(context),
          _buildFeaturedChallenge(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _challenges.length,
              itemBuilder: (context, index) =>
                  _buildChallengeCard(_challenges[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChallengeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserBadge(BuildContext context) {
    final badge = getBadge();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [badge.color, badge.color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: badge.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            radius: 30,
            child: Icon(badge.icon, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge.rank,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completedChallenges challenges completed',
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallenge(BuildContext context) {
    final featuredChallenge =
        _challenges.firstWhere((challenge) => challenge.isFeatured);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 32,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Featured',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            featuredChallenge.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            featuredChallenge.description,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${featuredChallenge.participants} participants',
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: featuredChallenge.isJoined
                    ? null
                    : () {
                        setState(() {
                          featuredChallenge.isJoined = true;
                          completedChallenges++;  // Increment the completed challenges counter
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You joined the Featured Challenge!'),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  featuredChallenge.isJoined ? 'Joined' : 'Join Challenge',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    challenge.duration,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${challenge.participants} participants',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (challenge.isJoined)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(challenge.progress * 100).toInt()}% Complete',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    challenge.isJoined = true;
                    completedChallenges++;  // Increment the completed challenges counter
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You joined the "${challenge.title}" challenge!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Join Challenge'),
              ),
          ],
        ),
      ),
    );
  }
}