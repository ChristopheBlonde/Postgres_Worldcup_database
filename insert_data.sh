#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clean databse
echo "$($PSQL "TRUNCATE TABLE teams,games;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
# get winner id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
# if not found
if [[ -z $WINNER_ID ]]
then
# insert new team
WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
if [[ $WINNER_ID_RESULT == 'INSERT 0 1' ]]
then
echo "Inserted in teams table: $WINNER"
fi
# get new winner id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
fi
# get opponent id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

# if not found
if [[ -z $OPPONENT_ID ]]
then
# insert new team
OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
if [[ $OPPONENT_ID_RESULT == 'INSERT 0 1' ]]
then
echo "Inserted in teams table: $OPPONENT"
fi
# get new opponent id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
fi
# insert game
INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
if [[ $INSERT_GAME == 'INSERT 0 1' ]]
then
echo "Inserted in games table $WINNER vs $OPPONENT"
fi
fi
done