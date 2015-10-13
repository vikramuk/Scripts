my @a = (1, undef, 2); 
my $sum = 0; 
foreach my $val (@a) {
 eval { $sum += foo($val); 
 };
 if ($@) { $sum += 100; } } print "$sum\n"; 
 
 sub foo 
 { my $val = shift; 
 die "I don't like undefs" unless defined $val;
 return $val + $val; }
 
 
  package A; 
  sub NEW { bless {}, shift } 
  
  sub AUTOLOAD { print ref(shift) } 
  
  package main; 
  my $obj = NEW A; 
  $obj->foo();
  
   package A; 
   sub new { return bless {}, shift; }
   sub DESTROY { print ref(shift); } 
   
   package B; 
   use base 'A'; 
   sub DESTROY { 
   my $self = shift; 
   print ref($self); 
	bless $self, 'A'; } 
   
   
   package main;
   my $obj = B->new();*
