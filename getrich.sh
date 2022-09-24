echo "What is your name?"

read name

echo "How old are you?"

read age

echo "Hello $name, you are $age years old."

sleep 2

echo ""
echo "Calculating"
echo ".........."
sleep 1
echo "**........"
sleep 1
echo "****......"
sleep 1
echo "******...."
sleep 1
echo "********.."
sleep 1
echo "**********"
echo ""

getrich=$((( $RANDOM % 15 ) + $age ))

echo "$name, you will become a millionare when you are $getrich years old"
