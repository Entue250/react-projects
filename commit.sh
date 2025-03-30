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

# Function to handle repository setup
handle_repository_setup() {
    # Rename master branch to main if needed
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

    # Check if there's already a remote branch
    if git ls-remote --heads origin main | grep -q main; then
        echo "Remote main branch exists."
        
        echo "Since you are setting up a new local repository for an existing GitHub project,"
        echo "you need to decide how to handle the diverging histories:"
        echo "1. Force push your current code (will OVERWRITE any existing code on GitHub)"
        echo "2. Pull remote changes first (will attempt to merge with your local code)"
        read -p "Enter your choice (1 or 2): " choice
        
        case $choice in
            1)
                echo "You chose to force push your local repository."
                ;;
            2)
                echo "Pulling remote changes before pushing..."
                
                # Try to pull, but this might fail if histories are unrelated
                if ! git pull origin main --allow-unrelated-histories; then
                    echo "Pull failed. The histories may be unrelated."
                    echo "1. Force push anyway (OVERWRITE remote)"
                    echo "2. Create a fresh clone and manually copy your files"
                    read -p "Enter your choice (1 or 2): " fallback_choice
                    
                    case $fallback_choice in
                        1)
                            echo "You chose to force push despite pull failure."
                            ;;
                        2)
                            echo "Please follow these steps manually:"
                            echo "1. git clone https://github.com/Entue250/react-projects.git temp-repo"
                            echo "2. Copy your files to temp-repo"
                            echo "3. cd temp-repo"
                            echo "4. git add ."
                            echo "5. git commit -m \"feat: add React project files\""
                            echo "6. git push"
                            exit 0
                            ;;
                        *)
                            echo "Invalid choice. Exiting."
                            exit 1
                            ;;
                    esac
                fi
                ;;
            *)
                echo "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi
}

# Function to commit changes
commit_changes() {
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
}

# Function to push changes to GitHub
push_to_github() {
    echo "Pushing to main branch on GitHub..."
    
    # Try normal push first
    if git push -u origin main; then
        echo "All changes have been pushed to main branch successfully!"
    else
        echo "Regular push failed."
        echo "This usually happens when the remote repository has changes that your local repository doesn't have."
        
        echo "Options:"
        echo "1. Force push (OVERWRITES remote repository content)"
        echo "2. Cancel (your commits will remain local only)"
        read -p "Enter your choice (1 or 2): " push_choice
        
        case $push_choice in
            1)
                echo "Force pushing to GitHub..."
                if git push -f -u origin main; then
                    echo "Force push successful! All remote content has been replaced with your local content."
                else
                    echo "Force push failed. You may need to check your GitHub credentials or repository permissions."
                fi
                ;;
            2)
                echo "Push canceled. Your changes remain committed locally but are not on GitHub."
                ;;
            *)
                echo "Invalid choice. Push canceled."
                ;;
        esac
    fi
}

# Main function
main() {
    check_git_repo
    setup_remote_repo
    handle_repository_setup
    commit_changes
    push_to_github
}

# Run the script
main