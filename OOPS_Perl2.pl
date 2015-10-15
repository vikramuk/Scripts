#!/usr/bin/perl

use Person;

$object = new Person( "Mohammad", "Saleem", 23234345);
# Get first name which is set using constructor.
$firstName = $object->getFirstName();

print "Before Setting First Name is : $firstName\n";

# Now Set first name using helper function.
$object->setFirstName( "Mohd." );

# Now get first name set by helper function.
$firstName = $object->getFirstName();
print "Before Setting First Name is : $firstName\n";



package Person;
sub new
{
    my $class = shift;
    my $self = {
        _firstName => shift,
        _lastName  => shift,
        _ssn       => shift,
    };
    # Print all the values just for clarification.
    print "First Name is $self->{_firstName}\n";
    print "Last Name is $self->{_lastName}\n";
    print "SSN is $self->{_ssn}\n";
    bless $self, $class;
    return $self;
}

First Name is Mohammad
Last Name is Saleem
SSN is 23234345
Before Setting First Name is : Mohammad
Before Setting First Name is : Mohd.

 
#!/usr/bin/perl
package Employee;
use Person;
use strict;
our @ISA = qw(Person);



#!/usr/bin/perl

use Person;

$object = new Person( "Mohammad", "Saleem", 23234345);
# Get first name which is set using constructor.
$firstName = $object->getFirstName();

print "Before Setting First Name is : $firstName\n";

# Now Set first name using helper function.
$object->setFirstName( "Mohd." );

# Now get first name set by helper function.
$firstName = $object->getFirstName();
print "Before Setting First Name is : $firstName\n";


package Person;
sub new
{
    my $class = shift;
    my $self = {
        _firstName => shift,
        _lastName  => shift,
        _ssn       => shift,
    };
    # Print all the values just for clarification.
    print "First Name is $self->{_firstName}\n";
    print "Last Name is $self->{_lastName}\n";
    print "SSN is $self->{_ssn}\n";
    bless $self, $class;
    return $self;
}

First Name is Mohammad
Last Name is Saleem
SSN is 23234345
Before Setting First Name is : Mohammad
Before Setting First Name is : Mohd.


#!/usr/bin/perl

package Employee;
use Person;
use strict;
our @ISA = qw(Person);



#!/usr/bin/perl

package Employee;
use Person;
use strict;
our @ISA = qw(Person);    # inherits from Person

# Override constructor
sub new {
    my ($class) = @_;

    # Call the constructor of the parent class, Person.
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3] );
    # Add few more attributes
    $self->{_id}   = undef;
    $self->{_title} = undef;
    bless $self, $class;
    return $self;
}

# Override helper function
sub getFirstName {
    my( $self ) = @_;
    # This is child class function.
    print "This is child class helper function\n";
    return $self->{_firstName};
}

# Add more methods
sub setLastName{
    my ( $self, $lastName ) = @_;
    $self->{_lastName} = $lastName if defined($lastName);
    return $self->{_lastName};
}

sub getLastName {
    my( $self ) = @_;
    return $self->{_lastName};
}

   # Call the constructor of the parent class, Person.
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3] );


 
package MyClass;
...
sub DESTROY
{
    print "MyClass::DESTROY called\n";
}

#!/usr/bin/perl
@list = (1,"Test", 0, "foo", 20 );
@has_digit = grep ( /\d/, @list );
print "@has_digit\n";
 
Cd  a
find . -type f -print | xargs grep -il "name"



#!/usr/bin/perl -w

@myNames = ('jacob', 'alexander', 'ethan', 'andrew');
@ucNames = map(ucfirst, @myNames);

foreach $key ( @ucNames ){
 print "$key\n";
}


/* Assignment:  */
my @a = (1, undef, 2);
 my $sum = 0;
 foreach my $val (@a) 
 { eval 
 { $sum += foo($val); }; 
 if ($@) { $sum += 100; } } 
 print "$sum\n"; 
 
 sub foo 
 { my $val = shift;
 die "I don't like undefs" 
 unless defined $val;
 return $val + $val; }
  
 /*  */
 package A; 
sub NEW { bless {}, shift } 
sub AUTOLOAD { print ref(shift) } 

package main; 
my $obj = NEW A; $obj->foo();
 
 /*  */
  package A; 
 sub new { return bless {}, shift; } 
 sub DESTROY { print ref(shift); } 
 
 package B; 
 use base 'A'; 
 sub DESTROY { my $self = shift; print ref($self); 
 bless $self, 'A'; } 
 
 
 package main; my $obj = B->new();
