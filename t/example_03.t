use Test::Simple tests => 29;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example3.html

my $xml = q!
	<aaa id="a1">
		<xxx id="x1">
			<ddd id="d1">
				<bbb id="b1" />
				<bbb id="b2" />
				<eee id="e1" />
				<fff id="f1" />
			</ddd>
		</xxx>
		<ccc id="c1">
			<ddd id="d2">
				<bbb id="b3" />
				<bbb id="b4" />
				<eee id="e2" />
				<fff id="f2" />
			</ddd>
		</ccc>
		<ccc id="c2">
			<bbb id="b5">
				<bbb id="b6">
					<bbb id="b7" />
				</bbb>
			</bbb>
		</ccc>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa/ccc/ddd/*');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b3');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b4');
ok($nodes[2]->{name} eq 'eee' && $nodes[2]->{attributes}->{id} eq 'e2');
ok($nodes[3]->{name} eq 'fff' && $nodes[3]->{attributes}->{id} eq 'f2');

@nodes = $xpath->select_nodes('/*/*/*/bbb');
ok(scalar(@nodes) == 5);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b2');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b3');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b4');
ok($nodes[4]->{name} eq 'bbb' && $nodes[4]->{attributes}->{id} eq 'b6');

@nodes = $xpath->select_nodes('//*');
ok(scalar(@nodes) == 17);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');
ok($nodes[1]->{name} eq 'xxx' && $nodes[1]->{attributes}->{id} eq 'x1');
ok($nodes[2]->{name} eq 'ddd' && $nodes[2]->{attributes}->{id} eq 'd1');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b1');
ok($nodes[4]->{name} eq 'bbb' && $nodes[4]->{attributes}->{id} eq 'b2');
ok($nodes[5]->{name} eq 'eee' && $nodes[5]->{attributes}->{id} eq 'e1');
ok($nodes[6]->{name} eq 'fff' && $nodes[6]->{attributes}->{id} eq 'f1');
ok($nodes[7]->{name} eq 'ccc' && $nodes[7]->{attributes}->{id} eq 'c1');
ok($nodes[8]->{name} eq 'ddd' && $nodes[8]->{attributes}->{id} eq 'd2');
ok($nodes[9]->{name} eq 'bbb' && $nodes[9]->{attributes}->{id} eq 'b3');
ok($nodes[10]->{name} eq 'bbb' && $nodes[10]->{attributes}->{id} eq 'b4');
ok($nodes[11]->{name} eq 'eee' && $nodes[11]->{attributes}->{id} eq 'e2');
ok($nodes[12]->{name} eq 'fff' && $nodes[12]->{attributes}->{id} eq 'f2');
ok($nodes[13]->{name} eq 'ccc' && $nodes[13]->{attributes}->{id} eq 'c2');
ok($nodes[14]->{name} eq 'bbb' && $nodes[14]->{attributes}->{id} eq 'b5');
ok($nodes[15]->{name} eq 'bbb' && $nodes[15]->{attributes}->{id} eq 'b6');
ok($nodes[16]->{name} eq 'bbb' && $nodes[16]->{attributes}->{id} eq 'b7');

print "node: $_->{name} : $_->{order}\n" for @nodes;
