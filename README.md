# Web3 Support Portal

## Quick Deployment Guide

### Prerequisites
- Node.js installed
- Firebase account

### Setup Steps

1. **Install Firebase CLI** (if not already installed):
```bash
npm install -g firebase-tools
```

2. **Login to Firebase**:
```bash
firebase login
```

3. **Initialize Firebase** (first time only):
```bash
firebase init hosting
```
- Select your Firebase project
- Set public directory to: `.` (current directory)
- Configure as single-page app: `No`
- Don't overwrite existing files

4. **Deploy**:

**Linux/Mac**:
```bash
./deploy.sh
```

**Windows**:
```powershell
.\deploy.ps1
```

Or manually:
```bash
firebase deploy --only hosting
```

### Project Structure
```
├── index.html (Home page)
├── wall_connect/
│   ├── index.html (Wallet connection form)
│   ├── load.html (Loading/redirect page)
│   └── assets/ (Images and resources)
├── firebase.json
└── .firebaserc
```

### User Flow
1. User visits home page (`index.html`)
2. Clicks any CTA → Goes to `wall_connect/index.html`
3. Submits form → Redirected to `load.html`
4. After 3 seconds → Returns to home page
