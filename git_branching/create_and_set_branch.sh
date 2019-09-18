location="/scripts"
mkdir -p $location

cat ./create_and_set_branch.sh > "$location/create_and_set_branch.sh"

echo "
alias setup-git=\". $location/create_and_set_branch.sh\"
" >> /etc/bashrc