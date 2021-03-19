#!/usr/bin/perl

use strict;
use warnings;

sub afficherDamier {
    my ($pdamier, $dimX, $dimY) = @_;
    my $self={};

    $self->{DAMIER} = $pdamier;
    $self->{DIMX} = $dimX;
    $self->{DIMY} = $dimY;

    my $y;
    my $x;

    for ($y=0; $y < $dimY; $y++){
        # Les accolades sont obligatoires en Perl
        for ($x=0; $x<$dimX; $x++) {
            print "+-"; 
        }
        print "+\n";

        for ($x=0; $x<$dimX; $x++) { 
            print "|".@{$pdamier}[$x*$dimY+$y]; 
        }
        print "|\n";
    }

    for ($x=0; $x<$dimX; $x++) { 
        print "+-";  
    }

    print "+\n";
    
    bless($self);
}

 ##################################################################
 # Cette fonction peut renvoyer :                                 #
 #                                                                #
 #  - une valeur comprise en 6 et 0 correspondant � une case vide #
 #  - -1 signifiant que la colonne est pleine                     #
 #  - -2 signifiant que la colonne est incorrecte                 #
 ##################################################################

sub getCaseVide {
    my ($pdamier, $dimX, $dimY, $x) = @_;

    my $self={};

    $self->{DAMIER} = $pdamier;
    $self->{DIMX} = $dimX;
    $self->{DIMY} = $dimY;
    $self->{X} = $x;
    
    my $y       = 5;

    if ( ( $x>=$dimX ) || ( $x < 0 ) ) {
        $y = -2;
    }
    else {
        while ( ($y != -1) && (@{$pdamier}[$x*$dimY+$y] ne '?') ) {
		    $y--;
		}
    }

	bless($self);
    return $y;
 }

sub placerJeton {  
    my ($pdamier, $dimX, $dimY, $x, $y, $jeton) = @_;

    my $self={};
    $self->{DAMIER} = $pdamier;
    $self->{DIMX} = $dimX;
    $self->{DIMY} = $dimY;
    $self->{X} = $x;
    $self->{Y} = $y;
    $self->{JETON} = $jeton;

    if ( ( $x < $dimX ) && ( $x >= 0 ) && ( $y < $dimY ) && ( $y >= 0 ) ) {
        @{$pdamier}[$x*$dimY+$y] = $jeton;
    }
	bless($self);
}

sub testerFin {
    my ($pdamier, $dimX, $dimY, $x, $y, $jeton) = @_;

    my $self={};

    $self->{DAMIER} = $pdamier;
    $self->{DIMX} = $dimX;
    $self->{DIMY} = $dimY;
    $self->{X} = $x;
    $self->{Y} = $y;
    $self->{JETON} = $jeton;
  
    my @cumul       = (0, 0, 0, 0, 0, 0, 0);
    my @finComptage = (0, 0, 0, 0, 0, 0, 0);

    # Analyse vers la gauche

    for (my $decalage=1; $x-$decalage>=0; $decalage++) {
        if ( (@{$pdamier}[($x-$decalage)*$dimY+$y] eq $jeton) && (!$finComptage[0]) ) { 
            $cumul[0]++;
        }
        else { 
            $finComptage[0] = 1; 
        }

        if ( ($y-$decalage>=0) && (@{$pdamier}[($x-$decalage)*$dimY+$y-$decalage] eq $jeton) && (!$finComptage[1]) ) {
            $cumul[1]++;
        }
        else { 
            $finComptage[1] = 1; 
        }

        if ( ($y+$decalage<$dimY) && (@{$pdamier}[($x-$decalage)*$dimY+$y+$decalage] eq $jeton) && (!$finComptage[2])) { 
            $cumul[2]++;
        }
        else { 
            $finComptage[2] = 1; 
        }
    }

    # Analyse vers la droite

    for (my $decalage=1; $x+$decalage<$dimX; $decalage++) {
        if ((@{$pdamier}[($x+$decalage)*$dimY+$y] eq $jeton) && (!$finComptage[3]) ) { 
            $cumul[3]++;
        }
        else { 
            $finComptage[3] = 1; 
        }

        if ( ($y-$decalage>=0) && (@{$pdamier}[($x+$decalage)*$dimY+$y-$decalage] eq $jeton) && (!$finComptage[4]) ) { 
            $cumul[4]++;
        }
        else { 
            $finComptage[4] = 1; 
        }

        if ( ($y+$decalage<$dimY) && (@{$pdamier}[($x+$decalage)*$dimY+$y+$decalage] eq $jeton) && (!$finComptage[5])) { 
            $cumul[5]++;
        }
        else { 
            $finComptage[5] = 1; 
        }
    }

    # Analyse vers le bas

    for (my $decalage=1; $y+$decalage<$dimY; $decalage++) {
        if ((@{$pdamier}[($x)*$dimY+$y+$decalage] eq $jeton) && (!$finComptage[6]) ) { 
            $cumul[6]++;
        }
        else { 
            $finComptage[6] = 1; 
        }
    }
    bless($self);
    return ($cumul[6]+1>=4) || ($cumul[0]+$cumul[3]+1>=4) || ($cumul[1]+$cumul[5]+1>=4) || ($cumul[2]+$cumul[4]+1>=4);
  ###############
  #             #
  #  1       4  #
  #    \   /    #
  #     \ /     #
  #  0 --+-- 3  #
  #     /|\     #
  #    / | \    #
  #  2   6   5  #
  #             #
  ###############
}

# Equivalent de la fonction main du C
 
my @damier = ();

for (my $i=0; $i<7*6; $i++) { 
    $damier[$i] = '?'; 
}

my $numJoueur = 0;
my $finDuJeu  = 0;
my $x;
my $y;

do {
    afficherDamier (\@damier, 7, 6);  # On passe le pointeur sur le tableau

    do {
        print "Joueur ".$numJoueur.", donnez votre colonne : ";
	    $x = <STDIN>;
        $y = getCaseVide (\@damier, 7, 6, $x);
    }
    while ($y<0);

    placerJeton (\@damier, 7, 6, $x, $y, ($numJoueur?'X':'O') );

    $finDuJeu = testerFin (\@damier, 7, 6, $x, $y, ($numJoueur?'X':'O') );

    if (!$finDuJeu) { 
        $numJoueur = ($numJoueur+1)%2; 
    }
 }
 while ( !$finDuJeu );

afficherDamier (\@damier, 7, 6);

print "Le joueur ".$numJoueur." a gagne !";