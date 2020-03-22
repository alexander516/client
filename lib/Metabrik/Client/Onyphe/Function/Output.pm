#
# $Id$
#
package Metabrik::Client::Onyphe::Function::Output;
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
         run => [ qw(results format) ],
      },
   };
}

# Not ready to be integrated, need to integrate -fields too and all onyphe program arguments.
#sub run {
#   my $self = shift;
#   my ($r, $format) = @_;

#   $self->brik_help_run_undef_arg('run', $r) or return;
#   $self->brik_help_run_invalid_arg('run', $r, 'ARRAY') or return;
#   $self->brik_help_run_undef_arg('run', $format) or return;

#   my $function = 'output_'.$format;
#   if (! $self->can($function)) {
#      return $self->log->error("function_output: invalid output format [$format]");
#   }

#   return $self->$function($r);
#}

1;
