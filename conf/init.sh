#!/bin/sh

readonly repository="https://raw.githubusercontent.com/braveryk7/GitHooks/main"
readonly root_path=`git rev-parse --git-dir`/..
readonly ESC=$(printf '\033')

function exists_check() {
    if [ -e "${1}" ]; then
        printf "${ESC}[92m%s${ESC}[m" "[OK] "
        echo "${1} exists."
    else
        printf "${ESC}[91m%s${ESC}[m" "[NG] "
        echo "${1} does not exists."
    fi
}

printf "\n${ESC}[44m%s${ESC}[m\n\n" "/------- git check. -------/"

exists_check .git
printf "\n"

printf "${ESC}[44m%s${ESC}[m\n\n" "/------- Program check. -------/"

`curl ${repository}/githooks/commit-msg > .git/hooks/commit-msg`
`curl ${repository}/githooks/pre-commit > .git/hooks/pre-commit`
`curl ${repository}/conf/linter_config.sh > conf/linter_config.sh`

exists_check .git/hooks/commit-msg
exists_check .git/hooks/pre-commit
exists_check conf/linter_config.sh

chmod +x .git/hooks/commit-msg
chmod +x .git/hooks/pre-commit

printf "\n${ESC}[44m%s${ESC}[m\n\n" "/------- Permission check. -------/"

if [ -x .git/hooks/commit-msg ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo ".git/hooks/commit-msg: Add execute permission."
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo ".git/hooks/commit-msg: Failed to grant execute permission."
fi
if [ -x .git/hooks/pre-commit ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo ".git/hooks/pre-commit: Add execution permission."
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo ".git/hooks/pre-commit: Failed to grant execute permission."
fi

printf "\n${ESC}[44m%s${ESC}[m\n\n" "/------- Linter check. -------/"

. conf/linter_config.sh

set_eslint

if [ "${eslint}" != "not found" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "ESLint exists."
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "ESLint does not exists."
    echo "     ESLint install: npm install --save-dev eslint"
fi
if [ "${eslint_config}" != "" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "ESLint config exists.\n"
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "ESLint config does not exists."
    echo "     Required: .eslintrc.js / .eslintrc.cjs / .eslintrc.yaml / .eslintrc.yml / .eslintrc.json\n"
fi

set_stylelint

if [ "${stylelint}" != "not found" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "StyleLint exists."
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "StyleLint does not exists."
    echo "     StyleLint install: npm install --save-dev eslint"
fi
if [ "${stylelint_config}" != "" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "StyleLint config exists.\n"
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "StyleLint config does not exists."
    echo "     Required: .stylelintrc.js / .stylelintrc.cjs / .stylelintrc.yaml / .stylelintrc.yml / .stylelintrc.json / .stylelintrc\n"
fi

set_phpcs

if [ "${phpcs}" != "not found" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "PHP CodeSniffer exists."
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "PHP CodeSniffer does not exists."
    echo "     PHP CodeSniffer install: composer --require-dev require \"squizlabs/php_codesniffer=*\""
fi
if [ "${phpcs_config}" != "" ]; then
    printf "${ESC}[92m%s${ESC}[m" "[OK] "
    echo "PHP CodeSniffer config exists.\n"
else
    printf "${ESC}[91m%s${ESC}[m" "[NG] "
    echo "PHP CodeSniffer config does not exists."
    echo "     Required: .phpcs.xml / phpcs.xml / .phpcs.xml.dist / phpcs.xml.dist\n"
fi

rm conf/init.sh
