#BEGIN { require 5.006 } # ‘our’ is used in the tests

use ExtUtils::MakeMaker;

%prq = (
# WildCardQuery:
	base                         => 0,
#	KSx::Search::RegexpTermQuery => 0,
# RegexpTermQuery:
         base     => 0,
         Hash::Util::FieldHash::Compat        => 0,
         KinoSearch::Highlight::HighlightSpan => 0,
         KinoSearch::Search::Scorer           => 0,
         KinoSearch::Search::Tally            => 0,
         KinoSearch::Search::Weight           => 0,
         strict                               => 0,
         warnings                             => 0,

# for testing:
	base                                       => 0,
	KinoSearch::Analysis::Tokenizer            => 0,
	KinoSearch::InvIndex                       => 0,
	KinoSearch::InvIndexer                     => 0,
	KinoSearch::Schema                         => 0,
	KinoSearch::Searcher                       => 0,
	KinoSearch::Store::RAMFolder               => 0,
	strict                                     => 0,
	Test::More                                 => 0,
	utf8                                       => 0,
	warnings                                   => 0,
);

eval{require KinoSearch::Search::Scorer}
	&& KinoSearch::Search::Scorer->can('get_doc_num')
or $prq{KinoSearch} = 9999, print << ;
This module requires the development version of KinoSearch, revision
3096 or later, which can be obtained from the following URL:
http://www.rectangular.com/svn/kinosearch/trunk


WriteMakefile(
    NAME                => 'KSx::Search::WildCardQuery',
    AUTHOR              => 'Father Chrysostomos <sprout [hat] cpan . org>',
    VERSION_FROM        => 'lib/KSx/Search/WildCardQuery.pm',
    ABSTRACT_FROM       => 'lib/KSx/Search/WildCardQuery.pm',
    PL_FILES            => {},
    PREREQ_PM           => \%prq,
    dist               => { COMPRESS => 'gzip -9f', SUFFIX => 'gz',
                            TAR => 'COPYFILE_DISABLE=1 tar' },
    clean              => { FILES => 'KSx-Search-WildCardQuery-*' },
);
