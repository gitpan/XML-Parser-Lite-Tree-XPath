package XML::Parser::Lite::Tree::XPath;

use strict;
use warnings;
use XML::Parser::Lite::Tree;
use Data::Dumper;

our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $self = bless {}, $class;
	$self->{tree} = shift;
	return $self;
}

sub set_tree {
	my ($self, $tree) = @_;
	$self->{tree} = $tree;
}

sub select_nodes {
	my ($self, $xpath) = @_;

	die "Only absolute XPaths are supported." if $xpath !~ m!^/!;

	my @tokens = split m!/!, $xpath;
	my @tags = ( $self->{tree} );

	shift @tokens;
	my $no_expand = 0;

	if ( $xpath =~ m!^//(.*)$! ){

		@tokens = split m!/!, $1;
		@tags = $self->fetch_all( ( $self->{tree}->{children} ) );
		$no_expand = 1;
	}

	for my $token(@tokens){
		# apply the rule to the current tags, setting 

		@tags = $self->expand_tags(\@tags) unless $no_expand;
		@tags = $self->apply_rule($token, \@tags);

		$no_expand = 0;
	}

	return @tags;
}

sub expand_tags {
	my ($self, $tags) = @_;

	my @out;

	for my $tag(@{$tags}){
		for my $child(@{$tag->{children}}){
			push @out, $child;
		}
	}

	return @out;
}


sub apply_rule {
	my ($self, $rule, $tags) = @_;

	my @out;

	# break off subrules

	my @subrules;
	while($rule =~ m!\[(.*)\]!){
		push @subrules, $1;
		$rule =~ s!\[(.*)\]!!;
	}


	# process main part of rule

	if ($rule eq '*'){
		@out = @{$tags};

	}elsif ($rule eq 'text()'){
		for my $tag(@{$tags}){
			if (($tag->{'type'} eq 'data')){
				push @out, $tag;
			}
		}

	}elsif ($rule eq 'node()'){
		@out = @{$tags};

	}else{
		for my $tag(@{$tags}){
			if (($tag->{'type'} eq 'tag') && ($tag->{'name'} eq $rule)){
				push @out, $tag;
			}
		}
	}

	# process subrules in order

	for my $rule(@subrules){

		if ($rule =~ m!^\d+$!){
			@out = ($out[$rule-1]);

		}elsif ($rule eq 'last()'){
			@out = ($out[-1]);

		}elsif ( $rule =~ m!^@([a-z]+)$!i ){

			my $attr = $1;

			@out = grep{
				defined $_->{attributes}->{$attr};
			}@out;

		}elsif ( $rule =~ m#^@([a-z]+)(=|!=|<|<=|>|>=)(.+)$#i ){

			my $attr = $1;
			my $binop = $2;
			my $value = $3;

			$binop = 'eq' if $binop eq '=';
			$binop = 'ne' if $binop eq '!=';

			@out = grep{
				if ($_->{type} eq 'tag' && defined $_->{attributes}->{$attr}){
					eval("\$_->{attributes}->{\$attr} $binop \$value");
				}else{
					0;
				}
			}@out;

		}else{

			die("Subrule not understood: [$rule]");
		}

	}

	return @out;
}

sub fetch_all {
	my ($self, $tags) = @_;

	my @out;

	for my $tag(@{$tags}){
		push @out, $tag;

		if ($tag->{type} eq 'tag'){
			map{
				push @out, $_;
			}$self->fetch_all($tag->{children});
		}
	}

	return @out;
}


1;
__END__

=head1 NAME

XML::Parser::Lite::Tree::XPath - XPath access to XML::Parser::Lite::Tree trees

=head1 SYNOPSIS

  use XML::Parser::Lite::Tree;
  use XML::Parser::Lite::Tree::XPath;

  my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

  my @nodes = $xpath->select_nodes('/photoset/photos');


=head1 DESCRIPTION

This module offers limited XPath functionality for C<XML::Parser::Lite::Tree> objects. 
The following portions of XPath are supported:

  /foo/bar/baz			exact node names
  /foo/*/*			wildcard node names
  /foo/text()			'text()' function (nodes with type=text)
  /foo/nodes()			same as '*'
  /foo[1]			numeric subrules
  /foo[last()]			'last()' subrule
  /foo[@bar]			attribute existance
  /foo[@bar=2]			attribute testing (with ops =, !=, >, <, >=, <=)
  //foo				self-or-descendant searches

Subrules can be chained together and are processed left to right, eg:

  /foo[3][@bar][@baz="quux"]
  /foo[last()]/bar[@bax>10]

Things which aren't supported but might be later:

  /foo[@bar and @baz]		just use /foo[@bar][@baz]
  /foo[position()<6]		'position()' isn't supported and neither are non-attribute expressions

Things which aren't supported:

  /child::foo[position()=1]	axis tests
  ../foo/bar			relative paths
  /foo[@foo<1 or @bar>3]	boolean operators ('and' can be made into chained subrules)


=head2 METHODS

=over 4

=item C<new($tree)>

Returns an C<XML::Parser::Lite::Tree::XPath> object for the given tree.

=item C<set_tree($tree)>

Sets the tree for the object.

=item C<select_nodes($xpath)>

Returns an array of nodes for the gtiven XPath.

=back

=head1 AUTHOR

Copyright (C) 2004, Cal Henderson, E<lt>cal@iamcal.comE<gt>


=head1 SEE ALSO

L<XML::Parser::Lite>
L<XML::Parser::Lite::Tree>
L<http://www.w3.org/TR/xpath>


=cut
