#!/bin/bash
if [[ $1 ]]
then 
 PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
 ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
 SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
 NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
 if [[ -z $SYMBOL ]] && [[ -z $ATOMIC_NUMBER ]] && [[ -z $NAME ]]
 then 
  echo "I could not find that element in the database."
 else 
   if [[ ! -z $SYMBOL ]]
   then 
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
   elif [[ ! -z $NAME ]] 
   then 
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
   fi
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
 fi
else 
  echo "Please provide an element as an argument."
fi
