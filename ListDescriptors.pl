#!/usr/bin/perl
=cut;
********************************************************************************
#Description: Check for Description and Testcase Match from 
#Singularity table
#
#Author: Vikram
#
#Revision history
********************************************************************************
#rev.no	 Name	  Date 		Description
#0.1 	Vikram 	12 July 14	Intial draft
#0.2 	Vikram 	14 July 14	List Descriptor
#0.3    Vikram  15 July 14  Rule Validator for Conditions in IRT and ST
********************************************************************************
=cut;

package Checklist;
#use strict;
#use warnings;
use File::Find qw(find);
use Test;
use IO::Handle;
use Benchmark qw/cmpthese timethese/;

use Data::Dumper;
#use List::MoreUtils qw'any';

#use Text::Table;
#my $tb = Text::Table -> new ("Variable", "Minimum","Mid NegVe","Zero","Mid PosVe","Max","OutBoundLow","OutBoundHi");

my $dir_path="";
my $filename="";
my $line ;
my $file_name_arr;

#list of Placeholders for the 7 different Parameters listed in IRT
my $list_min ;
my $list_max ;
my $list_Zero ;
my $mid_Pos ;
my $mid_Neg ;
my $OutBou_lo ;
my $OutBou_hi ;

#list of Placeholders for the 4 different Parameters listed in ST
my $NMinus;
my $NValue;
my $NPosit;
my @identlines = ();
my @identSingLine = ();
my @ListTestcases =();
my @value=();
my @var_list =();
my @objfiles =();
my @min_list=();
my @max_list=();

#enter the directory path 
print ("enter the directory path where the files are present\n"); 
$dir_path = <STDIN>;
chomp($dir_path);

#opens the directory
opendir( TD, $dir_path ) || die("cannot open directory");
#perfom for all the files in the directory.
while($filename = readdir(TD))
{
    #List all Files
    @file_name_arr = split(/\./, $filename);
	if ( $file_name_arr[1] eq "tcf" )
    {
        print "\n\n";
        
        local $buffer ;
        undef @identlines;
        undef @ListTestcases;
        undef @value;
        undef @identSingLine;
        undef @objfiles;
        undef @var_list;
        undef @min_list;
        undef @max_list;
        my $file_IRT;
        my $flag_blankIRT =false;
        my $flag_blankST =false;
        
        open(OUTFILE,">",$dirname.$filename.out) or die $!;
        # Change the Filehandle to redirect Console Output.
        STDOUT->fdopen( \*OUTFILE, 'w' ) or die $!;          
        # Parse the IRT Table
        &ListIRT;         
        if ($flag_blankIRT) #check if the Section is Present
        {
            print("VariableName|Minimum|MidNegative|Zero|MidPositive|Maximum|OutBoundLow|OutBoundHigh"."\n");
            @identlines = split ("\n", $buffer);
            local $count_irt;
            foreach my $val (@identlines)
            {
             $count_irt++;
             #print "\n"."The Values from the IRT tables for testcase# ".$count_irt." are:\n";
             $val =~ s/^\s+|\s+$//g ;   #remove spaces and Trim the values             
             @value = split (/\|/, $val);        
                # TODO find a method to ensure that End of File is used to Align the Tables
                if (@value[1] !~ m/NA/i)  { $list_var= @value[1];}  else{$list_var='-';}  #print $list_var."\t";                
                if (@value[4] !~ m/NA/i)  { $list_min= @value[4];}  else{$list_min='-';}  #print $list_min."\t";                
                if (@value[5] !~ m/NA/i)  { $mid_Neg=  @value[5];}  else{$mid_Neg='-'; }  #print $mid_Neg."\t";
                if (@value[6] !~ m/NA/i)  { $list_Zero=@value[6];}  else{$list_Zero='-';} #print $list_Zero."\t";
                if (@value[7] !~ m/NA/i)  { $mid_Pos=  @value[7];}  else{$mid_Pos='-';}   #print $mid_Pos."\t";
                if (@value[8] !~ m/NA/i)  { $list_max= @value[8];}  else{$list_max='-';}  #print $list_max."\t";
                if (@value[9] !~ m/NA/i)  { $OutBou_lo=@value[9];}  else{$OutBou_lo='-';} #print $OutBou_lo."\t";
                if (@value[10] !~ m/NA/i) { $OutBou_hi=@value[10];} else{$OutBou_hi='-';} #print $OutBou_hi."\n";                                           
                # Update the List of Variables into a Buffer here.                
                if ($list_var )
                {
                    my $varname = $list_var; 
                    $varname =~ s/^\s+|\s+$//g;
                    push (@var_list, $list_var);                
                    #Print the Table
                 print $list_var."\t".$list_min."\t".$mid_Neg."\t".$list_Zero."\t".$mid_Pos."\t".$list_max."\t".$OutBou_lo."\t".$OutBou_hi."\n";
                }
                if ($list_min != '-')
                {
                  push (@min_list, $list_min);  
                }
                if ($list_max != '-')
                {
                  push (@max_list, $list_max);  
                }
                #for Debug
                my $debug;
                foreach $debug(@minlist)
                {
                    print $debug."\n";
                }
                
            }     
            #TODO: Possible avenue to create Key Value Pair            
            # Get list of variable Names from IRT
                      
            #TODO: Linked with Text::Table  for Pretty Print
            #$tb-> load($list_var,$list_min,$mid_neg,$list_Zero,$mis_Pos,$list_max,$OutBou_lo,$OutBou_hi);            
            #print $tb;                       
            # TODO: Call the Testcases and check for the Objectives in the Test Case Block
        }
        local $bufferSing ;  
        &ListST;            
        if ($flag_blankST)
        {
          @identSingLine = split ("\n", $bufferSing);
          local $count_sing;
          undef @value;
          foreach my $val (@identSingLine)
           {
             $count_sing++;
             print "\n"."The Values from the  Singularity tables for Test# ".$count_sing." are:\n";
             $val =~ s/^\s+|\s+$//g ;   #remove spaces and Trim the values
             @value = split (/\|/, $val);
                if (@value[1] !~ m/NA/i) { $NMinus= @value[3];}  else{$NMinus=0;} print $NMinus."\t";                
                if (@value[2] !~ m/NA/i) { $NValue= @value[3];}  else{$NValue=0;} print $NValue."\t";                
                if (@value[3] !~ m/NA/i) { $NPosit= @value[4];}  else{$NPosit=0;} print $NPosit."\t";
           }        
        }
        print "\n\n";
        &ListTestcases;
        print "\n\n";            
        #TODO: Need to remove Duplicate Entries of testcases if Both IRT and ST
        if ( ($flag_blankIRT) && ($flag_blankST))
        {
            #print "\n"."Both Singularity and IRT Table are present"."\n";
        }
        my @objbuffer =();
        &checkobjectives;        
        
        #TODO   Rule validator will start here for the Minimum Value parse from IRT
        #TODO:    Rule Validation for each of the Other 7 Values -Max, OB and Zero can start here
        # List all the Possible Rules here
        print "\n"."Listing the Objectives now"."\n";        
        my @Rule =('Min', 'Max');        # for Now only 3 Conditions
        my $a, $b, $c, $d;
=cut;   #check from All the Testcases 
        foreach $a (@ListTestcases)
        {
            $d++;
            foreach $b (@var_list)
            {
                foreach $c (@Rule)
                {  
                &rulevalidator($a, $b ,$c ,$d);
                }
            }
        }
=cut;        
        # check for Specific Testcases from IRT
        foreach $a (@var_list)
        {
            $d++;
            foreach $b (@Rule)
            {
                foreach $c (@min_list)
                {   
                    &rulevalidator($a, $b ,$c ,$d);                    
                }
                foreach $c (@max_list)
                {   
                    &rulevalidator($a, $b ,$c ,$d);
                }
            }   
        }
    }
close(OUTFILE);      # close the OUTFILE per file
}
closedir(TD);

sub ListIRT
{
    #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    print "\n".$dir_path.$filename."-----------------\n";
    #my $TCFFile = $filename;
    while (<FP>)	
    {
        if ( /INPUT RANGE/i) {
        #$buffer .=$_;  # removed as this is Duplicated
            while (<FP>) 
            {                        
            #TODO: Need to check if Blank Values are assigned to the Value    
            if ((m/None/i) ||( m/---/) || ( m/Variable/i))
                {
                 next;
                }
                else
                {
                $buffer .=$_;    
                last if /^\n$/;    
                }
            }
        }
        #check for Blank Entries returned
        if (($buffer == "" ) || ($buffer =~ m/none/i ))
        {
            $flag_blankIRT = false;
        }  
    }   
    #print $buffer; 
    #if 0       // Comment   
    if ( m/|/i )
    {                    
        if (@identlines ne "")
        {   foreach $line (@identlines)
           {
                print $line."\n";
           }    }
        
        if (@array ne "")
        {       foreach $val (@array)
        {
                print $val."\n";                
        }       }
    }
    else
    {
        print "\nNo Values Seen in the Singularity Table\n";
        goto END;
    }
END:
    #endif       // End of Comment
close(FP);
}        

sub ListTestcases
{
    #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    #print "\n".$dir_path.$filename."-----------------\n";
    #my $TCFFile = $filename;
    while (<FP>)	
    {
    if ( s/ Description = TEST//ig) 
        {
         my $str=$_; 
         $str =~ s/^\s+|\s+$//g ;
         push (@ListTestcases, $str);   
        }
    }
    #print the Testcases
    foreach my $j (@ListTestcases)    
    { 
        print " Valid Testcases are : ".$j."\n";
    }  
close(FP);
}        

sub ListST
{
 #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    #print "\n".$dir_path.$filename."-----------------\n";
    undef @identSingLine; 
    while (<FP>)	
    {
    if ( /SINGULARITY/i) 
        {            
        #$buffer .=$_;  # skip the Current string
        while (<FP>) 
        {                        
            #TODO: Need to check if Blank Values are assigned to the Value
            if ((m/None/i) ||( m/---/) || ( m/Expression/i)) # || (m/ /i))
            {
             next;
            }
            else
            {
            $bufferSing .=$_;    
            last if /^\n$/;    
            }
        }
        }
        #check for Blank Entries returned
        if (($bufferSing == "" ) ||($bufferSing =~ m/none/i ))
        {
            $flag_blankST = false;
        }        
    }    
    #if 0       // Comment 
    if ( m/|/i )
    {            
      
        if (@identLine ne "")
        {   foreach $line (@identLine)
           {
                print $line."\n";
           }    }
        
        if (@array ne "")
        {       foreach $val (@array)
        {
                print $val."\n";                
        }       }
    }
    else    # this part of the Code is redundant
    {
        print "\nNo Values Seen in the Singularity Table\n";
        goto END;
    }
END:
    #endif       // End of Comment
close(FP);
}    

sub parsetable       # Subroutine to parse the Values in the Input range table
{
#TODO: To Debug the Subroutine later for Parsing IRT
my $count = $_[0];
if (@value[$count] !~ m/NA/i) 
{$ret= @value[$count];} 
else
{$ret==0;}
print $ret;
print @value[$count];
}

sub checkobjectives  # Subroutine to check the Objectives for the testcases
{
#opens the file inside the dir
open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");     
my $testcase ;
    while (<FP>)	
    {          
    if(m/Description = TEST/i)
        {
            $testcase=$_;
            $valcount++;
            push (@{$objfiles[$valcount]},$testcase);
            while(<FP>) 
            {
             push @{$objfiles[$valcount]},$_;
             #print $_;  #debug to list the Contents of the Objective Block
             if (m/Control Flow/i)
              { last;}
            }        
        }        
    }
    for (my $i ; $i < $valcount;$i++)
    {        
        print "-------Testcase Details for Testcase:".($i+1)."----\n";
        foreach my $b ( @{$objfiles[$valcount]})
        {
            #print $b;
        }
        print "\n";
    }
    #return $_;
close(FP);
}

#TODO:  Rules for Maximum, Minimum, Out of Bounds and Singularity check need to be done
sub rulevalidator
{    
    my $testcase = $_[0];
    my $rulepattern = $_[1];  
    my $var_name =$_[2];  
    my $testcasenumber =$_[3];
    local $b;
    local $val;
    print $testcase.$rulepattern.$var_name.$testcasenumber."\n";
    
    #$localtestcase =~ m/Description = TEST/i;
    foreach $b ( @{$objfiles[$valcount]})
    {
    #print $b;    
        $val =$b;
       
    }
    #Dumper @{$objfiles[$testcasenumber]};
}

#TODO: To print the Output block for the Test Case and IRT traceability
sub PrintIRTTrace
{
print "\n";
    
    
    
    
print "\n";       
}

sub reopen($$$) 
{
  open $_[0], $_[1]. '&='. fileno($_[2]) or die "failed to reopen: $!";
}
#   End of File #
