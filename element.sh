#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Exit early if no argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT="$1"

# Query the database for matching element
RESULT=$($PSQL "
  SELECT
    e.atomic_number,
    e.name,
    e.symbol,
    t.type,
    p.atomic_mass,
    p.melting_point_celsius,
    p.boiling_point_celsius
  FROM elements AS e
  JOIN properties AS p USING(atomic_number)
  JOIN types      AS t USING(type_id)
  WHERE e.atomic_number::TEXT = '$INPUT'
     OR e.symbol ILIKE '$INPUT'
     OR e.name   ILIKE '$INPUT';
")

# If no result is found, print message and exit
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse the result fields
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

# Display formatted element information
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
