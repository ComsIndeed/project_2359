/// Predefined mock data for Project 2359 test mode
///
/// This file contains all the mock data used in test mode.
/// Data is cloned to in-memory storage at startup and can be modified,
/// but resets to these values on app restart.
library;

import '../../../models/models.dart';

/// Predefined sources for test mode
final List<Source> mockSources = [
  Source(
    id: 'src_001',
    title: 'Intro to Macroeconomics',
    type: SourceType.pdf,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    lastAccessedAt: DateTime.now().subtract(const Duration(hours: 2)),
    filePath: 'assets/mock/macroeconomics.pdf',
    sizeBytes: 3355443, // ~3.2MB
    thumbnailPath: 'assets/images/source_macroeconomics.png',
    tags: ['economics', 'college'],
    isIndexed: true,
  ),
  Source(
    id: 'src_002',
    title: 'Organic Chemistry Notes',
    type: SourceType.note,
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    lastAccessedAt: DateTime.now().subtract(const Duration(hours: 5)),
    content: '''
# Organic Chemistry - Chapter 4

## Functional Groups
- Alcohols (-OH)
- Aldehydes (-CHO)
- Ketones (C=O)
- Carboxylic acids (-COOH)

## Key Reactions
1. Oxidation of alcohols
2. Reduction of carbonyls
3. Esterification
''',
    thumbnailPath: 'assets/images/source_chemistry.png',
    tags: ['chemistry', 'notes'],
    isIndexed: true,
  ),
  Source(
    id: 'src_003',
    title: 'Advanced Calculus',
    type: SourceType.pdf,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
    filePath: 'assets/mock/calculus.pdf',
    sizeBytes: 4718592, // ~4.5MB
    tags: ['mathematics', 'calculus'],
    isIndexed: true,
  ),
  Source(
    id: 'src_004',
    title: 'History of Modern Art',
    type: SourceType.link,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    lastAccessedAt: DateTime.now().subtract(const Duration(days: 2)),
    url: 'https://art-history.org/modern-art',
    tags: ['art', 'history'],
    isIndexed: false,
  ),
  Source(
    id: 'src_005',
    title: 'Lecture 4: Cognitive Psychology',
    type: SourceType.note,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
    content: '''
# Cognitive Psychology - Lecture 4

## Memory Systems
- Sensory memory
- Short-term / Working memory
- Long-term memory

## Encoding Strategies
- Elaborative rehearsal
- Chunking
- Mnemonics
''',
    tags: ['psychology', 'lecture'],
    isIndexed: true,
  ),
  Source(
    id: 'src_006',
    title: 'Biology Chapter 5: Cell Division',
    type: SourceType.pdf,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    lastAccessedAt: DateTime.now().subtract(const Duration(hours: 12)),
    filePath: 'assets/mock/biology.pdf',
    sizeBytes: 2097152, // ~2MB
    thumbnailPath: 'assets/images/hero_biology.png',
    tags: ['biology', 'cells'],
    isIndexed: true,
  ),
];

/// Predefined flashcards for test mode
final List<Flashcard> mockFlashcards = [
  Flashcard(
    id: 'fc_001',
    sourceId: 'src_001',
    front: 'What is GDP?',
    back:
        'Gross Domestic Product - the total monetary value of all goods and services produced within a country in a specific time period.',
    tags: ['economics', 'definitions'],
    difficulty: 2,
    reviewCount: 5,
    lastReviewedAt: DateTime.now().subtract(const Duration(hours: 12)),
    nextReviewAt: DateTime.now().add(const Duration(days: 2)),
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  Flashcard(
    id: 'fc_002',
    sourceId: 'src_001',
    front: 'What is inflation?',
    back:
        'A general increase in prices and fall in the purchasing value of money over time.',
    tags: ['economics', 'definitions'],
    difficulty: 2,
    reviewCount: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Flashcard(
    id: 'fc_003',
    sourceId: 'src_002',
    front: 'What functional group defines an alcohol?',
    back: 'Hydroxyl group (-OH) attached to a carbon atom.',
    tags: ['chemistry', 'functional-groups'],
    difficulty: 1,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Flashcard(
    id: 'fc_004',
    sourceId: 'src_003',
    front: 'What is the derivative of sin(x)?',
    back: 'cos(x)',
    tags: ['calculus', 'derivatives'],
    difficulty: 1,
    reviewCount: 8,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Flashcard(
    id: 'fc_005',
    sourceId: 'src_005',
    front: 'Name the three memory systems in cognitive psychology.',
    back:
        '1. Sensory memory\n2. Short-term / Working memory\n3. Long-term memory',
    tags: ['psychology', 'memory'],
    difficulty: 2,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

/// Predefined quiz questions for test mode
final List<QuizQuestion> mockQuizQuestions = [
  QuizQuestion(
    id: 'qz_001',
    sourceId: 'src_001',
    question: 'Which of the following is NOT a component of GDP?',
    options: [
      'Consumer spending',
      'Government spending',
      'Stock market gains',
      'Net exports',
    ],
    correctOptionIndex: 2,
    explanation: 'GDP measures production, not financial market gains.',
    difficulty: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    updatedAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  QuizQuestion(
    id: 'qz_002',
    sourceId: 'src_002',
    question: 'What is the product of alcohol oxidation?',
    options: ['Alkene', 'Aldehyde or Ketone', 'Carboxylic acid', 'Ether'],
    correctOptionIndex: 1,
    explanation:
        'Primary alcohols oxidize to aldehydes, secondary alcohols to ketones.',
    difficulty: 3,
    tags: ['chemistry'],
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    updatedAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  QuizQuestion(
    id: 'qz_003',
    sourceId: 'src_006',
    question:
        'During which phase of mitosis do chromosomes align at the cell equator?',
    options: ['Prophase', 'Metaphase', 'Anaphase', 'Telophase'],
    correctOptionIndex: 1,
    explanation:
        'Metaphase is characterized by chromosomes lining up at the metaphase plate.',
    difficulty: 2,
    tags: ['biology', 'mitosis'],
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    updatedAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
];

/// Predefined free-form questions for test mode
final List<FreeFormQuestion> mockFreeFormQuestions = [
  FreeFormQuestion(
    id: 'ff_001',
    sourceId: 'src_001',
    question: 'Explain how monetary policy affects economic growth.',
    modelAnswer:
        'Monetary policy affects economic growth through interest rate changes. Lower rates encourage borrowing and spending, stimulating growth. Higher rates reduce borrowing, slowing growth and controlling inflation.',
    hints: ['Think about interest rates', 'Consider borrowing behavior'],
    keywords: ['interest rates', 'borrowing', 'spending', 'inflation'],
    difficulty: 4,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  FreeFormQuestion(
    id: 'ff_002',
    sourceId: 'src_005',
    question:
        'Describe the process of memory encoding and explain two strategies to improve it.',
    modelAnswer:
        'Memory encoding transforms sensory information into mental representations. Effective strategies include: 1) Elaborative rehearsal - connecting new info to existing knowledge, 2) Chunking - grouping items into meaningful units.',
    hints: [
      'How does information enter memory?',
      'What makes some things easier to remember?',
    ],
    keywords: [
      'encoding',
      'elaborative rehearsal',
      'chunking',
      'mental representations',
    ],
    difficulty: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

/// Predefined matching sets for test mode
final List<MatchingSet> mockMatchingSets = [
  MatchingSet(
    id: 'ms_001',
    sourceId: 'src_002',
    title: 'Functional Groups',
    instructions: 'Match each functional group to its chemical formula.',
    pairs: [
      const MatchingPair(id: 'mp_001', left: 'Alcohol', right: '-OH'),
      const MatchingPair(id: 'mp_002', left: 'Aldehyde', right: '-CHO'),
      const MatchingPair(id: 'mp_003', left: 'Ketone', right: 'C=O'),
      const MatchingPair(id: 'mp_004', left: 'Carboxylic acid', right: '-COOH'),
    ],
    tags: ['chemistry'],
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    updatedAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  MatchingSet(
    id: 'ms_002',
    sourceId: 'src_006',
    title: 'Mitosis Phases',
    instructions: 'Match each phase to its key event.',
    pairs: [
      const MatchingPair(
        id: 'mp_005',
        left: 'Prophase',
        right: 'Chromatin condenses',
      ),
      const MatchingPair(
        id: 'mp_006',
        left: 'Metaphase',
        right: 'Chromosomes align',
      ),
      const MatchingPair(
        id: 'mp_007',
        left: 'Anaphase',
        right: 'Sister chromatids separate',
      ),
      const MatchingPair(
        id: 'mp_008',
        left: 'Telophase',
        right: 'Nuclear envelope reforms',
      ),
    ],
    tags: ['biology', 'mitosis'],
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

/// Predefined image occlusions for test mode (empty for now - requires actual images)
final List<ImageOcclusion> mockImageOcclusions = [];

/// Default user for test mode
final User mockUser = User(
  id: 'user_001',
  name: 'Jane Doe',
  email: 'jane.doe@example.com',
  avatarUrl: 'https://i.pravatar.cc/150?u=jane_doe',
  institution: 'State University',
  major: 'Computer Science',
  yearLevel: 'Sophomore',
  totalStudyMinutes: 260,
  totalCardsReviewed: 145,
  totalQuizzesTaken: 12,
  averageScore: 0.88,
  credits: 1250,
  createdAt: DateTime.now().subtract(const Duration(days: 90)),
  lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
);
