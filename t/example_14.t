use Test::Simple tests => 11;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example14.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1">
			<ddd id="d1">
				<ccc id="c1">
					<ddd id="d2" />
					<eee id="e1" />
				</ccc>
			</ddd>
		</bbb>
		<ccc id="c2">
			<ddd id="d3">
				<eee id="e2">
					<ddd id="d4">
						<fff id="f1" />
					</ddd>
				</eee>
			</ddd>
		</ccc>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa/bbb/ddd/ccc/eee/ancestor::*');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b1');
ok($nodes[2]->{name} eq 'ddd' && $nodes[2]->{attributes}->{id} eq 'd1');
ok($nodes[3]->{name} eq 'ccc' && $nodes[3]->{attributes}->{id} eq 'c1');

@nodes = $xpath->select_nodes('//fff/ancestor::*');
ok(scalar(@nodes) == 5);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c2');
ok($nodes[2]->{name} eq 'ddd' && $nodes[2]->{attributes}->{id} eq 'd3');
ok($nodes[3]->{name} eq 'eee' && $nodes[3]->{attributes}->{id} eq 'e2');
ok($nodes[4]->{name} eq 'ddd' && $nodes[4]->{attributes}->{id} eq 'd4');
