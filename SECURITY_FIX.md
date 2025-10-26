# 🚨 SECURITY INSTRUCTIONS - API Keys Exposed

## ⚠️ IMMEDIATE ACTION REQUIRED

Your API keys were exposed in the Git repository. Follow these steps immediately:

### 1. **Revoke Exposed API Keys** (DO THIS FIRST!)

#### Google Maps API Key
1. Go to: https://console.cloud.google.com/apis/credentials
2. Find key: `AIzaSyBACfCrohI6uhi8Qdb6oqOGjnsrBRikm5w`
3. Click the key → Click "DELETE" or "REGENERATE"
4. Create a new API key with proper restrictions

#### Gemini API Key  
1. Go to: https://aistudio.google.com/app/apikey
2. Find key: `AIzaSyCr8AzFi80IKyPp_0chNl0to3yITs7f0WA`
3. Delete this key immediately
4. Generate a new API key

### 2. **Clean Git History**

The keys are in your initial commit. You have two options:

#### Option A: Force Push (Recommended for new repos)
```powershell
# Commit the fixes
git add web/index.html MAPS_QUICK_GUIDE.md
git commit -m "security: remove exposed API keys"

# Force push to overwrite history
git push origin main --force
```

#### Option B: Use BFG Repo-Cleaner (for thorough cleaning)
```powershell
# Download BFG: https://rtyley.github.io/bfg-repo-cleaner/

# Create a file with keys to remove
echo "AIzaSyBACfCrohI6uhi8Qdb6oqOGjnsrBRikm5w" > keys.txt
echo "AIzaSyCr8AzFi80IKyPp_0chNl0to3yITs7f0WA" >> keys.txt

# Run BFG
java -jar bfg.jar --replace-text keys.txt agritrace

# Force push
git push origin main --force
```

### 3. **Set Up New Keys Securely**

#### For Local Development (.env)
```env
# .env (already in .gitignore - NEVER commit this!)
GEMINI_API_KEY=your_new_gemini_key_here
GOOGLE_MAPS_API_KEY=your_new_maps_key_here
```

#### For Web (index.html)
Use environment variables or leave placeholder:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY_HERE"></script>
```

#### For Android (AndroidManifest.xml)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${MAPS_API_KEY}"/>
```

Then add to `android/local.properties`:
```properties
MAPS_API_KEY=your_new_key_here
```

### 4. **Add API Key Restrictions**

#### Google Maps API:
- Application restrictions: HTTP referrers or Android apps
- API restrictions: Maps JavaScript API, Maps SDK for Android
- Restrict to your domain/package name

#### Gemini API:
- Add IP restrictions if possible
- Monitor usage regularly

### 5. **Verify .gitignore**

Ensure these are in `.gitignore`:
```
.env
.env.local
.env.*.local
*.key
local.properties
key.properties
google-services.json
```

### 6. **Monitor for Unauthorized Usage**

- Check Google Cloud Console for unusual activity
- Set up billing alerts
- Review API usage logs

---

## ✅ Checklist

- [ ] Revoked old Google Maps API key
- [ ] Revoked old Gemini API key
- [ ] Generated new API keys
- [ ] Added restrictions to new keys
- [ ] Committed API key removal
- [ ] Force pushed to GitHub
- [ ] Updated .env with new keys (NOT committed)
- [ ] Tested app with new keys
- [ ] Set up billing alerts

---

**Time Sensitive:** Do steps 1-2 within the next 30 minutes!
