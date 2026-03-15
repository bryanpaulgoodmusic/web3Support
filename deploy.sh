#!/bin/bash

# Web3 Support Portal - Firebase Deployment Script
# This script prepares and deploys your static website to Firebase Hosting

echo "🚀 Web3 Support Portal - Firebase Deployment"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI is not installed${NC}"
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Firebase CLI. Please install manually:${NC}"
        echo "npm install -g firebase-tools"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Firebase CLI is installed${NC}"
echo ""

# Check if logged in to Firebase
echo "Checking Firebase authentication..."
firebase projects:list &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠ Not logged in to Firebase${NC}"
    echo "Please log in to Firebase:"
    firebase login
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Firebase login failed${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Authenticated with Firebase${NC}"
echo ""

# Verify project structure
echo "Verifying project structure..."
required_files=("index.html" "wall_connect/index.html" "wall_connect/load.html" "firebase.json")
missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${RED}❌ Missing required files:${NC}"
    printf '%s\n' "${missing_files[@]}"
    exit 1
fi

echo -e "${GREEN}✓ All required files present${NC}"
echo ""

# Check if Firebase project is initialized
if [ ! -f ".firebaserc" ]; then
    echo -e "${YELLOW}⚠ Firebase project not initialized${NC}"
    echo "Initializing Firebase project..."
    firebase init hosting
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Firebase initialization failed${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Firebase project configured${NC}"
echo ""

# Optional: Run a local preview
read -p "Do you want to preview the site locally before deploying? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting local preview..."
    echo "Press Ctrl+C when done previewing"
    firebase serve
fi

# Deploy to Firebase
echo ""
echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo ""
    echo "Your site is now live!"
    echo "Get your hosting URL with: firebase hosting:sites:list"
    echo ""
else
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi
