#!/usr/bin/env bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# no argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1

# query database for atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
RESULT=$($PSQL "
  SELECT e.atomic_number, e.name, e.symbol,
         t.type, p.atomic_mass,
         p.melting_point_celsius, p.boiling_point_celsius
  FROM elements AS e
  JOIN properties AS p ON e.atomic_number = p.atomic_number
  JOIN types      AS t ON p.type_id = t.type_id
  WHERE e.atomic_number = '$INPUT'
     OR e.symbol        = '$INPUT'
     OR e.name          = '$INPUT';
")

# if no row found
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# parse result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

# output
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
