module StanfordCoreNLP

  class Config
    
    # A hash of language codes in humanized,
    # 2 and 3-letter ISO639 codes.
    LanguageCodes = {
      :english => [:en, :eng, :english],
      :german => [:de, :ger, :german],
      :french => [:fr, :fre, :french]
    }

    # Folders inside the JAR path for the models.
    ModelFolders = {
      :pos => 'taggers/',
      :parse => 'grammar/',
      :ner => 'classifiers/',
      :dcoref => 'dcoref/'
    }
    
    # Tag sets used by Stanford for each language.
    TagSets = {
      :english => :penn,
      :german => :stutgart
      :french => :paris7
    }
    
    # Default models for all languages.
    Models = {
      
      :pos => {
        :english => 'english-left3words-distsim.tagger',
        :german => 'german-fast.tagger',
        :french  => 'french.tagger'
      },
      
      :parse => {
        :english => 'englishPCFG.ser.gz',
        :german => 'germanPCFG.ser.gz',
        :french  => 'frenchFactored.ser.gz'
      },
      
      :ner => {
        :english => {
          '3class' => 'all.3class.distsim.crf.ser.gz',
          '7class' => 'muc.7class.distsim.crf.ser.gz',
          'MISCclass' => 'conll.4class.distsim.crf.ser.gz'
        },
        :german => {},
        :french  => {}
      },
      
      :dcoref => {
        :english => {
          'demonym' => 'demonyms.txt',
          'animate' => 'animate.unigrams.txt',
          'female' => 'female.unigrams.txt',
          'inanimate' => 'inanimate.unigrams.txt',
          'male' => 'male.unigrams.txt',
          'neutral' => 'neutral.unigrams.txt',
          'plural' => 'plural.unigrams.txt',
          'singular' => 'singular.unigrams.txt',
          'states' => 'state-abbreviations.txt',
          'countries' => 'countries', 
          'states.provinces' => 'statesandprovinces',
          'extra.gender' => 'namegender.combine.txt'
        },
        :german => {},
        :french  => {}
      }
      
      # Models to add.

      #"truecase.model" - path towards the true-casing model; default: StanfordCoreNLPModels/truecase/noUN.ser.gz
      #"truecase.bias" - class bias of the true case model; default: INIT_UPPER:-0.7,UPPER:-0.7,O:0
      #"truecase.mixedcasefile" - path towards the mixed case file; default: StanfordCoreNLPModels/truecase/MixDisambiguation.list
      #"nfl.gazetteer" - path towards the gazetteer for the NFL domain
      #"nfl.relation.model" - path towards the NFL relation extraction model
    }

    # List of annotations by JAVA class path.
    Annotations = {

      'nlp.dcoref.CoNLL2011DocumentReader' => [
        'CorefMentionAnnotation',
        'NamedEntityAnnotation'
      ],

      'nlp.ling.CoreAnnotations' => [

        'AbbrAnnotation',
        'AbgeneAnnotation',
        'AbstrAnnotation',
        'AfterAnnotation',
        'AnswerAnnotation',
        'AnswerObjectAnnotation',
        'AntecedentAnnotation',
        'ArgDescendentAnnotation',
        'ArgumentAnnotation',
        'BagOfWordsAnnotation',
        'BeAnnotation',
        'BeforeAnnotation',
        'BeginIndexAnnotation',
        'BestCliquesAnnotation',
        'BestFullAnnotation',
        'CalendarAnnotation',
        'CategoryAnnotation',
        'CategoryFunctionalTagAnnotation',
        'CharacterOffsetBeginAnnotation',
        'CharacterOffsetEndAnnotation',
        'CharAnnotation',
        'ChineseCharAnnotation',
        'ChineseIsSegmentedAnnotation',
        'ChineseOrigSegAnnotation',
        'ChineseSegAnnotation',
        'ChunkAnnotation',
        'CoarseTagAnnotation',
        'CommonWordsAnnotation',
        'CoNLLDepAnnotation',
        'CoNLLDepParentIndexAnnotation',
        'CoNLLDepTypeAnnotation',
        'CoNLLPredicateAnnotation',
        'CoNLLSRLAnnotation',
        'ContextsAnnotation',
        'CopyAnnotation',
        'CostMagnificationAnnotation',
        'CovertIDAnnotation',
        'D2_LBeginAnnotation',
        'D2_LEndAnnotation',
        'D2_LMiddleAnnotation',
        'DayAnnotation',
        'DependentsAnnotation',
        'DictAnnotation',
        'DistSimAnnotation',
        'DoAnnotation',
        'DocDateAnnotation',
        'DocIDAnnotation',
        'DomainAnnotation',
        'EndIndexAnnotation',
        'EntityClassAnnotation',
        'EntityRuleAnnotation',
        'EntityTypeAnnotation',
        'FeaturesAnnotation',
        'FemaleGazAnnotation',
        'FirstChildAnnotation',
        'ForcedSentenceEndAnnotation',
        'FreqAnnotation',
        'GazAnnotation',
        'GazetteerAnnotation',
        'GenericTokensAnnotation',
        'GeniaAnnotation',
        'GoldAnswerAnnotation',
        'GovernorAnnotation',
        'GrandparentAnnotation',
        'HaveAnnotation',
        'HeadWordStringAnnotation',
        'HeightAnnotation',
        'IDAnnotation',
        'IDFAnnotation',
        'INAnnotation',
        'IndexAnnotation',
        'InterpretationAnnotation',
        'IsDateRangeAnnotation',
        'IsURLAnnotation',
        'LabelAnnotation',
        'LastGazAnnotation',
        'LastTaggedAnnotation',
        'LBeginAnnotation',
        'LeftChildrenNodeAnnotation',
        'LeftTermAnnotation',
        'LemmaAnnotation',
        'LEndAnnotation',
        'LengthAnnotation',
        'LMiddleAnnotation',
        'MaleGazAnnotation',
        'MarkingAnnotation',
        'MonthAnnotation',
        'MorphoCaseAnnotation',
        'MorphoGenAnnotation',
        'MorphoNumAnnotation',
        'MorphoPersAnnotation',
        'NamedEntityTagAnnotation',
        'NeighborsAnnotation',
        'NERIDAnnotation',
        'NormalizedNamedEntityTagAnnotation',
        'NotAnnotation',
        'NumericCompositeObjectAnnotation',
        'NumericCompositeTypeAnnotation',
        'NumericCompositeValueAnnotation',
        'NumericObjectAnnotation',
        'NumericTypeAnnotation',
        'NumericValueAnnotation',
        'NumerizedTokensAnnotation',
        'NumTxtSentencesAnnotation',
        'OriginalAnswerAnnotation',
        'OriginalCharAnnotation',
        'OriginalTextAnnotation',
        'ParagraphAnnotation',
        'ParagraphsAnnotation',
        'ParaPositionAnnotation',
        'ParentAnnotation',
        'PartOfSpeechAnnotation',
        'PercentAnnotation',
        'PhraseWordsAnnotation',
        'PhraseWordsTagAnnotation',
        'PolarityAnnotation',
        'PositionAnnotation',
        'PossibleAnswersAnnotation',
        'PredictedAnswerAnnotation',
        'PrevChildAnnotation',
        'PriorAnnotation',
        'ProjectedCategoryAnnotation',
        'ProtoAnnotation',
        'RoleAnnotation',
        'SectionAnnotation',
        'SemanticHeadTagAnnotation',
        'SemanticHeadWordAnnotation',
        'SemanticTagAnnotation',
        'SemanticWordAnnotation',
        'SentenceIDAnnotation',
        'SentenceIndexAnnotation',
        'SentencePositionAnnotation',
        'SentencesAnnotation',
        'ShapeAnnotation',
        'SpaceBeforeAnnotation',
        'SpanAnnotation',
        'SpeakerAnnotation',
        'SRL_ID',
        'SRLIDAnnotation',
        'SRLInstancesAnnotation',
        'StackedNamedEntityTagAnnotation',
        'StateAnnotation',
        'StemAnnotation',
        'SubcategorizationAnnotation',
        'TagLabelAnnotation',
        'TextAnnotation',
        'TokenBeginAnnotation',
        'TokenEndAnnotation',
        'TokensAnnotation',
        'TopicAnnotation',
        'TrueCaseAnnotation',
        'TrueCaseTextAnnotation',
        'TrueTagAnnotation',
        'UBlockAnnotation',
        'UnaryAnnotation',
        'UnknownAnnotation',
        'UtteranceAnnotation',
        'UTypeAnnotation',
        'ValueAnnotation',
        'VerbSenseAnnotation',
        'WebAnnotation',
        'WordFormAnnotation',
        'WordnetSynAnnotation',
        'WordPositionAnnotation',
        'WordSenseAnnotation',
        'XmlContextAnnotation',
        'XmlElementAnnotation',
        'YearAnnotation'
      ],

      'nlp.dcoref.CorefCoreAnnotations' => [

        'CorefAnnotation',
        'CorefChainAnnotation',
        'CorefClusterAnnotation',
        'CorefClusterIdAnnotation',
        'CorefDestAnnotation',
        'CorefGraphAnnotation'
      ],

      'nlp.ling.CoreLabel' => [
        'GenericAnnotation'
      ],

      'nlp.trees.EnglishGrammaticalRelations' => [
        'AbbreviationModifierGRAnnotation',
        'AdjectivalComplementGRAnnotation',
        'AdjectivalModifierGRAnnotation',
        'AdvClauseModifierGRAnnotation',
        'AdverbialModifierGRAnnotation',
        'AgentGRAnnotation',
        'AppositionalModifierGRAnnotation',
        'ArgumentGRAnnotation',
        'AttributiveGRAnnotation',
        'AuxModifierGRAnnotation',
        'AuxPassiveGRAnnotation',
        'ClausalComplementGRAnnotation',
        'ClausalPassiveSubjectGRAnnotation',
        'ClausalSubjectGRAnnotation',
        'ComplementGRAnnotation',
        'ComplementizerGRAnnotation',
        'ConjunctGRAnnotation',
        'ControllingSubjectGRAnnotation',
        'CoordinationGRAnnotation',
        'CopulaGRAnnotation',
        'DeterminerGRAnnotation',
        'DirectObjectGRAnnotation',
        'ExpletiveGRAnnotation',
        'IndirectObjectGRAnnotation',
        'InfinitivalModifierGRAnnotation',
        'MarkerGRAnnotation',
        'ModifierGRAnnotation',
        'MultiWordExpressionGRAnnotation',
        'NegationModifierGRAnnotation',
        'NominalPassiveSubjectGRAnnotation',
        'NominalSubjectGRAnnotation',
        'NounCompoundModifierGRAnnotation',
        'NpAdverbialModifierGRAnnotation',
        'NumberModifierGRAnnotation',
        'NumericModifierGRAnnotation',
        'ObjectGRAnnotation',
        'ParataxisGRAnnotation',
        'ParticipialModifierGRAnnotation',
        'PhrasalVerbParticleGRAnnotation',
        'PossessionModifierGRAnnotation',
        'PossessiveModifierGRAnnotation',
        'PreconjunctGRAnnotation',
        'PredeterminerGRAnnotation',
        'PredicateGRAnnotation',
        'PrepositionalComplementGRAnnotation',
        'PrepositionalModifierGRAnnotation',
        'PrepositionalObjectGRAnnotation',
        'PunctuationGRAnnotation',
        'PurposeClauseModifierGRAnnotation',
        'QuantifierModifierGRAnnotation',
        'ReferentGRAnnotation',
        'RelativeClauseModifierGRAnnotation',
        'RelativeGRAnnotation',
        'SemanticDependentGRAnnotation',
        'SubjectGRAnnotation',
        'TemporalModifierGRAnnotation',
        'XClausalComplementGRAnnotation'
      ],

      'nlp.trees.GrammaticalRelation' => [
        'DependentGRAnnotation',
        'GovernorGRAnnotation',
        'GrammaticalRelationAnnotation',
        'KillGRAnnotation',
        'Language',
        'RootGRAnnotation'
      ],

      'nlp.ie.machinereading.structure.MachineReadingAnnotations' => [
        'DependencyAnnotation',
        'DocumentDirectoryAnnotation',
        'DocumentIdAnnotation',
        'EntityMentionsAnnotation',
        'EventMentionsAnnotation',
        'GenderAnnotation',
        'RelationMentionsAnnotation',
        'TriggerAnnotation'
      ],

      'nlp.parser.lexparser.ParserAnnotations' => [
        'ConstraintAnnotation'
      ],

      'nlp.trees.semgraph.SemanticGraphCoreAnnotations' => [
        'BasicDependenciesAnnotation',
        'CollapsedCCProcessedDependenciesAnnotation',
        'CollapsedDependenciesAnnotation'
      ],

      'nlp.time.TimeAnnotations' => [
        'TimexAnnotation',
        'TimexAnnotations'
      ],

      'nlp.time.TimeExpression' => [
        'Annotation',
        'ChildrenAnnotation'
      ],

      'nlp.trees.TreeCoreAnnotations' => [
        'TreeHeadTagAnnotation',
        'TreeHeadWordAnnotation',
        'TreeAnnotation'
      ]
    }

    # Create a list of annotation names => paths.
    annotations_by_name = {}
    Annotations.each do |base_class, annotation_classes|
      annotation_classes.each do |annotation_class|
        annotations_by_name[annotation_class] ||= []
        annotations_by_name[annotation_class] << base_class
      end
    end

    # Hash of name => path.
    AnnotationsByName = annotations_by_name

  end
end
