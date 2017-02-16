# Stanford CoreNLP [![Build Status](https://secure.travis-ci.org/louismullie/stanford-core-nlp.png)](http://travis-ci.org/louismullie/stanford-core-nlp) [![Awesome RubyNLP](https://img.shields.io/badge/Awesome-RubyNLP-brightgreen.svg)](https://github.com/arbox/nlp-with-ruby) [![Gem](https://img.shields.io/gem/v/stanford-core-nlp.svg)](https://rubygems.org/gems/stanford-core-nlp)

> Ruby bindings for the [Stanford CoreNLP Toolchain](http://stanfordnlp.github.io/CoreNLP/).

This gem provides high-level Ruby bindings to the
[Stanford CoreNLP](http://stanfordnlp.github.io/CoreNLP/) package,
a set natural language processing tools for tokenization, sentence segmentation,
part-of-speech tagging, lemmatization, and parsing of English, French and German.
The package also provides named entity recognition and coreference resolution
for English.

This gem is compatible with Ruby `2.3` and `2.4` as well as JRuby `1.7` and `9`.
Older Ruby version should work as well.

You need Java 8 for the latest CoreNLP version (since 3.5.0, 2014-10-31),
earlier versions are tested on both Java 6 and Java 7.

The version schema has been changed to reflect the development
of Stanford CoreNLP itself. We'll release a gem for every new version from Stanford.

## Supported Human Languages

We strive to support all languages Stanford CoreNLP
[can](http://stanfordnlp.github.io/CoreNLP/human-languages.html) work with.

<table>
  <thead>
    <tr>
      <th>Annotator</th>
      <th style="text-align: center">ar</th>
      <th style="text-align: center">zh</th>
      <th style="text-align: center">en</th>
      <th style="text-align: center">fr</th>
      <th style="text-align: center">de</th>
      <th style="text-align: center">es</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Tokenize / Segment</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
    </tr>
    <tr>
      <td>Sentence Split</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
    </tr>
    <tr>
      <td>Part of Speech</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
    </tr>
    <tr>
      <td>Lemma</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
    </tr>
    <tr>
      <td>Named Entities</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
    </tr>
    <tr>
      <td>Constituency Parsing</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
    </tr>
    <tr>
      <td>Dependency Parsing</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
    </tr>
    <tr>
      <td>Sentiment Analysis</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
    </tr>
    <tr>
      <td>Mention Detection</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
    </tr>
    <tr>
      <td>Coreference</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
    </tr>
    <tr>
      <td>Open IE</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center">✔</td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
      <td style="text-align: center"> </td>
    </tr>
  </tbody>
</table>

## Installation

First, install the gem: `gem install stanford-core-nlp`.
Then, download the Stanford Core NLP JAR and model files:
[Stanford CoreNLP](http://nlp.stanford.edu/software/stanford-postagger-full-2014-10-26.zip)

Place the contents of the extracted archive inside the `/bin/` folder of
the stanford-core-nlp gem (e.g. [...]/gems/stanford-core-nlp-0.x/bin/).

## Configuration

You may want to set some optional configuration options. Here are some examples:

```ruby
# Set an alternative path to look for the JAR files
# Default is gem's bin folder.
StanfordCoreNLP.jar_path = '/path_to_jars/'

# Set an alternative path to look for the model files
# Default is gem's bin folder.
StanfordCoreNLP.model_path = '/path_to_models/'

# Pass some alternative arguments to the Java VM.
# Default is ['-Xms512M', '-Xmx1024M'] (be prepared
# to take a coffee break).
StanfordCoreNLP.jvm_args = ['-option1', '-option2']

# Redirect VM output to log.txt
StanfordCoreNLP.log_file = 'log.txt'

# Change a specific model file.
StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
```

## Using the gem

```ruby
# Use the model files for a different language than English.
StanfordCoreNLP.use :french # or :german

text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
   'Berlin to discuss a new austerity package. Sarkozy ' +
   'looked pleased, but Merkel was dismayed.'

pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
text = StanfordCoreNLP::Annotation.new(text)
pipeline.annotate(text)

text.get(:sentences).each do |sentence|
  # Syntatical dependencies
  puts sentence.get(:basic_dependencies).to_s
  sentence.get(:tokens).each do |token|
    # Default annotations for all tokens
    puts token.get(:value).to_s
    puts token.get(:original_text).to_s
    puts token.get(:character_offset_begin).to_s
    puts token.get(:character_offset_end).to_s
    # POS returned by the tagger
    puts token.get(:part_of_speech).to_s
    # Lemma (base form of the token)
    puts token.get(:lemma).to_s
    # Named entity tag
    puts token.get(:named_entity_tag).to_s
    # Coreference
    puts token.get(:coref_cluster_id).to_s
    # Also of interest: coref, coref_chain,
    # coref_cluster, coref_dest, coref_graph.
  end
end
```

> Important: You need to load the StanfordCoreNLP pipeline before using the StanfordCoreNLP::Annotation class.

The Ruby symbol (e.g. `:named_entity_tag`) corresponding to a Java annotation
class is the `snake_case` of the class name, with 'Annotation' at the end removed.
For example, `NamedEntityTagAnnotation` translates to `:named_entity_tag`,
`PartOfSpeechAnnotation` to `:part_of_speech`, etc.

A good reference for names of annotations are the Stanford Javadocs
for [CoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/ling/CoreAnnotations.html), [CoreCorefAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/dcoref/CorefCoreAnnotations.html), and [TreeCoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/TreeCoreAnnotations.html). For a full list of all possible annotations, see the `config.rb` file inside the gem.


**Loading specific classes**

You may want to load additional Java classes (including any class from the Stanford NLP packages). The gem provides an API for this:

```ruby
# Default base class is edu.stanford.nlp.pipeline.
StanfordCoreNLP.load_class('PTBTokenizerAnnotator')
puts StanfordCoreNLP::PTBTokenizerAnnotator.inspect
  # => #<Rjb::Edu_stanford_nlp_pipeline_PTBTokenizerAnnotator>

# Here, we specify another base class.
StanfordCoreNLP.load_class('MaxentTagger', 'edu.stanford.nlp.tagger')
puts StanfordCoreNLP::MaxentTagger.inspect
  # => <Rjb::Edu_stanford_nlp_tagger_maxent_MaxentTagger:0x007f88491e2020>
```

## List of annotator classes

Here is a full list of annotator classes provided by the Stanford Core NLP package.
You can load these classes individually using `StanfordCoreNLP.load_class`
(see above). Once this is done, you can use them like you would from
a Java program. Refer to the Java documentation for a list of functions provided
by each of these classes.

* PTBTokenizerAnnotator - tokenizes the text following Penn Treebank conventions.
* WordToSentenceAnnotator - splits a sequence of words into a sequence of sentences.
* POSTaggerAnnotator - annotates the text with part-of-speech tags.
* MorphaAnnotator - morphological normalizer (generates lemmas).
* NERAnnotator - annotates the text with named-entity labels.
* NERCombinerAnnotator - combines several NER models.
* TrueCaseAnnotator - detects the true case of words in free text.
* ParserAnnotator - generates constituent and dependency trees.
* NumberAnnotator - recognizes numerical entities such as numbers, money, times, and dates.
* TimeWordAnnotator - recognizes common temporal expressions, such as "teatime".
* QuantifiableEntityNormalizingAnnotator - normalizes the content of all numerical entities.
* SRLAnnotator - annotates predicates and their semantic roles.
* DeterministicCorefAnnotator - implements anaphora resolution using a deterministic model.
* NFLAnnotator - implements entity and relation mention extraction for the NFL domain.

## List of model files

Here is a full list of the default models for the Stanford Core NLP pipeline. You can change these models individually using `StanfordCoreNLP.set_model` (see above).

* 'pos.model' - 'english-left3words-distsim.tagger'
* 'ner.model' - 'all.3class.distsim.crf.ser.gz'
* 'parse.model' - 'englishPCFG.ser.gz'
* 'dcoref.demonym' - 'demonyms.txt'
* 'dcoref.animate' - 'animate.unigrams.txt'
* 'dcoref.female' - 'female.unigrams.txt'
* 'dcoref.inanimate' - 'inanimate.unigrams.txt'
* 'dcoref.male' - 'male.unigrams.txt'
* 'dcoref.neutral' - 'neutral.unigrams.txt'
* 'dcoref.plural' - 'plural.unigrams.txt'
* 'dcoref.singular' - 'singular.unigrams.txt'
* 'dcoref.states' - 'state-abbreviations.txt'
* 'dcoref.extra.gender' - 'namegender.combine.txt'

## Testing

To run the specs for each language (after copying the JARs into the `bin` folder):

``` shell
rake spec[english]
rake spec[german]
rake spec[french]
```

## Using the latest version of the Stanford CoreNLP

Using the latest version of the Stanford CoreNLP (version 3.5.0 as of 31/10/2014) requires some additional manual steps:

* Download [Stanford CoreNLP version 3.5.0](http://nlp.stanford.edu/software/stanford-corenlp-full-2014-10-31.zip) from http://nlp.stanford.edu/.
* Place the contents of the extracted archive inside the /bin/ folder of the stanford-core-nlp gem (e.g. [...]/gems/stanford-core-nlp-0.x/bin/) or inside the directory location configured by setting StanfordCoreNLP.jar_path.
* Download [the full Stanford Tagger version 3.5.0](http://nlp.stanford.edu/software/stanford-postagger-full-2014-10-26.zip) from http://nlp.stanford.edu/.
* Make a directory named 'taggers' inside the /bin/ folder of the stanford-core-nlp gem (e.g. [...]/gems/stanford-core-nlp-0.x/bin/) or inside the directory configured by setting StanfordCoreNLP.jar_path.
* Place the contents of the extracted archive inside taggers directory.
* Download [the bridge.jar file](https://github.com/louismullie/stanford-core-nlp/blob/master/bin/bridge.jar?raw=true) from https://github.com/louismullie/stanford-core-nlp.
* Place the downloaded bridge.jar file inside the /bin/ folder of the stanford-core-nlp gem (e.g. [...]/gems/stanford-core-nlp-0.x/bin/) or inside the directory configured by setting StanfordCoreNLP.jar_path.
* Configure your setup (for English) as follows:
```ruby
StanfordCoreNLP.use :english
StanfordCoreNLP.model_files = {}
StanfordCoreNLP.default_jars = [
  'joda-time.jar',
  'xom.jar',
  'stanford-corenlp-3.5.0.jar',
  'stanford-corenlp-3.5.0-models.jar',
  'jollyday.jar',
  'bridge.jar'
]
```
Or configure your setup (for French) as follows:
```ruby
StanfordCoreNLP.use :french
StanfordCoreNLP.model_files = {}
StanfordCoreNLP.set_model('pos.model', 'french.tagger')
StanfordCoreNLP.default_jars = [
  'joda-time.jar',
  'xom.jar',
  'stanford-corenlp-3.5.0.jar',
  'stanford-corenlp-3.5.0-models.jar',
  'jollyday.jar',
  'bridge.jar'
]
```
Or configure your setup (for German) as follows:
```ruby
StanfordCoreNLP.use :german
StanfordCoreNLP.model_files = {}
StanfordCoreNLP.set_model('pos.model', 'german-fast.tagger')
StanfordCoreNLP.default_jars = [
  'joda-time.jar',
  'xom.jar',
  'stanford-corenlp-3.5.0.jar',
  'stanford-corenlp-3.5.0-models.jar',
  'jollyday.jar',
  'bridge.jar'
]
```

## Contributing

We are very glad to see you in this section and highly appreciate any help!

If you want to contribute please agree that your work will be published
under the terms of the `GPL v.3.0` license.

Some of the open tasks for contributors are listed on the
[issues](https://github.com/louismullie/stanford-core-nlp/issues) page.
You may want to start there.

Then feel free to fork the code and send us a pull request.

## License

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0) `stanford-core-nlp` by [Louis-Antoine Mullie](https://github.com/louismullie),
[Andrei Beliankou](https://github.com/arbox) and
[Contributors](https://github.com/louismullie/stanford-core-nlp/graphs/contributors).

> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.

> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.

> You should have received a copy of the GNU General Public License
> along with this program.  If not, see <http://www.gnu.org/licenses/>.

<!--- Links --->
[ruby]: https://www.ruby-lang.org/en/
