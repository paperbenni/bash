  #!/bin/bash
  
if [ -e player.txt ]
then
    PLAYERNAME=$(cat player.txt)
    echo "getting uuid for $PLAYERNAME"
    curl https://api.mojang.com/users/profiles/minecraft/$PLAYERNAME | jq -r '.id' > uuid.txt
else
  echo "player.txt not found"
fi  
