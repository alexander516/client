#
# $Id$
#
package Metabrik::Client::Onyphe::Function::Blacklist;
use strict;
use warnings;

use base qw(Metabrik::Client::Onyphe::Function);

sub brik_properties {
   return {
      revision => '$Revision: d629ccff5f0c $',
      tags => [ qw(unstable) ],
      author => 'ONYPHE <contact[at]onyphe.io>',
      license => 'http://opensource.org/licenses/BSD-3-Clause',
      commands => {
         run => [ qw(results csv) ],
      },
   };
}

sub run {
   my $self = shift;
   my ($r, $lookup) = @_;

   $self->brik_help_run_undef_arg('run', $r) or return;
   $self->brik_help_run_invalid_arg('run', $r, 'ARRAY') or return;
   $self->brik_help_run_undef_arg('run', $lookup) or return;
   $self->brik_help_run_file_not_found('run', $lookup) or return;

   my $fc = Metabrik::File::Csv->new_from_brik_init($self) or return;
   my $l = $fc->read($lookup) or return;
   my $fields = $fc->header or return;
   my $fields_count = scalar(@$fields);

   my @new = ();

   my $last = 0;
   $SIG{INT} = sub {
      $last = 1;
      return $self->return($r, \@new);
   };

   for my $page (@$r) {
      for my $this (@{$page->{results}}) {
         my $skip = 0;
         # $field is the field to match against (example: domain):
         for my $field (@$fields) {
            # Fetch the value from current result $this:
            my $value = $self->value($this, $field);
            if (defined($value)) {
               $value = ref($value) eq 'ARRAY' ? $value : [ $value ];
               # Compare against all fields given in the CSV:
               for my $a (@$value) {
                  my $match = 0;
                  for my $h (@$l) {
                     if (exists($h->{$field}) && $h->{$field} eq $a) {
                        #print "[DEBUG] skip field [$field] value [$a]\n";
                        $skip++;
                        $match++;
                        last;
                     }
                  }
                  last if $match;
               }
            }
            # When all fields have matched, no need to compare with remaining
            if ($skip == $fields_count) {
               #print "[DEBUG] all fields matched [$skip]\n";
               last;
            }
         }
         if ($skip != $fields_count) { # Not all fields have matched, it is
                                       # NOT blacklisted, we keep results
            push @new, $this;
         }
      }
   }

   return $self->return($r, \@new);
}

1;
