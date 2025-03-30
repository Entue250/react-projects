#!/bin/bash

# Function to generate conventional commit message
generate_commit_message() {
    local file="$1"
    local type=""
    local message=""

    # Determine commit type based on file path
    case "$file" in
        package-lock.json)
            type="chore(deps)"
            message="update package lock dependencies"
            ;;
        package.json)
            type="chore(deps)"
            message="update project dependencies"
            ;;
        .gitignore)
            type="chore"
            message="add gitignore configuration"
            ;;
        README.md)
            type="docs"
            message="add project documentation"
            ;;
        eslint.config.js)
            type="config"
            message="add ESLint configuration"
            ;;
        index.html)
            type="feat"
            message="add HTML entry point"
            ;;
        vite.config.js)
            type="config"
            message="add Vite build configuration"
            ;;
        src/index.css)
            type="style"
            message="add global styles"
            ;;
        src/App.css)
            type="style"
            message="add App component styles"
            ;;
        src/App.jsx)
            type="feat"
            message="add main App component"
            ;;
        src/main.jsx)
            type="feat"
            message="add application entry point"
            ;;
        src/Button.jsx)
            type="feat(components)"
            message="add Button component"
            ;;
        src/ColorPicker.jsx)
            type="feat(components)"
            message="add ColorPicker component"
            ;;
        src/Counter.jsx)
            type="feat(components)"
            message="add Counter component"
            ;;
        src/DigitalClock.jsx)
            type="feat(components)"
            message="add DigitalClock component"
            ;;
        src/List.jsx)
            type="feat(components)"
            message="add List component"
            ;;
        src/MyComponent.jsx)
            type="feat(components)"
            message="add MyComponent"
            ;;
        src/Stopwatch.jsx)
            type="feat(components)"
            message="add Stopwatch component"
            ;;
        src/Student.jsx)
            type="feat(components)"
            message="add Student component"
            ;;
        src/ToDoList.jsx)
            type="feat(components)"
            message="add ToDoList component"
            ;;
        src/UpdateArrayState.jsx)
            type="feat(components)"
            message="add UpdateArrayState component"
            ;;
        src/UserGreeting.jsx)
            type="feat(components)"
            message="add UserGreeting component"
            ;;
        public/*)
            type="assets"
            message="add public assets"
            ;;
        src/assets/*)
            type="assets"
            message="add source assets"
            ;;
        *)
            type="chore"
            message="add or update ${file##*/}"
            ;;
    esac

    echo "${type}: ${message}"
}

# Function to check if git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not a git repository. Please initialize git first."
        exit 1
    fi
}

# Function to setup remote repository
setup_remote_repo() {
    # Check if origin remote already exists
    if ! git remote | grep -q "^origin$"; then
        echo "Setting up remote repository..."
        git remote add origin https://github.com/Entue250/react-projects.git
        echo "Remote repository setup complete!"
    else
        # Update the remote URL if it exists but is incorrect
        current_url=$(git remote get-url origin)
        if [ "$current_url" != "https://github.com/Entue250/react-projects.git" ]; then
            echo "Updating remote repository URL..."
            git remote set-url origin https://github.com/Entue250/react-projects.git
            echo "Remote repository URL updated!"
        else
            echo "Remote repository already correctly set up."
        fi
    fi
}

# Function to commit and push changes
commit_and_push_changes() {
    check_git_repo
    setup_remote_repo

    # Get all tracked modified files
    modified_files=$(git ls-files -m)
    
    # Get all untracked files
    untracked_files=$(git ls-files --others --exclude-standard)
    
    echo "Starting commit process..."

    # Process modified files
    if [ -n "$modified_files" ]; then
        echo "Processing modified files..."
        for file in $modified_files; do
            commit_message=$(generate_commit_message "$file")
            git add "$file"
            git commit -m "$commit_message"
            echo "Committed modified file: $file with message - $commit_message"
        done
    else
        echo "No modified files to commit."
    fi

    # Process untracked files
    if [ -n "$untracked_files" ]; then
        echo "Processing untracked files..."
        for file in $untracked_files; do
            commit_message=$(generate_commit_message "$file")
            git add "$file"
            git commit -m "$commit_message"
            echo "Committed untracked file: $file with message - $commit_message"
        done
    else
        echo "No untracked files to commit."
    fi

    # Check current branch and rename to main if needed
    current_branch=$(git branch --show-current)
    if [ "$current_branch" = "master" ]; then
        echo "Renaming master branch to main..."
        git branch -m master main
        echo "Branch renamed to main."
        current_branch="main"
    elif [ "$current_branch" != "main" ]; then
        # If we're not on main, create or switch to main branch
        if git show-ref --verify --quiet refs/heads/main; then
            # main branch exists, switch to it
            echo "Switching to main branch..."
            git checkout main
        else
            # main branch doesn't exist, create it
            echo "Creating main branch..."
            git checkout -b main
        fi
    fi
    
    # Push changes to main branch
    echo "Pushing to main branch on GitHub..."
    git push -u origin main
    
    # If push failed, try with force push after asking for confirmation
    if [ $? -ne 0 ]; then
        read -p "Regular push failed. Would you like to force push (this will overwrite remote changes)? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push -f -u origin main
            if [ $? -eq 0 ]; then
                echo "Force push successful!"
            else
                echo "Force push failed. You may need to authenticate with GitHub or check your permissions."
            fi
        else
            echo "Push aborted. Your local commits are saved but not pushed to GitHub."
        fi
    else
        echo "All changes have been pushed to main branch successfully!"
    fi
}

# Run the function
commit_and_push_changes