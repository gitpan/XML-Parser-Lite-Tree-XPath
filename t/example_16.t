use Test::Simple tests => 7;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example16.html

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

@nodes = $xpath->select_nodes('/aaa/xxx/preceding-sibling::*');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');

@nodes = $xpath->select_nodes('//ccc/preceding-sibling::*');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'xxx' && $nodes[1]->{attributes}->{id} eq 'x1');
ok($nodes[2]->{name} eq 'eee' && $nodes[2]->{attributes}->{id} eq 'e1');
ok($nodes[3]->{name} eq 'ddd' && $nodes[3]->{attributes}->{id} eq 'd3');

#print "node: $_->{name} : $_->{order}\n" for @nodes;

