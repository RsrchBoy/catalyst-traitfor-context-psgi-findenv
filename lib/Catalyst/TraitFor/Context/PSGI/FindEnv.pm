package Catalyst::TraitFor::Context::PSGI::FindEnv;

# ABSTRACT: Hunt down our PSGI environment, even in 5.8x

use Moose::Role;
use namespace::autoclean;

=method psgi_env

This method will attempt to locate and return the PSGI environment hashref.
If one is not found, nothing will be returned.

=cut

sub psgi_env {
    my ($self) = @_;

    my $env
        = $self->req->can('env')     ? $self->req->env
        : $self->engine->can('env')  ? $self->engine->env
        # no env to infiltrate
        : return
        ;

    return $env;
}

!!42;
__END__

=for stopwords conditionalize

=head1 DESCRIPTION

This is a L<Catalyst> context trait that aids in finding a PSGI
environment, if one is available, even in a 5.8x environment.

Note the key part about "if one is available" :)  This is not always the case
under 5.8x.

=head1 TRAIT APPLICATION

Neither L<CatalystX::Component::Traits> nor L<CatalystX::RoleApplicator>
handle applying context class traits at the moment.

=head2 Directly in your application class

    with 'Catalyst::TraitFor::Context::PSGI::FindEnv';

=head2 In your PSGI file

If you're only enabling this for debug purposes, it might be better to
conditionalize this in your C<app.psgi>, with something like:

    Catalyst::TraitFor::Context::PSGI::FindEnv
        ->meta
        ->apply(Class::MOP::class_of('MyApp'))
        ;

...or, as that's a bit of a mouthful:

    use Moose::Util 'ensure_all_roles';
    ensure_all_roles MyApp => 'Catalyst::TraitFor::Context::PSGI::FindEnv';

Both do the same thing (for generally indistinguishable values of "same
thing").

Note that your application class will need to be mutable (that is, not
immutable) for these approaches to work.

=cut
