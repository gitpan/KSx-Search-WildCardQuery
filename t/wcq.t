#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use Test::More tests =>
+	1 # load
+	2 # query tests
+	1 # highlight_spans
;

use_ok 'KSx::Search::WildCardQuery'; # test 1


# ------------- Index Schema ----------- #
package MySchema;
use base qw( KinoSearch::Schema );
use KinoSearch::Analysis::Tokenizer;

our %fields = (
    content => 'text',
);

sub analyzer { KinoSearch::Analysis::Tokenizer->new }

package main;

# ------ Set up the test index ------- #

use KinoSearch::Searcher;
use KinoSearch::InvIndexer;
use KinoSearch::InvIndex;
use KinoSearch::Store::RAMFolder;

my $invindex    = KinoSearch::InvIndex->clobber(
    folder => KinoSearch::Store::RAMFolder->new,
    schema => MySchema->new,
);

my $first_doc = "dot dote dogs"
	. ' ado' x 200; # make sure do* doesn’t match ‘ado’
my $invindexer = KinoSearch::InvIndexer->new( invindex => $invindex, );
$invindexer->add_doc( { content => $_ } )
	for $first_doc,
	    "do doing",
	    'this is not matched by the query';
$invindexer->finish;

# ------ Perform the query tests ------- #

my $searcher = KinoSearch::Searcher->new( invindex => $invindex, );

my $q = new KSx::Search::WildCardQuery term => 'do*', field => 'content';
my $hits = eval{$searcher->search( query => $q )};
is $hits->total_hits, 2, 'do* matches the right docs';
my $hit = $hits->fetch_hit;
like $hit->{content}, qr/doing/, 'and they\'re in the right order';

# ------ and test highlight_spans ------- #

#warn join '-', $q->make_weight(searchable => $searcher)->highlight_spans;
is join(' ', sort
	map {
		my $start = $_->get_start_offset;
		substr($first_doc, $start, $_->get_end_offset-$start)
	} $q->make_weight(searchable => $searcher)->highlight_spans(
		searchable => $searcher,
		doc_vec    => $searcher->fetch_doc_vec(
		                  $hits->fetch_hit->get_doc_num
		              ),
		field      => 'content'
	  )
   ), 'dogs dot dote', 'highlight_spans';
