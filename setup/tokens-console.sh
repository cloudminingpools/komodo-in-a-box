
function submenu_tokens {
while true
do
echo "Token system for blockchain:"
echo $CHAIN
### display main menu ###
dialog --clear  --help-button --backtitle "Cakeshop Console" \
--title "[ C A K E S H O P - T O K E N - C O N S O L E ]" \
--menu "You can use the UP/DOWN arrow keys, the first \n\
letter of the choice as a hot key, or the \n\
number keys 1-9 to choose an option.\n\
Choose the TASK" 25 120 14 \
LIST "tokenlist - list tokens created on $CHAIN" \INFO "tokeninfo - get info about a token on $CHAIN" \
CREATE "tokencreate - create a token on $CHAIN" \
ADDRESS "tokenaddress - get address information on $CHAIN" \
Back "Back" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# make decsion
case $menuitem in
	LIST) tokenlist;;
	INFO) submenu_tokeninfo;;
	CREATE) submenu_tokencreate;;
	ADDRESS) tokenaddress;;
	Back) echo "Back"; break;;
esac
done
}

function submenu_tokeninfo {
    helper_tokenlist
    # get the array from ~/.kiabresponse
    # [
    #   "be75c48e0168668ef8a6861e51ba8461deb5a923bf50bd7e9a89917dfb066462",
    #   "lkajsdlfjasdlfkjalskdfj"
    # ]
    # turn it into a menu item
    #
    # 1 - "be75....."
    # 2 - "lkaj...."
    #

    echo "Got the list of tokens"

    cat $HOME/.kiabresponse | jq '.[]' > $HOME/.tmp
    /bin/rm $HOME/.kiabresponse

    cat $HOME/.tmp
    sleep 1

    COUNT=0
    #used later during selection
    CHOICES2="("
    #used first for dialog
    CHOICES3=""
    for i in `cat $HOME/.tmp`
    do
      CHOICES2="$CHOICES2 $i "
      CHOICES3="$CHOICES3 $COUNT $i"
      echo "$COUNT $i \\">> $HOME/.kiabresponse
      let COUNT=COUNT+1
    done
    CHOICES2="$CHOICES2)"
    # echo $CHOICES3
    # sleep 1

    while true
    do
    echo "Token system for blockchain:"
    echo $CHAIN
    ### display main menu ###
    dialog --clear  --help-button --backtitle "Cakeshop Console" \
    --title "[ C A K E S H O P - T O K E N - C O N S O L E ]" \
    --menu "These are the funding txid for the token creation. \n\
    They follow the marker pattern used for creating contracts. \n\
    The funding tx marks the beginning of this contract and can \n\
    easily be used to track it throughout the blockchain. \n\
    You can use the UP/DOWN arrow keys, the first \n\
    letter of the choice as a hot key, or the \n\
    number keys 1-9 to choose an option.\n\
    Choose the TASK" 25 120 14 \
    $CHOICES3 \
    Back "Back" 2>"${INPUT}"

    menuitem=$(<"${INPUT}")

    # make decsion break or continue with selection of tokeninfo
    case $menuitem in
        Back) echo "Back"; break;;
    esac

    declare -a CHOICES4=$CHOICES2
    # echo ${CHOICES4[@]:$menuitem:1}
    TOKENTXID=${CHOICES4[@]:$menuitem:1}
    # echo $menuitem
    # echo $TOKENTXID
    tokeninfo
    sleep 3
    done
}

function submenu_tokencreate {
    #input_box "LEGS2" "How many wallets?" "5" WALLETS
    input_box "Name Question" "Token name?" "TOKENA" TOKENNAME
    input_box "Supply Question" "How many tokens? 0.01 is 100k" "0.01" TOKENSUPPLY
    input_box "Description of token" "Short description of token?" "short description" TOKENDESCRIPTION
    source ~/.devwallet
    tokencreate 
}