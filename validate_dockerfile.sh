#!/bin/bash

# Simple script to validate Dockerfile syntax
echo "Validating Dockerfile..."

# Check if Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo "Error: Dockerfile not found"
    exit 1
fi

# Check for basic syntax issues
if grep -q "\t" Dockerfile; then
    echo "Warning: Found tabs in Dockerfile, should use spaces"
fi

# Check if all COPY sources exist (skip heredoc lines)
while IFS= read -r line; do
    if [[ $line == COPY\ * ]] && [[ $line != *"<<'*'"* ]]; then
        source=$(echo $line | awk '{print $2}')
        # Skip if it's the heredoc syntax
        if [[ $source != "<<"* ]]; then
            if [ ! -e "./landingpage/$source" ] && [ ! -e "$source" ]; then
                echo "Warning: COPY source '$source' does not exist"
            fi
        fi
    fi
done < Dockerfile

echo "Dockerfile validation completed"