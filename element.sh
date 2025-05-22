#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ARGUMENT=$1

if [[ -z $ARGUMENT ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Determine atomic number
if [[ $ARGUMENT =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ARGUMENT")
elif [[ $ARGUMENT =~ ^[A-Za-z]{1,2}$ ]]; then
  ARGUMENT=${ARGUMENT^}
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ARGUMENT'")
elif [[ $ARGUMENT =~ ^[A-Za-z]+$ ]]; then
  ARGUMENT=${ARGUMENT^}
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ARGUMENT'")
fi

# Output element info
if [[ -z $ATOMIC_NUMBER ]]; then
  echo "I could not find that element in the database."
else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
