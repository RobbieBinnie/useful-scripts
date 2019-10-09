location="/scripts"
mkdir -p $location

cat ./nicepassgen.ps1 > "$location/nicepassgen.ps1"

echo "
alias nicepassgen=\"pwsh $location/nicepassgen.ps1\"
" >> /etc/bashrc