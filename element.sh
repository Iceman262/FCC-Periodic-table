#!/bin/bash

# Show informations about chemical elements

PSQL="psql --username=postgres --dbname=periodic_table -t -q --no-align -c"

# If you run `./element.sh`, it should output only `Please provide an element as an argument.` and finish running.
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

SEARCH_FOR_SYMBOL() {
  # search for the symbol
  local QUERY_RESULT=$($PSQL "
  SELECT el.atomic_number, el.symbol, el.name, pr.atomic_mass, pr.melting_point_celsius, pr.boiling_point_celsius, t.type
  FROM elements AS el
  FULL JOIN properties AS pr ON el.atomic_number = pr.atomic_number
  FULL JOIN types AS t ON pr.type_id = t.type_id
  WHERE el.symbol = '$1';")
  # if symbol exists print the message
  if [[ ! -z $QUERY_RESULT ]]
  then
    read ATOMIC_NUMBER SYMBOL ELEMENT_NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $(echo $QUERY_RESULT | sed 's/[|]/ /g')
    echo The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
  else
    # else notify the absence of the symbol
    echo I could not find that element in the database.
  fi
  exit 0
}

SEARCH_FOR_ATOMIC_NUMBER() {
  # search for the atomic number
  local QUERY_RESULT=$($PSQL "
  SELECT el.atomic_number, el.symbol, el.name, pr.atomic_mass, pr.melting_point_celsius, pr.boiling_point_celsius, t.type
  FROM elements AS el
  FULL JOIN properties AS pr ON el.atomic_number = pr.atomic_number
  FULL JOIN types AS t ON pr.type_id = t.type_id
  WHERE pr.atomic_number = '$1';")
  # if symbol exists print the message
  if [[ ! -z $QUERY_RESULT ]]
  then
    read ATOMIC_NUMBER SYMBOL ELEMENT_NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $(echo $QUERY_RESULT | sed 's/[|]/ /g')
    echo The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
  else
    # else notify the absence of the symbol
    echo I could not find that element in the database.
  fi
  exit 0
}

SEARCH_FOR_ELEMENT_NAME() {
  # search for the element name
  local QUERY_RESULT=$($PSQL "
  SELECT el.atomic_number, el.symbol, el.name, pr.atomic_mass, pr.melting_point_celsius, pr.boiling_point_celsius, t.type
  FROM elements AS el
  FULL JOIN properties AS pr ON el.atomic_number = pr.atomic_number
  FULL JOIN types AS t ON pr.type_id = t.type_id
  WHERE el.name = '$1';")
  # if symbol exists print the message
  if [[ ! -z $QUERY_RESULT ]]
  then
    read ATOMIC_NUMBER SYMBOL ELEMENT_NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $(echo $QUERY_RESULT | sed 's/[|]/ /g')
    echo The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
  else
    # else notify the absence of the symbol
    echo I could not find that element in the database.
  fi
  exit 0
}

# check the structure of the parameter and choose an SQL command
if [[ $1 =~ ^[A-Z][a-z]?$ ]];
then
  SYMBOL=$1
  SEARCH_FOR_SYMBOL $SYMBOL
elif [[ $1 =~ ^[1-9][0-9]*$ ]]
then
  ATOMIC_NUMBER=$1
  SEARCH_FOR_ATOMIC_NUMBER $ATOMIC_NUMBER
elif [[ $1 =~ ^[A-Z][a-z]+$ && ${#1} -ge 3 ]]
then
  ELEMENT_NAME=$1
  SEARCH_FOR_ELEMENT_NAME $ELEMENT_NAME
fi
