use Test::Simple tests => 16;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example17.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1">
			<ccc id="c1" />
			<zzz id="z1">
				<ddd id="d1" />
				<ddd id="d2">
					<eee id="e1" />
				</ddd>
			</zzz>
			<fff id="f1">
				<ggg id="g1" />
			</fff>
		</bbb>
		<xxx id="x1">
			<ddd id="d3">
				<eee id="e2" />
				<ddd id="d4" />
				<ccc id="c2" />
				<fff id="f2" />
				<fff id="f3">
					<ggg id="g2" />
				</fff>
			</ddd>
		</xxx>
		<ccc id="c3">
			<ddd id="d5" />
		</ccc>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa/xxx/following::*');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'ccc' && $nodes[0]->{attributes}->{id} eq 'c3');
ok($nodes[1]->{name} eq 'ddd' && $nodes[1]->{attributes}->{id} eq 'd5');

@nodes = $xpath->select_nodes('//zzz/following::*');
ok(scalar(@nodes) == 12);
ok($nodes[0]->{name} eq 'fff' && $nodes[0]->{attributes}->{id} eq 'f1');
ok($nodes[1]->{name} eq 'ggg' && $nodes[1]->{attributes}->{id} eq 'g1');
ok($nodes[2]->{name} eq 'xxx' && $nodes[2]->{attributes}->{id} eq 'x1');
ok($nodes[3]->{name} eq 'ddd' && $nodes[3]->{attributes}->{id} eq 'd3');
ok($nodes[4]->{name} eq 'eee' && $nodes[4]->{attributes}->{id} eq 'e2');
ok($nodes[5]->{name} eq 'ddd' && $nodes[5]->{attributes}->{id} eq 'd4');
ok($nodes[6]->{name} eq 'ccc' && $nodes[6]->{attributes}->{id} eq 'c2');
ok($nodes[7]->{name} eq 'fff' && $nodes[7]->{attributes}->{id} eq 'f2');
ok($nodes[8]->{name} eq 'fff' && $nodes[8]->{attributes}->{id} eq 'f3');
ok($nodes[9]->{name} eq 'ggg' && $nodes[9]->{attributes}->{id} eq 'g2');
ok($nodes[10]->{name} eq 'ccc' && $nodes[10]->{attributes}->{id} eq 'c3');
ok($nodes[11]->{name} eq 'ddd' && $nodes[11]->{attributes}->{id} eq 'd5');

#print "node: $_->{name} : $_->{order}\n" for @nodes;

