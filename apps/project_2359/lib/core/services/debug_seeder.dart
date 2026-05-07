import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:project_2359/core/tables/source_item_blobs.dart';
import 'package:project_2359/core/services/biology_citation_seeder.dart';

class DebugSeeder {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/ComsIndeed/project_2359/main/seeds/';
  static const List<String> _seedFiles = [
    'map-stuff.pdf',
    'presentation.pdf',
    'text-stuff.pdf',
  ];

  static Future<void> seed(AppDatabase db) async {
    final uuid = const Uuid();

    // 0. Seed the new Biology Citation Demo (180 cards + 7 PDFs)
    await BiologyCitationSeeder.seed(db);

    // 1. Create a Demo Collection
    final collectionId = uuid.v4();
    await db
        .into(db.studyCollectionItems)
        .insert(
          StudyCollectionItemsCompanion(
            id: Value(collectionId),
            name: const Value('Biology & Medicine (DEMO)'),
            isPinned: const Value(true),
            createdAt: Value(DateTime.now().toIso8601String()),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );

    // 2. Download and Create Sources
    final List<String> sourceIds = [];
    for (final fileName in _seedFiles) {
      try {
        final response = await http.get(Uri.parse('$_baseUrl$fileName'));
        if (response.statusCode == 200) {
          final sourceId = uuid.v4();
          final blobId = uuid.v4();
          sourceIds.add(sourceId);

          await db
              .into(db.sourceItemBlobs)
              .insert(
                SourceItemBlobsCompanion(
                  id: Value(blobId),
                  sourceItemId: Value(sourceId),
                  sourceItemName: Value(fileName),
                  type: const Value(SourceFileType.pdf),
                  bytes: Value(response.bodyBytes),
                ),
              );

          await db
              .into(db.sourceItems)
              .insert(
                SourceItemsCompanion(
                  id: Value(sourceId),
                  collectionId: Value(collectionId),
                  label: Value(fileName),
                  type: const Value(MediaType.document),
                ),
              );
        }
      } catch (e) {
        AppLogger.error('Error seeding $fileName: $e', tag: 'DebugSeeder');
      }
    }

    // 3. Create 4 Decks
    final deck1Id = uuid.v4(); // Cell Bio
    final deck2Id = uuid.v4(); // Micro
    final deck3Id = uuid.v4(); // Biochem
    final deck4Id = uuid.v4(); // Comprehensive Review

    await db.batch((batch) {
      batch.insertAll(db.deckItems, [
        DeckItemsCompanion(
          id: Value(deck1Id),
          collectionId: Value(collectionId),
          name: const Value('Cell Bio & Pathology'),
          description: const Value(
            'Cellular mechanisms and basic pathology hallmarks.',
          ),
        ),
        DeckItemsCompanion(
          id: Value(deck2Id),
          collectionId: Value(collectionId),
          name: const Value('High-Yield Micro'),
          description: const Value(
            'Key pathogens, virulence factors, and clinical markers.',
          ),
        ),
        DeckItemsCompanion(
          id: Value(deck3Id),
          collectionId: Value(collectionId),
          name: const Value('Master Biochemistry'),
          description: const Value(
            'Metabolic pathways, enzymes, and clinical correlations.',
          ),
        ),
        DeckItemsCompanion(
          id: Value(deck4Id),
          collectionId: Value(collectionId),
          name: const Value('Comprehensive Rapid Review'),
          description: const Value(
            'Mixed high-yield facts from Anatomy, Pharm, and Physio.',
          ),
        ),
      ]);
    });

    // 4. Create 40 Cards
    final List<CardItemsCompanion> cards = [];

    // --- Deck 1: Cell Bio & Pathology (6 New) ---
    final cellBioData = [
      ['**Nucleolus** - main function?', 'rRNA synthesis / Ribosome assembly'],
      [
        '**Smooth ER** - key metabolic role?',
        'Steroid synthesis / Detoxification',
      ],
      [
        '**I-cell disease** - deficient enzyme?',
        'N-acetylglucosaminyl-1-phosphotransferase',
      ],
      [
        '**Cardinal signs** of inflammation (5)?',
        'Rubor, Calor, Tumor, Dolor, Functio laesa',
      ],
      [
        '**Apoptosis** - hallmark DNA pattern?',
        '180bp "Laddering" (Endonuclease cleavage)',
      ],
      ['**Golgi** - tag for Lysosomal proteins?', 'Mannose-6-Phosphate (M6P)'],
    ];

    for (var data in cellBioData) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          frontText: Value(data[0]),
          backText: Value(data[1]),
          spacedDue: Value(DateTime.now().add(const Duration(days: 1))),
          spacedState: const Value(0), // New
        ),
      );
    }

    // --- Deck 2: High-Yield Micro (7 Mixed, 3 Due) ---
    final microData = [
      [
        '**S. aureus** - key virulence factor?',
        'Protein A (binds Fc region of IgG)',
        1,
        true,
        -1,
      ],
      [
        '**C. diphtheriae** - toxin mechanism?',
        'Inactivation of EF-2 (via ADP-ribosylation)',
        1,
        true,
        0,
      ],
      [
        '**P. aeruginosa** - classic pigment?',
        'Pyocyanin (Blue-green)',
        1,
        true,
        -2,
      ],
      [
        '**Toxoplasma** - CT brain findings?',
        'Multiple ring-enhancing lesions',
        0,
        false,
        2,
      ],
      [
        '**Giardia** - stool microscopy?',
        'Pear-shaped trophozoites (2 nuclei)',
        0,
        false,
        3,
      ],
      ['**Borrelia burgdorferi** - vector?', 'Ixodes tick', 0, false, 4],
      [
        '**Strep. pyogenes** - M protein role?',
        'Inhibits phagocytosis (Antiphagocytic)',
        0,
        false,
        5,
      ],
    ];

    for (var data in microData) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          frontText: Value(data[0] as String),
          backText: Value(data[1] as String),
          spacedState: Value(data[2] as int),
          spacedDue: Value(DateTime.now().add(Duration(days: data[4] as int))),
          spacedStability: Value(data[3] as bool ? 2.0 : 0.0),
        ),
      );
    }

    // --- Deck 3: Master Biochemistry (7 Veteran, 1 Due) ---
    final biochemData = [
      [
        '**G6PD Deficiency** - classic histology?',
        'Heinz bodies / Bite cells',
        2,
        false,
        120,
      ],
      [
        '**Lesch-Nyhan** - absent enzyme?',
        'HGPRT (Hyperuricemia + Self-mutilation)',
        2,
        true,
        -5,
      ],
      [
        '**Wernicke-Korsakoff** - deficiency?',
        'Vitamin B1 (Thiamine)',
        2,
        false,
        200,
      ],
      [
        '**Von Gierke** - deficient enzyme?',
        'Glucose-6-phosphatase',
        2,
        false,
        180,
      ],
      [
        '**Urea Cycle** - rate-limiting step?',
        'Carbamoyl Phosphate Synthetase I',
        2,
        false,
        300,
      ],
      [
        '**Alkaptonuria** - urine finding?',
        'Turns black on standing (Homogentisic acid)',
        2,
        false,
        250,
      ],
      [
        '**McArdle Disease** - deficient enzyme?',
        'Glycogen phosphorylase (Myophosphorylase)',
        2,
        false,
        220,
      ],
    ];

    for (var data in biochemData) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          frontText: Value(data[0] as String),
          backText: Value(data[1] as String),
          spacedState: Value(data[2] as int),
          spacedDue: Value(DateTime.now().add(Duration(days: data[4] as int))),
          spacedStability: const Value(100.0),
        ),
      );
    }

    // --- Deck 4: Comprehensive Rapid Review (20 Mixed, 7 Due) ---
    final compData = [
      [
        '**Warfarin** - mechanism?',
        'Vitamin K epoxide reductase inhibitor',
        2,
        true,
        -1,
      ],
      [
        '**Erb-Duchenne** - nerve roots?',
        'C5-C6 ("Waiter’s tip")',
        2,
        true,
        -2,
      ],
      ['**Digoxin** - toxic ECG finding?', '"Scooped" ST segments', 1, true, 0],
      [
        '**Patau Syndrome** - trisomy?',
        'Trisomy 13 (Puberty @ 13)',
        1,
        true,
        -3,
      ],
      ['**Clonidine** - mechanism?', 'Alpha-2 agonist (central)', 2, true, -1],
      [
        '**Horner Syndrome** - triad?',
        'Ptosis, Miosis, Anhidrosis',
        2,
        true,
        -4,
      ],
      ['**Graves Disease** - HLA?', 'HLA-DR3', 1, true, 0],
      [
        '**Thiazides** - calcium effect?',
        'Hypercalcemia (decreases excretion)',
        2,
        false,
        10,
      ],
      [
        '**Left shift** - affinity effect?',
        'Increased affinity for Oxygen',
        2,
        false,
        15,
      ],
      [
        '**Tricuspid Valve** - location?',
        '4th/5th intercostal (left border)',
        0,
        false,
        1,
      ],
      [
        '**Pheochromocytoma** - drug pre-op?',
        'Phenoxybenzamine (Alpha-blockade)',
        0,
        false,
        2,
      ],
      ['**Wipple Disease** - biopsy?', 'PAS-positive macrophages', 0, false, 3],
      ['**Amiodarone** - pulmonary SE?', 'Pulmonary fibrosis', 0, false, 4],
      [
        '**Rotator Cuff** - muscles?',
        'SITS (Supraspinatus, Infraspinatus, Teres minor, Subscapularis)',
        2,
        false,
        20,
      ],
      [
        '**Brunner Glands** - function?',
        'Secrete alkaline mucus (duodenum)',
        2,
        false,
        25,
      ],
      [
        '**Fanconi Anemia** - risk?',
        'AML (Acute Myeloid Leukemia)',
        2,
        false,
        30,
      ],
      [
        '**HACEK** - significance?',
        'Culture-negative endocarditis',
        2,
        false,
        35,
      ],
      [
        '**Aspirin** - acid-base?',
        'Early: Resp Alkalosis / Late: Metabolic Acidosis',
        0,
        false,
        5,
      ],
      [
        '**Sideroblastic Anemia** - histology?',
        'Ringed sideroblasts (iron in mitochondria)',
        0,
        false,
        6,
      ],
      [
        '**Pheochromocytoma** - origin?',
        'Chromaffin cells (Adrenal Medulla)',
        0,
        false,
        7,
      ],
    ];

    for (var data in compData) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          frontText: Value(data[0] as String),
          backText: Value(data[1] as String),
          spacedState: Value(data[2] as int),
          spacedDue: Value(DateTime.now().add(Duration(days: data[4] as int))),
          spacedStability: Value(data[3] as bool ? 5.0 : 0.0),
        ),
      );
    }

    await db.batch((batch) {
      batch.insertAll(db.cardItems, cards);
    });
  }
}
