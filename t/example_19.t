use Test::Simple tests => 14;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example19.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1">
			<ccc id="c1" />
			<zzz id="z1">
				<ddd id="d1" />
			</zzz>
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

@nodes = $xpath->select_nodes('/aaa/xxx/descendant-or-self::*');
ok(scalar(@nodes) == 8);
ok($nodes[0]->{name} eq 'xxx' && $nodes[0]->{attributes}->{id} eq 'x1');
ok($nodes[1]->{name} eq 'ddd' && $nodes[1]->{attributes}->{id} eq 'd2');
ok($nodes[2]->{name} eq 'eee' && $nodes[2]->{attributes}->{id} eq 'e1');
ok($nodes[3]->{name} eq 'ddd' && $nodes[3]->{attributes}->{id} eq 'd3');
ok($nodes[4]->{name} eq 'ccc' && $nodes[4]->{attributes}->{id} eq 'c2');
ok($nodes[5]->{name} eq 'fff' && $nodes[5]->{attributes}->{id} eq 'f1');
ok($nodes[6]->{name} eq 'fff' && $nodes[6]->{attributes}->{id} eq 'f2');
ok($nodes[7]->{name} eq 'ggg' && $nodes[7]->{attributes}->{id} eq 'g1');

@nodes = $xpath->select_nodes('//ccc/descendant-or-self::*');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'ccc' && $nodes[0]->{attributes}->{id} eq 'c1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c2');
ok($nodes[2]->{name} eq 'ccc' && $nodes[2]->{attributes}->{id} eq 'c3');
ok($nodes[3]->{name} eq 'ddd' && $nodes[3]->{attributes}->{id} eq 'd4');


#print "node: $_->{name} : $_->{order}\n" for @nodes;

