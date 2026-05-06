// ignore_for_file: leading_newlines_in_over_line_strings, depend_on_referenced_packages
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:project_2359/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:project_2359/core/models/project_rect.dart';
import 'package:project_2359/core/tables/source_item_blobs.dart';
import 'package:project_2359/core/utils/logger.dart';

class BiologyCitationSeeder {
  static const String _baseUrl = 'https://raw.githubusercontent.com/ComsIndeed/project_2359/main/seeds/biology/';

  static Future<void> seed(AppDatabase db) async {
    final uuid = const Uuid();
    AppLogger.info('Starting Biology Citation Seeding (Download from GitHub)...', tag: 'BiologySeeder');

    // 1. Create Folder
    final folderId = uuid.v4();
    await db.into(db.studyFolderItems).insert(
      StudyFolderItemsCompanion(
        id: Value(folderId),
        name: const Value('Biology (CITATION DEMOs)'),
        isPinned: const Value(true),
        createdAt: Value(DateTime.now().toIso8601String()),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );

    // 2. Download and Create Sources/Blobs
    final sourceidBioHeavyBulletsV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}bio_heavy_bullets-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded bio_heavy_bullets-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidBioHeavyBulletsV1Pdf),
            sourceItemName: const Value('bio_heavy_bullets-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download bio_heavy_bullets-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading bio_heavy_bullets-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidBioHeavyBulletsV1Pdf),
        folderId: Value(folderId),
        label: const Value('bio_heavy_bullets-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidBioWallOfTextV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}bio_wall_of_text-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded bio_wall_of_text-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidBioWallOfTextV1Pdf),
            sourceItemName: const Value('bio_wall_of_text-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download bio_wall_of_text-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading bio_wall_of_text-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidBioWallOfTextV1Pdf),
        folderId: Value(folderId),
        label: const Value('bio_wall_of_text-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidCardiovascularDynamicsV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}cardiovascular_dynamics-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded cardiovascular_dynamics-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidCardiovascularDynamicsV1Pdf),
            sourceItemName: const Value('cardiovascular_dynamics-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download cardiovascular_dynamics-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading cardiovascular_dynamics-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidCardiovascularDynamicsV1Pdf),
        folderId: Value(folderId),
        label: const Value('cardiovascular_dynamics-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidCellularRespirationV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}cellular_respiration-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded cellular_respiration-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidCellularRespirationV1Pdf),
            sourceItemName: const Value('cellular_respiration-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download cellular_respiration-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading cellular_respiration-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidCellularRespirationV1Pdf),
        folderId: Value(folderId),
        label: const Value('cellular_respiration-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidImmunologyBasicsV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}immunology_basics-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded immunology_basics-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidImmunologyBasicsV1Pdf),
            sourceItemName: const Value('immunology_basics-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download immunology_basics-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading immunology_basics-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidImmunologyBasicsV1Pdf),
        folderId: Value(folderId),
        label: const Value('immunology_basics-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidMolecularGeneticsV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}molecular_genetics-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded molecular_genetics-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidMolecularGeneticsV1Pdf),
            sourceItemName: const Value('molecular_genetics-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download molecular_genetics-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading molecular_genetics-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidMolecularGeneticsV1Pdf),
        folderId: Value(folderId),
        label: const Value('molecular_genetics-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );
    final sourceidPopulationEcologyV1Pdf = uuid.v4();
    try {
      final response = await http.get(Uri.parse('${_baseUrl}population_ecology-v1.pdf'));
      if (response.statusCode == 200) {
        AppLogger.info('Downloaded population_ecology-v1.pdf (${response.bodyBytes.length} bytes)', tag: 'BiologySeeder');
        await db.into(db.sourceItemBlobs).insert(
          SourceItemBlobsCompanion(
            id: Value(uuid.v4()),
            sourceItemId: Value(sourceidPopulationEcologyV1Pdf),
            sourceItemName: const Value('population_ecology-v1.pdf'),
            type: const Value(SourceFileType.pdf),
            bytes: Value(response.bodyBytes),
          ),
        );
      } else {
        AppLogger.warning('Failed to download population_ecology-v1.pdf: ${response.statusCode}', tag: 'BiologySeeder');
      }
    } catch (e) {
      AppLogger.error('Error downloading population_ecology-v1.pdf: $e', tag: 'BiologySeeder');
    }

    await db.into(db.sourceItems).insert(
      SourceItemsCompanion(
        id: Value(sourceidPopulationEcologyV1Pdf),
        folderId: Value(folderId),
        label: const Value('population_ecology-v1.pdf'),
        type: const Value(MediaType.document),
      ),
    );

    // 3. Create Decks
    final deck1Id = uuid.v4();
    await db.into(db.deckItems).insert(
      DeckItemsCompanion(
        id: Value(deck1Id),
        folderId: Value(folderId),
        name: const Value('Cellular & Molecular Foundation'),
        description: const Value('Core biology concepts with varied mastery states.'),
      ),
    );
    final deck2Id = uuid.v4();
    await db.into(db.deckItems).insert(
      DeckItemsCompanion(
        id: Value(deck2Id),
        folderId: Value(folderId),
        name: const Value('Systems & Ecology'),
        description: const Value('Dynamics of populations and internal systems.'),
      ),
    );
    final deck3Id = uuid.v4();
    await db.into(db.deckItems).insert(
      DeckItemsCompanion(
        id: Value(deck3Id),
        folderId: Value(folderId),
        name: const Value('Immunology Basics'),
        description: const Value('Foundational immunology for new learners.'),
      ),
    );
    final deck4Id = uuid.v4();
    await db.into(db.deckItems).insert(
      DeckItemsCompanion(
        id: Value(deck4Id),
        folderId: Value(folderId),
        name: const Value('Genetic Architecture'),
        description: const Value('Molecular genetics and inheritance patterns.'),
      ),
    );

    // 4. Create Citations and Cards
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Population Ecology"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 151.7842, top: 252.1802, right: 641.7802, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Population Ecology"),
          spacedState: const Value(2),
          spacedStability: const Value(39.983598076176406),
          spacedDifficulty: const Value(3.1595008816734076),
          spacedDue: Value(DateTime.now().add(const Duration(days: 28))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Project 2359 Stress Test Deck"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 235.403, top: 409.5006, right: 556.691, bottom: 433.4766)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 1."),
          backText: const Value("Project 2359 Stress Test Deck"),
          spacedState: const Value(1),
          spacedStability: const Value(2.792122665134949),
          spacedDifficulty: const Value(5.809147080200595),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 2))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("RR"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 551.7931, top: 316.7498, right: 586.1371, bottom: 340.7258)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 3."),
          backText: const Value("RR"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 53.7019, top: 445.0499, right: 737.3307, bottom: 505.8339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **yields**?"),
          backText: const Value("According to the source on page 2: \"• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([19]),
          rects: const Value([ProjectRect(left: 53.7019, top: 270.2499, right: 726.934, bottom: 331.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **pathway**?"),
          backText: const Value("According to the source on page 19: \"• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Feature"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 57.0, top: 132.2498, right: 121.926, bottom: 150.2318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Feature"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("4. Purkinje Fibers: Rapidly distributes impulse through ventricular muscle."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 52.76, top: 331.25, right: 713.0833, bottom: 351.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **impulse**?"),
          backText: const Value("According to the source on page 4: \"4. Purkinje Fibers: Rapidly distributes impulse through ventricular muscle.\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.247482644284803),
          spacedDifficulty: const Value(6.053784626371404),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 5))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Heavy Chains: Two identical long polypeptide chains."),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 220.75, right: 369.3036, bottom: 270.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Heavy**?"),
          backText: const Value("According to the source on page 3: \"• Heavy Chains: Two identical long polypeptide chains.\""),
          spacedState: const Value(2),
          spacedStability: const Value(29.384854792980676),
          spacedDifficulty: const Value(6.549039788469687),
          spacedDue: Value(DateTime.now().add(const Duration(days: 6))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Heavy Chains: Two identical long polypeptide chains."),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 220.75, right: 369.3036, bottom: 270.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **chains.**?"),
          backText: const Value("According to the source on page 3: \"• Heavy Chains: Two identical long polypeptide chains.\""),
          spacedState: const Value(2),
          spacedStability: const Value(54.70990026504709),
          spacedDifficulty: const Value(6.189790460441536),
          spacedDue: Value(DateTime.now().add(const Duration(days: 14))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cardiovascular Dynamics"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 75.575, top: 252.1802, right: 718.229, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Cardiovascular Dynamics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 6: Avian Flight Mechanics"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([7]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 491.76, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **Flight**?"),
          backText: const Value("According to the source on page 7: \"Slide 6: Avian Flight Mechanics\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.9744133086868023),
          spacedDifficulty: const Value(6.067346267593999),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 8))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Key regulatory enzyme: [Cite: \"Principles of Biochemistry, 8th Ed., Ch. 14\"] Phosphofructokinase (PFK)."),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 528.75, right: 734.9922, bottom: 578.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **regulatory**?"),
          backText: const Value("According to the source on page 2: \"• Key regulatory enzyme: [Cite: \"Principles of Biochemistry, 8th Ed., Ch. 14\"] Phosphofructokinase (PFK).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("2. Antibody Structure"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 390.712, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 3."),
          backText: const Value("2. Antibody Structure"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("driven)"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 286.7498, right: 559.5788, bottom: 304.7318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("driven)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([20]),
          rects: const Value([ProjectRect(left: 53.7019, top: 445.0499, right: 737.3307, bottom: 505.8339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **endergonic**?"),
          backText: const Value("According to the source on page 20: \"• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium.\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.966214680028343),
          spacedDifficulty: const Value(7.087059968677691),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 7))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Occurs in the cytoplasm of the cell."),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 338.25, right: 377.04, bottom: 358.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 2."),
          backText: const Value("• Occurs in the cytoplasm of the cell."),
          spacedState: const Value(1),
          spacedStability: const Value(2.7030903009603726),
          spacedDifficulty: const Value(7.756704385135555),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 8))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("2. Antibody Structure"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 390.712, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 3."),
          backText: const Value("2. Antibody Structure"),
          spacedState: const Value(1),
          spacedStability: const Value(1.319649930883254),
          spacedDifficulty: const Value(6.222110793506102),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 2))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("MAP ≈ DP + 1/3(SP - DP)"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 67.5, top: 300.5199, right: 296.56, bottom: 323.4999)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 3."),
          backText: const Value("MAP ≈ DP + 1/3(SP - DP)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(1),
          spacedStability: const Value(1.889275706449152),
          spacedDifficulty: const Value(7.289723843317965),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 0))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Campbell Biology 12th Ed., Unit 8\"]"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 373.7937, top: 556.9317, right: 734.9937, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 3."),
          backText: const Value("[Cite: \"Campbell Biology 12th Ed., Unit 8\"]"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([10]),
          rects: const Value([ProjectRect(left: 53.7019, top: 270.2499, right: 726.934, bottom: 331.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **clinically**?"),
          backText: const Value("According to the source on page 10: \"• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Cardiovascular Physiology Concepts, Richard E. Klabunde\"]"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 188.9905, top: 511.9317, right: 734.9905, bottom: 530.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **\"Cardiovascular**?"),
          backText: const Value("According to the source on page 3: \"[Cite: \"Cardiovascular Physiology Concepts, Richard E. Klabunde\"]\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.999853667648375),
          spacedDifficulty: const Value(5.962058580069392),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Campbell Biology 12th Ed., Unit 8\"]"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 373.7937, top: 556.9317, right: 734.9937, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 3."),
          backText: const Value("[Cite: \"Campbell Biology 12th Ed., Unit 8\"]"),
          spacedState: const Value(1),
          spacedStability: const Value(1.905866042889826),
          spacedDifficulty: const Value(7.49770145759714),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 3))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(1),
          spacedStability: const Value(1.5011255150207754),
          spacedDifficulty: const Value(6.122539303654195),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 6))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([14]),
          rects: const Value([ProjectRect(left: 53.7019, top: 270.2499, right: 726.934, bottom: 331.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **spectrum**?"),
          backText: const Value("According to the source on page 14: \"• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides.\""),
          spacedState: const Value(2),
          spacedStability: const Value(45.31230536202431),
          spacedDifficulty: const Value(4.722826384547783),
          spacedDue: Value(DateTime.now().add(const Duration(days: 11))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Memory"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 57.0, top: 350.4998, right: 126.408, bottom: 368.4818)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Memory"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(2),
          spacedStability: const Value(41.775210862382174),
          spacedDifficulty: const Value(5.238994301207148),
          spacedDue: Value(DateTime.now().add(const Duration(days: 21))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cardiovascular Dynamics"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 75.575, top: 252.1802, right: 718.229, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Cardiovascular Dynamics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(1),
          spacedStability: const Value(1.1705019080753856),
          spacedDifficulty: const Value(6.483092877376199),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 3))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Population Ecology"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 151.7842, top: 252.1802, right: 641.7802, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Population Ecology"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Immunology Basics"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 147.4944, top: 252.1802, right: 646.0224, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Immunology Basics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 60.0, top: 132.0, right: 682.02, bottom: 181.98)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **protein.**?"),
          backText: const Value("According to the source on page 2: \"The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([9]),
          rects: const Value([ProjectRect(left: 53.7019, top: 521.2499, right: 739.4261, bottom: 582.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **mitochondrial**?"),
          backText: const Value("According to the source on page 9: \"• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Evolutionary Biology: Text Dumps"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 82.8754, top: 285.5004, right: 709.2254, bottom: 385.4507)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 1."),
          backText: const Value("Evolutionary Biology: Text Dumps"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Antigen Binding Sites Variable Region"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 526.02, top: 151.0358, right: 700.9272, bottom: 165.3158)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Region**?"),
          backText: const Value("According to the source on page 3: \"Antigen Binding Sites Variable Region\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.9914565047048987),
          spacedDifficulty: const Value(5.21986708542952),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 3))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Energy flow through an ecosystem is fundamentally inefficient. Only about 10% of the energy stored as biomass in a trophic level is passed to the next."),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 120.75, right: 743.08, bottom: 170.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **population_ecology-v1.pdf**, what is the significance of **inefficient.**?"),
          backText: const Value("According to the source on page 3: \"Energy flow through an ecosystem is fundamentally inefficient. Only about 10% of the energy stored as biomass in a trophic level is passed to the next.\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.190396961978238),
          spacedDifficulty: const Value(7.406170171927281),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 1))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Source: Unformatted Bio Text Dump, Vol 7]"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([8]),
          rects: const Value([ProjectRect(left: 444.6123, top: 569.4176, right: 747.0123, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 8."),
          backText: const Value("[Source: Unformatted Bio Text Dump, Vol 7]"),
          spacedState: const Value(2),
          spacedStability: const Value(44.474502740414756),
          spacedDifficulty: const Value(3.7149882847222115),
          spacedDue: Value(DateTime.now().add(const Duration(days: 15))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of the endosymbiotic theory, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **sudden**?"),
          backText: const Value("According to the source on page 2: \"When considering the overarching paradigms of the endosymbiotic theory, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.3296088797951513),
          spacedDifficulty: const Value(6.052591450167714),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 6))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of mass extinction events, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([5]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **fluctuations**?"),
          backText: const Value("According to the source on page 5: \"When considering the overarching paradigms of mass extinction events, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.031172389049467),
          spacedDifficulty: const Value(6.597399490309012),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 5))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Immunology Basics"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 147.4944, top: 252.1802, right: 646.0224, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Immunology Basics"),
          spacedState: const Value(1),
          spacedStability: const Value(1.9288800670739463),
          spacedDifficulty: const Value(5.691943602055204),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 8))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Heavy Chains: Two identical long polypeptide chains."),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 220.75, right: 369.3036, bottom: 270.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Heavy**?"),
          backText: const Value("According to the source on page 3: \"• Heavy Chains: Two identical long polypeptide chains.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. Population Growth Models"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 513.248, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("1. Population Growth Models"),
          spacedState: const Value(2),
          spacedStability: const Value(11.120969222056607),
          spacedDifficulty: const Value(4.799681428685921),
          spacedDue: Value(DateTime.now().add(const Duration(days: 7))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Transcription: Synthesizing RNA from a DNA template (in nucleus)."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 434.1698, right: 671.7616, bottom: 454.1498)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **Transcription:**?"),
          backText: const Value("According to the source on page 2: \"• Transcription: Synthesizing RNA from a DNA template (in nucleus).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Transcription: Synthesizing RNA from a DNA template (in nucleus)."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 434.1698, right: 671.7616, bottom: 454.1498)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **Synthesizing**?"),
          backText: const Value("According to the source on page 2: \"• Transcription: Synthesizing RNA from a DNA template (in nucleus).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 18\"]"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([10]),
          rects: const Value([ProjectRect(left: 53.7019, top: 521.2499, right: 747.012, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **tethered**?"),
          backText: const Value("According to the source on page 10: \"• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 18\"]\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.0125426408574487),
          spacedDifficulty: const Value(6.527684599218636),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 5))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Molecular Genetics"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 155.0251, top: 252.1802, right: 638.5411, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Molecular Genetics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cellular Respiration"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 148.0525, top: 252.1802, right: 645.6085, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Cellular Respiration"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(2),
          spacedStability: const Value(31.612865561898957),
          spacedDifficulty: const Value(3.148942900150975),
          spacedDue: Value(DateTime.now().add(const Duration(days: 18))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Delayed (Days)"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 195.9998, right: 626.9888, bottom: 213.9818)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Delayed (Days)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("6. Autonomic Nervous System"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([7]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 477.48, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_heavy_bullets-v1.pdf page 7."),
          backText: const Value("6. Autonomic Nervous System"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(1),
          spacedStability: const Value(1.5960324419969651),
          spacedDifficulty: const Value(7.172372491277287),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 5))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("3. Bundle of His: Conducts impulse to the septum."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 52.76, top: 287.75, right: 507.2825, bottom: 307.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **septum.**?"),
          backText: const Value("According to the source on page 4: \"3. Bundle of His: Conducts impulse to the septum.\""),
          spacedState: const Value(2),
          spacedStability: const Value(55.20085665840809),
          spacedDifficulty: const Value(3.6521755705118673),
          spacedDue: Value(DateTime.now().add(const Duration(days: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("T-Cells, B-Cells"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 427.7498, right: 628.9868, bottom: 445.7318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("T-Cells, B-Cells"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of the endosymbiotic theory, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **multicellularity.**?"),
          backText: const Value("According to the source on page 2: \"When considering the overarching paradigms of the endosymbiotic theory, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.5672507172890555),
          spacedDifficulty: const Value(6.422730247724872),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 2))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("19. Alveolar Gas Exchange"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([20]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 427.23, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_heavy_bullets-v1.pdf page 20."),
          backText: const Value("19. Alveolar Gas Exchange"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. The Glycolysis Pathway"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 467.416, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 2."),
          backText: const Value("1. The Glycolysis Pathway"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of the rna world, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([11]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **grades**?"),
          backText: const Value("According to the source on page 11: \"When considering the overarching paradigms of the rna world, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(2),
          spacedStability: const Value(53.03821057507998),
          spacedDifficulty: const Value(5.632060428584547),
          spacedDue: Value(DateTime.now().add(const Duration(days: 2))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("FADH2"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 306.0, top: 374.4338, right: 345.7922, bottom: 390.7658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 3."),
          backText: const Value("FADH2"),
          spacedState: const Value(1),
          spacedStability: const Value(1.78474836178778),
          spacedDifficulty: const Value(6.589921368090875),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 9))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Time (t)"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 559.77, top: 291.9338, right: 602.1781, bottom: 308.2658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("Time (t)"),
          spacedState: const Value(1),
          spacedStability: const Value(1.6832602511999744),
          spacedDifficulty: const Value(7.221313240791382),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 1))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 60.0, top: 132.0, right: 682.02, bottom: 181.98)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **Dogma**?"),
          backText: const Value("According to the source on page 2: \"The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein.\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.4820335480654117),
          spacedDifficulty: const Value(7.8066409953108495),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of hominin bipedalism, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([8]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **facilitated**?"),
          backText: const Value("According to the source on page 8: \"When considering the overarching paradigms of hominin bipedalism, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(2),
          spacedStability: const Value(34.45836269915443),
          spacedDifficulty: const Value(3.7595655160577928),
          spacedDue: Value(DateTime.now().add(const Duration(days: 3))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. Population Growth Models"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 513.248, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("1. Population Growth Models"),
          spacedState: const Value(2),
          spacedStability: const Value(29.737350343018257),
          spacedDifficulty: const Value(3.9216154135763692),
          spacedDue: Value(DateTime.now().add(const Duration(days: 8))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([9]),
          rects: const Value([ProjectRect(left: 53.7019, top: 346.4499, right: 721.03, bottom: 429.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **inhibition**?"),
          backText: const Value("According to the source on page 9: \"• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive.\""),
          spacedState: const Value(1),
          spacedStability: const Value(1.0283873112128292),
          spacedDifficulty: const Value(6.530106702185002),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 8))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("2. The Electrical Conduction System"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 631.432, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 4."),
          backText: const Value("2. The Electrical Conduction System"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("CO2, NADH"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 471.0, top: 261.9338, right: 537.6964, bottom: 278.2658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 3."),
          backText: const Value("CO2, NADH"),
          spacedState: const Value(1),
          spacedStability: const Value(1.8151417136855708),
          spacedDifficulty: const Value(5.393366483604238),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(2),
          spacedStability: const Value(22.738053876974178),
          spacedDifficulty: const Value(2.9926903579398827),
          spacedDue: Value(DateTime.now().add(const Duration(days: 14))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("MAP ≈ DP + 1/3(SP - DP)"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 67.5, top: 300.5199, right: 296.56, bottom: 323.4999)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 3."),
          backText: const Value("MAP ≈ DP + 1/3(SP - DP)"),
          spacedState: const Value(1),
          spacedStability: const Value(2.673715423448131),
          spacedDifficulty: const Value(5.678999243224644),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 6))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Population Ecology"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 151.7842, top: 252.1802, right: 641.7802, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Population Ecology"),
          spacedState: const Value(2),
          spacedStability: const Value(33.87046550449405),
          spacedDifficulty: const Value(2.86518348790265),
          spacedDue: Value(DateTime.now().add(const Duration(days: 4))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Highly specific (antigen-"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 259.7498, right: 695.5688, bottom: 277.7318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Highly specific (antigen-"),
          spacedState: const Value(1),
          spacedStability: const Value(1.600795997291409),
          spacedDifficulty: const Value(5.18356530147971),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 7))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cardiovascular Dynamics"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 75.575, top: 252.1802, right: 718.229, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Cardiovascular Dynamics"),
          spacedState: const Value(1),
          spacedStability: const Value(2.5764308938287153),
          spacedDifficulty: const Value(7.3737450304610075),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 4))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(1),
          spacedStability: const Value(2.448526365431389),
          spacedDifficulty: const Value(7.6626015309906474),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 7))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Immunology Basics"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 147.4944, top: 252.1802, right: 646.0224, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Immunology Basics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Source: Unformatted Bio Text Dump, Vol 4]"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([5]),
          rects: const Value([ProjectRect(left: 444.6123, top: 569.4176, right: 747.0123, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 5."),
          backText: const Value("[Source: Unformatted Bio Text Dump, Vol 4]"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Project 2359 Stress Test Deck"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 235.403, top: 409.5006, right: 556.691, bottom: 433.4766)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 1."),
          backText: const Value("Project 2359 Stress Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• N: Population size."),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 425.25, right: 233.4403, bottom: 445.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("• N: Population size."),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("FADH2"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 306.0, top: 374.4338, right: 345.7922, bottom: 390.7658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 3."),
          backText: const Value("FADH2"),
          spacedState: const Value(1),
          spacedStability: const Value(2.410146562700417),
          spacedDifficulty: const Value(5.459685634497568),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 2))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(2),
          spacedStability: const Value(26.155399941563985),
          spacedDifficulty: const Value(6.313330209445956),
          spacedDue: Value(DateTime.now().add(const Duration(days: 20))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Memory"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 57.0, top: 350.4998, right: 126.408, bottom: 368.4818)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Memory"),
          spacedState: const Value(2),
          spacedStability: const Value(43.49503148127484),
          spacedDifficulty: const Value(6.7861959533218235),
          spacedDue: Value(DateTime.now().add(const Duration(days: 9))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("11. Adrenal Steroidogenesis"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([12]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 448.11, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_heavy_bullets-v1.pdf page 12."),
          backText: const Value("11. Adrenal Steroidogenesis"),
          spacedState: const Value(2),
          spacedStability: const Value(16.155197627606956),
          spacedDifficulty: const Value(5.953418200659137),
          spacedDue: Value(DateTime.now().add(const Duration(days: 17))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(1),
          spacedStability: const Value(1.938485079825336),
          spacedDifficulty: const Value(5.525612611986255),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 0))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Primary Mechanism: The integration of action potential propagation relies heavily on protein- protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi-permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 53.7019, top: 95.4499, right: 725.3965, bottom: 178.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **phosphorylation,**?"),
          backText: const Value("According to the source on page 3: \"• Primary Mechanism: The integration of action potential propagation relies heavily on protein- protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi-permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations.\""),
          spacedState: const Value(2),
          spacedStability: const Value(34.14281770534763),
          spacedDifficulty: const Value(2.896200222439001),
          spacedDue: Value(DateTime.now().add(const Duration(days: 17))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Antibodies (immunoglobulins) are Y- shaped proteins produced by B cells."),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 140.75, right: 371.9, bottom: 190.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Antibodies**?"),
          backText: const Value("According to the source on page 3: \"Antibodies (immunoglobulins) are Y- shaped proteins produced by B cells.\""),
          spacedState: const Value(2),
          spacedStability: const Value(51.81712406986909),
          spacedDifficulty: const Value(4.445922134363664),
          spacedDue: Value(DateTime.now().add(const Duration(days: 11))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 4: Mass Extinction Events"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([5]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 493.86, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 5."),
          backText: const Value("Slide 4: Mass Extinction Events"),
          spacedState: const Value(2),
          spacedStability: const Value(28.04988537706757),
          spacedDifficulty: const Value(3.6806994287762738),
          spacedDue: Value(DateTime.now().add(const Duration(days: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Innate Immune System"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 209.2928, top: 132.2498, right: 404.8628, bottom: 150.2318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Innate Immune System"),
          spacedState: const Value(2),
          spacedStability: const Value(44.6487600380056),
          spacedDifficulty: const Value(3.904821617120553),
          spacedDue: Value(DateTime.now().add(const Duration(days: 26))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cardiovascular Dynamics"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 75.575, top: 252.1802, right: 718.229, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Cardiovascular Dynamics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 10: The RNA World"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([11]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 395.4, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 11."),
          backText: const Value("Slide 10: The RNA World"),
          spacedState: const Value(2),
          spacedStability: const Value(16.82067053614297),
          spacedDifficulty: const Value(3.2636139647173206),
          spacedDue: Value(DateTime.now().add(const Duration(days: 1))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 8: The Multi-Regional Hypothesis"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([9]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 598.32, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 9."),
          backText: const Value("Slide 8: The Multi-Regional Hypothesis"),
          spacedState: const Value(1),
          spacedStability: const Value(1.7230202860672588),
          spacedDifficulty: const Value(6.171558900604197),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 11))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Molecular Genetics"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 155.0251, top: 252.1802, right: 638.5411, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Molecular Genetics"),
          spacedState: const Value(2),
          spacedStability: const Value(37.05130593468488),
          spacedDifficulty: const Value(4.678765006459239),
          spacedDue: Value(DateTime.now().add(const Duration(days: 27))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 6: Avian Flight Mechanics"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([7]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 491.76, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **Mechanics**?"),
          backText: const Value("According to the source on page 7: \"Slide 6: Avian Flight Mechanics\""),
          spacedState: const Value(1),
          spacedStability: const Value(2.7786841729158533),
          spacedDifficulty: const Value(7.6856241936282075),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 5))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Molecular Genetics"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 155.0251, top: 252.1802, right: 638.5411, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Molecular Genetics"),
          spacedState: const Value(1),
          spacedStability: const Value(2.0293765454611847),
          spacedDifficulty: const Value(5.928157036764809),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 0))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(1),
          spacedStability: const Value(2.395134508321153),
          spacedDifficulty: const Value(5.717880331248544),
          spacedDue: Value(DateTime.now().subtract(const Duration(hours: 10))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Highly specific (antigen-"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 259.7498, right: 695.5688, bottom: 277.7318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Highly specific (antigen-"),
          spacedState: const Value(2),
          spacedStability: const Value(48.66344078249921),
          spacedDifficulty: const Value(2.545788976219205),
          spacedDue: Value(DateTime.now().add(const Duration(days: 12))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Enzymatic Regulation: Kinases and phosphatases dynamically alter the structural conformation of key channel proteins. For instance, the binding of cyclic AMP (cAMP) to the regulatory subunits of Protein Kinase A (PKA) releases the catalytic subunits."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 53.7019, top: 194.0499, right: 708.982, bottom: 254.8339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **channel**?"),
          backText: const Value("According to the source on page 4: \"• Enzymatic Regulation: Kinases and phosphatases dynamically alter the structural conformation of key channel proteins. For instance, the binding of cyclic AMP (cAMP) to the regulatory subunits of Protein Kinase A (PKA) releases the catalytic subunits.\""),
          spacedState: const Value(2),
          spacedStability: const Value(29.51351347460767),
          spacedDifficulty: const Value(3.129328368785431),
          spacedDue: Value(DateTime.now().add(const Duration(days: 18))),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose."),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 455.25, right: 355.3, bottom: 505.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **molecules**?"),
          backText: const Value("According to the source on page 2: \"• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("rr"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 671.7588, top: 369.2498, right: 687.7428, bottom: 393.2258)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 3."),
          backText: const Value("rr"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Antigen Binding Sites Variable Region"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 526.02, top: 151.0358, right: 700.9272, bottom: 165.3158)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Binding**?"),
          backText: const Value("According to the source on page 3: \"Antigen Binding Sites Variable Region\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose."),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 455.25, right: 355.3, bottom: 505.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **molecules**?"),
          backText: const Value("According to the source on page 2: \"• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Light Chains: Two identical short chains."),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 294.25, right: 365.8635, bottom: 344.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **chains.**?"),
          backText: const Value("According to the source on page 3: \"• Light Chains: Two identical short chains.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rr"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 556.3048, top: 369.2498, right: 581.6248, bottom: 393.2258)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 3."),
          backText: const Value("Rr"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Primary Mechanism: The integration of alveolar gas exchange relies heavily on protein-protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi- permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([20]),
          rects: const Value([ProjectRect(left: 53.7019, top: 95.4499, right: 736.9645, bottom: 178.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **variations.**?"),
          backText: const Value("According to the source on page 20: \"• Primary Mechanism: The integration of alveolar gas exchange relies heavily on protein-protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi- permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. Hemodynamics & Blood Pressure"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 629.46, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 2."),
          backText: const Value("1. Hemodynamics & Blood Pressure"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Tertiary (10 J)"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 356.0222, top: 261.9338, right: 435.9779, bottom: 278.2658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 3."),
          backText: const Value("Tertiary (10 J)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("12. Pancreatic Endocrine Function"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([13]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 535.89, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_heavy_bullets-v1.pdf page 13."),
          backText: const Value("12. Pancreatic Endocrine Function"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Immediate (Minutes/Hours)"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 209.2928, top: 195.9998, right: 426.3368, bottom: 213.9818)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Immediate (Minutes/Hours)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 4: Mass Extinction Events"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([5]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 493.86, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 5."),
          backText: const Value("Slide 4: Mass Extinction Events"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Secondary Consumers (100 J)"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 310.2719, top: 314.4338, right: 481.7283, bottom: 330.7658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 3."),
          backText: const Value("Secondary Consumers (100 J)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Source: Unformatted Bio Text Dump, Vol 7]"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([8]),
          rects: const Value([ProjectRect(left: 444.6123, top: 569.4176, right: 747.0123, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 8."),
          backText: const Value("[Source: Unformatted Bio Text Dump, Vol 7]"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Molecular Genetics"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 155.0251, top: 252.1802, right: 638.5411, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Molecular Genetics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Population Ecology"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 151.7842, top: 252.1802, right: 641.7802, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Population Ecology"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Highly specific (antigen-"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 259.7498, right: 695.5688, bottom: 277.7318)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Highly specific (antigen-"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([19]),
          rects: const Value([ProjectRect(left: 53.7019, top: 270.2499, right: 726.934, bottom: 331.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **these**?"),
          backText: const Value("According to the source on page 19: \"• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• K: Carrying capacity."),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 468.75, right: 253.3603, bottom: 488.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("• K: Carrying capacity."),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose."),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 54.9404, top: 455.25, right: 355.3, bottom: 505.23)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **glucose.**?"),
          backText: const Value("According to the source on page 2: \"• Net yield: 2 ATP, 2 NADH, 2 Pyruvate molecules per glucose.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Population Ecology"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 151.7842, top: 252.1802, right: 641.7802, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Population Ecology"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Time (t)"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 559.77, top: 291.9338, right: 602.1781, bottom: 308.2658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 2."),
          backText: const Value("Time (t)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Systolic Pressure: Peak pressure in the arteries during the cardiac cycle."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 5.0002, right: 375.4828, bottom: 84.9802)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **Systolic**?"),
          backText: const Value("According to the source on page 3: \"• Systolic Pressure: Peak pressure in the arteries during the cardiac cycle.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Law of Segregation: Allele pairs separate during gamete formation, and randomly unite at fertilization."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 140.75, right: 349.06, bottom: 220.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **fertilization.**?"),
          backText: const Value("According to the source on page 3: \"Law of Segregation: Allele pairs separate during gamete formation, and randomly unite at fertilization.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("R"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 560.3009, top: 264.2498, right: 577.6289, bottom: 288.2258)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 3."),
          backText: const Value("R"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Glucose (6C)"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 539.3973, top: 155.3183, right: 617.6424, bottom: 173.7053)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 2."),
          backText: const Value("Glucose (6C)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Fc Region (Constant)"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 616.02, top: 308.5358, right: 717.1973, bottom: 322.8158)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 3."),
          backText: const Value("Fc Region (Constant)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("6. Autonomic Nervous System"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([7]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 477.48, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_heavy_bullets-v1.pdf page 7."),
          backText: const Value("6. Autonomic Nervous System"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 60.0, top: 132.0, right: 682.02, bottom: 181.98)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **molecular**?"),
          backText: const Value("According to the source on page 2: \"The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("3. Bundle of His: Conducts impulse to the septum."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 52.76, top: 287.75, right: 507.2825, bottom: 307.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **Bundle**?"),
          backText: const Value("According to the source on page 4: \"3. Bundle of His: Conducts impulse to the septum.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([16]),
          rects: const Value([ProjectRect(left: 53.7019, top: 346.4499, right: 721.03, bottom: 429.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **product.**?"),
          backText: const Value("According to the source on page 16: \"• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of mass extinction events, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([5]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **underwent**?"),
          backText: const Value("According to the source on page 5: \"When considering the overarching paradigms of mass extinction events, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Systolic Pressure: Peak pressure in the arteries during the cardiac cycle."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 5.0002, right: 375.4828, bottom: 84.9802)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **cycle.**?"),
          backText: const Value("According to the source on page 3: \"• Systolic Pressure: Peak pressure in the arteries during the cardiac cycle.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cellular Respiration"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 148.0525, top: 252.1802, right: 645.6085, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Cellular Respiration"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of epigenetic inheritance, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([10]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **Miller,**?"),
          backText: const Value("According to the source on page 10: \"When considering the overarching paradigms of epigenetic inheritance, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([14]),
          rects: const Value([ProjectRect(left: 53.7019, top: 346.4499, right: 721.03, bottom: 429.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **Pharmacological**?"),
          backText: const Value("According to the source on page 14: \"• Pharmacological Intervention: Competitive inhibitors can bind to the active site, effectively halting the conversion of substrate to product. The Michaelis-Menten kinetics (Km and Vmax) are altered depending on whether the inhibition is competitive, non-competitive, or uncompetitive.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Source: Unformatted Bio Text Dump, Vol 8]"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([9]),
          rects: const Value([ProjectRect(left: 444.6123, top: 569.4176, right: 747.0123, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 9."),
          backText: const Value("[Source: Unformatted Bio Text Dump, Vol 8]"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of hominin bipedalism, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([8]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **cellular**?"),
          backText: const Value("According to the source on page 8: \"When considering the overarching paradigms of hominin bipedalism, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Cellular Respiration"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 148.0525, top: 252.1802, right: 645.6085, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Cellular Respiration"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Janeway's Immunobiology, 9th Edition\"]"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 348.5933, top: 556.9317, right: 734.9933, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **[Cite:**?"),
          backText: const Value("According to the source on page 2: \"[Cite: \"Janeway's Immunobiology, 9th Edition\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Project 2359 Stress Test Deck"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 235.403, top: 409.5006, right: 556.691, bottom: 433.4766)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 1."),
          backText: const Value("Project 2359 Stress Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Journal of Metabolic Studies, Vol 4. 2023\"]"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 306.5925, top: 556.9317, right: 734.9925, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **[Cite:**?"),
          backText: const Value("According to the source on page 3: \"[Cite: \"Journal of Metabolic Studies, Vol 4. 2023\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Journal of Metabolic Studies, Vol 4. 2023\"]"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 306.5925, top: 556.9317, right: 734.9925, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cellular_respiration-v1.pdf**, what is the significance of **2023\"]**?"),
          backText: const Value("According to the source on page 3: \"[Cite: \"Journal of Metabolic Studies, Vol 4. 2023\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 1: The Endosymbiotic Theory"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 545.01, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 2."),
          backText: const Value("Slide 1: The Endosymbiotic Theory"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 60.0, top: 132.0, right: 682.02, bottom: 181.98)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **explains**?"),
          backText: const Value("According to the source on page 2: \"The Central Dogma of molecular biology explains the flow of genetic information, from DNA to RNA, to make a functional product, a protein.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Immunology Basics"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 147.4944, top: 252.1802, right: 646.0224, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Immunology Basics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Evolutionary Biology: Text Dumps"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 82.8754, top: 285.5004, right: 709.2254, bottom: 385.4507)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 1."),
          backText: const Value("Evolutionary Biology: Text Dumps"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 19\"]"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([11]),
          rects: const Value([ProjectRect(left: 53.7019, top: 521.2499, right: 747.012, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **While**?"),
          backText: const Value("According to the source on page 11: \"• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 19\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("alpha-KG"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 451.7307, top: 321.3788, right: 490.269, bottom: 333.6368)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 3."),
          backText: const Value("alpha-KG"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Slide 6: Avian Flight Mechanics"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([7]),
          rects: const Value([ProjectRect(left: 45.0, top: 37.5001, right: 491.76, bottom: 67.4701)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **Flight**?"),
          backText: const Value("According to the source on page 7: \"Slide 6: Avian Flight Mechanics\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 16\"]"),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([8]),
          rects: const Value([ProjectRect(left: 53.7019, top: 521.2499, right: 747.012, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **stages**?"),
          backText: const Value("According to the source on page 8: \"• Cellular Localization: While the initial stages occur in the cytosol, the terminal enzymatic steps are tethered to the inner mitochondrial membrane, increasing the local concentration of intermediates and preventing their diffusion into off-target pathways. [Cite: \"Advanced Physiology, Chapter 16\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Cite: \"Janeway's Immunobiology, 9th Edition\"]"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 348.5933, top: 556.9317, right: 734.9933, bottom: 575.9997)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **immunology_basics-v1.pdf**, what is the significance of **Immunobiology,**?"),
          backText: const Value("According to the source on page 2: \"[Cite: \"Janeway's Immunobiology, 9th Edition\"]\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Law of Independent Assortment: Alleles of two (or more) different genes get sorted into gametes independently of one another."),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 250.75, right: 356.84, bottom: 360.73)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **molecular_genetics-v1.pdf**, what is the significance of **different**?"),
          backText: const Value("According to the source on page 3: \"Law of Independent Assortment: Alleles of two (or more) different genes get sorted into gametes independently of one another.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("2. Mendelian Inheritance"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 440.114, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 3."),
          backText: const Value("2. Mendelian Inheritance"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Rich Content Visual Test Deck"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 221.2533, top: 321.1803, right: 570.8493, bottom: 347.1543)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 1."),
          backText: const Value("Rich Content Visual Test Deck"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("When considering the overarching paradigms of the multi-regional hypothesis, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022)."),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([9]),
          rects: const Value([ProjectRect(left: 45.0, top: 93.7501, right: 747.2175, bottom: 522.7351)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_wall_of_text-v1.pdf**, what is the significance of **record,**?"),
          backText: const Value("According to the source on page 9: \"When considering the overarching paradigms of the multi-regional hypothesis, one must account for a myriad of confounding variables that researchers have debated for decades (Smith & Wesson, 2018). The fossil record, while invaluable, presents a highly fragmented and taphonomically biased window into deep time, meaning that absence of evidence is fundamentally not evidence of absence. Furthermore, isotopic analysis of carbon-13 and oxygen-18 ratios in sedimentary rocks indicates massive fluctuations in global climate and atmospheric composition, which directly correlates with the selective pressures driving morphological divergence in early taxa (Jones et al., 2021). It is crucial to note that the morphological innovations observed during this period were not sudden in a biological sense, but rather the culmination of millions of years of cryptic genetic variation accumulating within isolated subpopulations, eventually reaching a tipping point of phenotypic expression once environmental constraints were lifted or new ecological niches became available following major tectonic shifts. For example, the regulatory gene networks—specifically the Hox gene clusters responsible for anteroposterior axis patterning—likely underwent significant duplication events, allowing for the functional divergence of redundant genomic segments without compromising the viability of the organism (Chen & Zhao, 2019; Miller, 2020). This genomic plasticity facilitated the rapid radiation of body plans. Additionally, we cannot ignore the role of lateral gene transfer among prokaryotic ancestors, which significantly complicates the construction of a standard bifurcating phylogenetic tree and instead suggests a highly reticulated 'web of life' at its base. The integration of mitochondrial and plastid precursors via phagocytosis without subsequent digestion revolutionized eukaryotic cellular energetics, granting an unparalleled advantage in oxygen-rich environments and setting the stage for multicellularity. Consequently, attempting to categorize these early organisms using modern Linnaean taxonomy often forces contiguous evolutionary grades into discrete clades, obscuring the transitional nature of the lineages. All of this underscores the profound complexity and interconnectedness of Earth's biological history, where geological, atmospheric, and genetic factors intertwine to drive the relentless engine of evolution (Williams, 2022).\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Primary Mechanism: The integration of somatic nervous system relies heavily on protein- protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi-permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([6]),
          rects: const Value([ProjectRect(left: 53.7019, top: 95.4499, right: 721.734, bottom: 178.6339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **Mechanism:**?"),
          backText: const Value("According to the source on page 6: \"• Primary Mechanism: The integration of somatic nervous system relies heavily on protein- protein interactions, ATP-dependent phosphorylation, and concentration gradients across the semi-permeable lipid bilayer. These processes are extremely sensitive to temperature and pH variations.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. The Central Dogma"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 394.758, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 2."),
          backText: const Value("1. The Central Dogma"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Optimized for data extraction testing"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 253.1082, top: 373.1803, right: 539.0202, bottom: 391.1623)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Optimized for data extraction testing"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 53.7019, top: 270.2499, right: 726.934, bottom: 331.0339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **mutations**?"),
          backText: const Value("According to the source on page 3: \"• Pathological Correlates: Dysregulation in this specific pathway often presents clinically as a spectrum of metabolic or neurological disorders. Genetic mutations affecting the transcription factors responsible for expressing these proteins result in truncated or misfolded polypeptides.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Aortic Pres."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 634.77, top: 134.784, right: 698.9103, bottom: 151.116)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 3."),
          backText: const Value("Aortic Pres."),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Delayed (Days)"),
          sourceIds: Value([sourceidImmunologyBasicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 504.9308, top: 195.9998, right: 626.9888, bottom: 213.9818)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in immunology_basics-v1.pdf page 2."),
          backText: const Value("Delayed (Days)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("2. The Electrical Conduction System"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 631.432, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 4."),
          backText: const Value("2. The Electrical Conduction System"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("[Source: Unformatted Bio Text Dump, Vol 3]"),
          sourceIds: Value([sourceidBioWallOfTextV1Pdf]),
          pageNumbers: const Value([4]),
          rects: const Value([ProjectRect(left: 444.6123, top: 569.4176, right: 747.0123, bottom: 585.7496)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in bio_wall_of_text-v1.pdf page 4."),
          backText: const Value("[Source: Unformatted Bio Text Dump, Vol 3]"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Tertiary (10 J)"),
          sourceIds: Value([sourceidPopulationEcologyV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 356.0222, top: 261.9338, right: 435.9779, bottom: 278.2658)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in population_ecology-v1.pdf page 3."),
          backText: const Value("Tertiary (10 J)"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("Molecular Genetics"),
          sourceIds: Value([sourceidMolecularGeneticsV1Pdf]),
          pageNumbers: const Value([1]),
          rects: const Value([ProjectRect(left: 155.0251, top: 252.1802, right: 638.5411, bottom: 306.1262)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in molecular_genetics-v1.pdf page 1."),
          backText: const Value("Molecular Genetics"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("1. Hemodynamics & Blood Pressure"),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([2]),
          rects: const Value([ProjectRect(left: 45.0, top: 44.9999, right: 629.46, bottom: 78.9659)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cardiovascular_dynamics-v1.pdf page 2."),
          backText: const Value("1. Hemodynamics & Blood Pressure"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("alpha-KG"),
          sourceIds: Value([sourceidCellularRespirationV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 451.7307, top: 321.3788, right: 490.269, bottom: 333.6368)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("Identify the key concept described in cellular_respiration-v1.pdf page 3."),
          backText: const Value("alpha-KG"),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Diastolic Pressure: Lowest pressure at the resting phase of the cardiac cycle."),
          sourceIds: Value([sourceidCardiovascularDynamicsV1Pdf]),
          pageNumbers: const Value([3]),
          rects: const Value([ProjectRect(left: 54.9404, top: 108.5002, right: 380.84, bottom: 188.4802)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **cardiovascular_dynamics-v1.pdf**, what is the significance of **Lowest**?"),
          backText: const Value("According to the source on page 3: \"• Diastolic Pressure: Lowest pressure at the resting phase of the cardiac cycle.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    {
      final citationId = uuid.v4();
      await db.into(db.citationItems).insert(
        CitationItemsCompanion(
          id: Value(citationId),
          citedText: const Value("• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium."),
          sourceIds: Value([sourceidBioHeavyBulletsV1Pdf]),
          pageNumbers: const Value([18]),
          rects: const Value([ProjectRect(left: 53.7019, top: 445.0499, right: 737.3307, bottom: 505.8339)]),
        ),
      );
      await db.into(db.cardItems).insert(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck4Id),
          citationId: Value(citationId),
          frontText: const Value("In the context of **bio_heavy_bullets-v1.pdf**, what is the significance of **yields**?"),
          backText: const Value("According to the source on page 18: \"• Energy Requirements: This is a highly endergonic process. The hydrolysis of ATP to ADP and inorganic phosphate (Pi) yields approximately -7.3 kcal/mol of free energy, which is coupled to this reaction to drive it forward against thermodynamic equilibrium.\""),
          spacedState: const Value(0),
          spacedStability: const Value(0.0),
          spacedDifficulty: const Value(0.0),
          spacedDue: Value(DateTime.now()),
        ),
      );
    }
    AppLogger.info('Biology Citation Seeding COMPLETED.', tag: 'BiologySeeder');
  }
}
