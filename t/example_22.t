use Test::Simple tests => 11;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;
use overload;

# http://www.zvon.org/xxl/XPathTutorial/Output/example22.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1" />
		<bbb id="b2" />
		<bbb id="b3" />
		<bbb id="b4" />
		<bbb id="b5" />
		<bbb id="b6" />
		<bbb id="b7" />
		<bbb id="b8" />
		<ccc id="c1" />
		<ccc id="c2" />
		<ccc id="c3" />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('//bbb[position() mod 2 = 0 ]');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b2');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b4');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b6');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b8');

@nodes = $xpath->select_nodes('//bbb[ position() = floor(last-id() div 2 + 0.5) or position() = ceiling(last-id() div 2 + 0.5) ]');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b4');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b5');

@nodes = $xpath->select_nodes('//ccc[ position() = floor(last-id() div 2 + 0.5) or position() = ceiling(last-id() div 2 + 0.5) ]');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'ccc' && $nodes[0]->{attributes}->{id} eq 'c1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c2');


