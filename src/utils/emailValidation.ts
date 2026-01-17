// Dictionnaire des domaines email couramment mal orthographiés
const COMMON_TYPOS: Record<string, string> = {
  // Gmail
  "gmaol.com": "gmail.com",
  "gmal.com": "gmail.com",
  "gmial.com": "gmail.com",
  "gmali.com": "gmail.com",
  "gmaill.com": "gmail.com",
  "gamil.com": "gmail.com",
  "gnail.com": "gmail.com",
  "gmil.com": "gmail.com",
  "gmaik.com": "gmail.com",
  "gmail.fr": "gmail.com",
  "gmail.con": "gmail.com",
  "gmail.cm": "gmail.com",
  "gmail.co": "gmail.com",
  "gmeil.com": "gmail.com",
  
  // Hotmail
  "hotnail.com": "hotmail.com",
  "hotmial.com": "hotmail.com",
  "hotmal.com": "hotmail.com",
  "hotmaol.com": "hotmail.com",
  "hotmail.fr": "hotmail.com",
  "hotmail.con": "hotmail.com",
  "hotamil.com": "hotmail.com",
  "hotmil.com": "hotmail.com",
  
  // Outlook
  "outloock.com": "outlook.com",
  "outlok.com": "outlook.com",
  "outlook.fr": "outlook.com",
  "outlool.com": "outlook.com",
  "outllok.com": "outlook.com",
  
  // Yahoo
  "yaho.com": "yahoo.com",
  "yahooo.com": "yahoo.com",
  "yhoo.com": "yahoo.com",
  "yahoo.fr": "yahoo.com",
  "yahoo.con": "yahoo.com",
  "yhaoo.com": "yahoo.com",
  
  // Orange
  "orage.fr": "orange.fr",
  "oragne.fr": "orange.fr",
  "orangr.fr": "orange.fr",
  
  // Free
  "fre.fr": "free.fr",
  "freee.fr": "free.fr",
  
  // SFR
  "sft.fr": "sfr.fr",
  "srf.fr": "sfr.fr",
  
  // Wanadoo
  "wanadoo.com": "wanadoo.fr",
  "wanado.fr": "wanadoo.fr",
  
  // LaPoste
  "lapost.net": "laposte.net",
  "laposre.net": "laposte.net",
  
  // iCloud
  "iclould.com": "icloud.com",
  "icoud.com": "icloud.com",
  "icloud.con": "icloud.com",
};

export interface EmailTypoResult {
  hasTypo: boolean;
  originalEmail: string;
  suggestedEmail: string | null;
  domain: string;
  suggestedDomain: string | null;
}

/**
 * Détecte les fautes de frappe courantes dans les domaines email
 */
export function detectEmailTypo(email: string): EmailTypoResult {
  const trimmedEmail = email.trim().toLowerCase();
  const atIndex = trimmedEmail.lastIndexOf("@");
  
  if (atIndex === -1) {
    return {
      hasTypo: false,
      originalEmail: email,
      suggestedEmail: null,
      domain: "",
      suggestedDomain: null,
    };
  }
  
  const localPart = trimmedEmail.substring(0, atIndex);
  const domain = trimmedEmail.substring(atIndex + 1);
  
  const suggestedDomain = COMMON_TYPOS[domain];
  
  if (suggestedDomain) {
    return {
      hasTypo: true,
      originalEmail: email,
      suggestedEmail: `${localPart}@${suggestedDomain}`,
      domain,
      suggestedDomain,
    };
  }
  
  return {
    hasTypo: false,
    originalEmail: email,
    suggestedEmail: null,
    domain,
    suggestedDomain: null,
  };
}

/**
 * Valide le format d'un email
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email.trim());
}
