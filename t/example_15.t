use Test::Simple tests => 7;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example15.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1">
			<ccc id="c1" />
			<ddd id="d1" />
		</bbb>
		<xxx id="x1">
			<ddd id="d2">
				<eee id="e1" />
				<ddd id="d3" />
				<ccc id="c2" />
				<fff id="f1" />
				<fff id="f2">
					<ggg id="g1" />
				</fff>
			</ddd>
		</xxx>
		<ccc id="c3">
			<ddd id="d4" />
		</ccc>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa/bbb/following-sibling::*');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'xxx' && $nodes[0]->{attributes}->{id} eq 'x1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c3');

@nodes = $xpath->select_nodes('//ccc/following-sibling::*');
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'ddd' && $nodes[0]->{attributes}->{id} eq 'd1');
ok($nodes[1]->{name} eq 'fff' && $nodes[1]->{attributes}->{id} eq 'f1');
ok($nodes[2]->{name} eq 'fff' && $nodes[2]->{attributes}->{id} eq 'f2');

#print "node: $_->{name} : $_->{order}\n" for @nodes;

