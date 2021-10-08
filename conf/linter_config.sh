function get_files() {
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        against=HEAD
    else
        against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
    fi

    exec 1>&2

    files=`git diff-index --cached --name-only --diff-filter=AM ${against}`
    is_error=0
    output=""

    php_files=""
    js_files=""
    css_files=""
    for f in ${files}
        do
            extension=${f##*.}
            case ${extension} in
                php)
                    php_files+="${f} ";;
                js | ts | jsx | tsx)
                    js_files+="${f} ";;
                css | scss | sass)
                    css_files+="${f} ";;
            esac
    done
}

function output() {
    if [ ${is_error} -gt 0 ]; then
        is_error=1
        printf "\n  ${ESC}[41m%s${ESC}[m\n" "Commit aborted."
        printf "    ${ESC}[91m%s${ESC}[m\n" "Lint tool found an error."
        echo "${output}\n\n"
    else
        is_error=0
    fi

    exit ${is_error}
}

function set_eslint() {
    if [ -e "${root_path}/node_modules/.bin/eslint" ]; then
        eslint=${root_path}/node_modules/.bin/eslint
        if [ -e "${root_path}/.eslintrc.js" ]; then
            eslint_config=${root_path}/.eslintrc.js
        elif [ -e "${root_path}/.eslintrc.cjs" ]; then
            eslint_config=${root_path}/.eslintrc.cjs
        elif [ -e "${root_path}/.eslintrc.yaml" ]; then
            eslint_config=${root_path}/.eslintrc.yaml
        elif [ -e "${root_path}/.eslintrc.yml" ]; then
            eslint_config=${root_path}/.eslintrc.yml
        elif [ -e "${root_path}/.eslintrc.json" ]; then
            eslint_config=${root_path}/.eslintrc.json
        else
            eslint_config=""
        fi
    else
        eslint="not found"
    fi
}

function set_stylelint() {
    if [ -e "${root_path}/node_modules/.bin/stylelint" ]; then
        stylelint=${root_path}/node_modules/.bin/stylelint
        if [ -e "${root_path}/.stylelintrc" ]; then
            stylelint_config=${root_path}/.stylelintrc
        elif [ -e "${root_path}/.stylelint.config.js" ]; then
            stylelint_config=${root_path}/.stylelint.config.js
        elif [ -e "${root_path}/.stylelint.config.cjs" ]; then
            stylelint_config=${root_path}/.stylelint.config.cjs
        elif [ -e "${root_path}/.stylelintrc.yaml" ]; then
            stylelint_config=${root_path}/.stylelintrc.yaml
        elif [ -e "${root_path}/.stylelintrc.yml" ]; then
            stylelint_config=${root_path}/.stylelintrc.yml
        elif [ -e "${root_path}/.stylelintrc.json" ]; then
            stylelint_config=${root_path}/.stylelintrc.json
        else
            stylelint_config=""
        fi
    else
        stylelint="not found"
    fi
}
