import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Target, History, ArrowRight } from "lucide-react";
import Header from "@/components/Header";
import { useState } from "react";

const PresentationCache = () => {
  const [selectedImage, setSelectedImage] = useState<string | null>(null);

  return (
    <div className="min-h-screen bg-background">
      <Header />
      
      {/* Contenu de présentation sauvegardé pour réutilisation future */}
      <section className="bg-background overflow-hidden">
        {/* 1. SECTION PRÉSENTATION - STYLE "SLIDE" ÉTALÉ */}
        <div className="relative py-12 lg:py-16">
          {/* Fond global très léger */}
          <div className="absolute inset-0 bg-gradient-to-b from-white via-blue-50/20 to-white pointer-events-none" />
          <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-12 relative z-10">
            
            {/* En-tête de section */}
            <div className="text-center max-w-3xl mx-auto mb-12 lg:mb-16">
              <h2 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-slate-900 tracking-tight leading-tight">
                Un outil puissant,<br/>
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-cyan-500">
                  simple à utiliser.
                </span>
              </h2>
            </div>

            {/* LIGNE 1 : TEXTE (Gauche) / IMAGE (Droite) */}
            <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center mb-16 lg:mb-20">
              
              {/* COLONNE TEXTE (Gauche sur Desktop, 2ème sur Mobile) */}
              <div className="order-2 lg:order-1 flex flex-col justify-center">
                <h3 className="text-3xl sm:text-4xl font-bold text-slate-900 mb-6">
                  Ton parcours s'ajuste en temps réel.
                </h3>
                <p className="text-lg text-slate-600 mb-8 leading-relaxed">
                  Siimply analyse chacune de tes réponses pour détecter tes points forts et tes lacunes. Le contenu évolue en permanence pour te proposer le bon exercice, au bon moment.
                </p>
                
                {/* Liste à puces minimaliste */}
                <ul className="space-y-4">
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">Compréhension précise de ton niveau réel.</span>
                  </li>
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">Une aide en maths qui cible précisément tes besoins.</span>
                  </li>
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">Visualise ton évolution et retrouve tous tes échanges.</span>
                  </li>
                </ul>
              </div>

              {/* COLONNE IMAGE (Droite sur Desktop, 1ère sur Mobile) */}
              <div className="order-1 lg:order-2 relative">
                <div className="rounded-3xl overflow-hidden shadow-2xl border border-slate-100 bg-white p-2">
                  <img 
                    src="/images/dashboard-preview.png" 
                    alt="Tableau de bord" 
                    className="w-full max-h-[250px] lg:max-h-[350px] object-contain transform hover:scale-[1.02] transition-transform duration-500" 
                  />
                </div>
                {/* Ombre portée décorative */}
                <div className="absolute -inset-4 rounded-[2rem] -z-10 blur-xl" style={{ backgroundColor: 'rgba(59, 130, 246, 0.1)' }} />
              </div>
            </div>

            {/* LIGNE 2 : IMAGE (Gauche) / TEXTE (Droite) */}
            <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
              
              {/* COLONNE IMAGE (Gauche sur Desktop, 1ère sur Mobile) */}
              <div className="order-1 lg:order-1 relative">
                <div className="rounded-3xl overflow-hidden shadow-2xl border border-slate-100 bg-white p-2">
                  <img 
                    src="/images/chat-preview.png" 
                    alt="Chat d'aide" 
                    className="w-full max-h-[250px] lg:max-h-[350px] object-contain transform hover:scale-[1.02] transition-transform duration-500" 
                  />
                </div>
                <div className="absolute -inset-4 rounded-[2rem] -z-10 blur-xl" style={{ backgroundColor: 'rgba(168, 85, 247, 0.1)' }} />
              </div>

              {/* COLONNE TEXTE (Droite sur Desktop, 2ème sur Mobile) */}
              <div className="order-2 lg:order-2 flex flex-col justify-center">
                <h3 className="text-3xl sm:text-4xl font-bold text-slate-900 mb-6">
                  Siimply te guide dans ta progression.
                </h3>
                <p className="text-lg text-slate-600 mb-8 leading-relaxed">
                  Besoin d'éclaircir le cours ? Besoin d'exercices ? Lesquels sont pertinents ? Siimply s'occupe de tout !
                </p>
                
                <ul className="space-y-4">
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">Humeur, travail récent, objectifs : tout est pris en compte.</span>
                  </li>
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">T'explique la méthode pas à pas, sans juger.</span>
                  </li>
                  <li className="flex items-start gap-4">
                    <div className="mt-2.5 w-2 h-2 rounded-full bg-slate-800 flex-shrink-0" />
                    <span className="text-lg text-slate-700">Dispo 24/7, avec un support de 8h à 23h.</span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* 2. SECTION COMPETENCES : La grosse valeur ajoutée */}
        <div className="relative py-20 lg:py-32 bg-muted/30">
          {/* Formes géométriques décoratives - couleurs inline */}
          <div
            className="absolute top-20 left-10 w-72 h-72 rounded-full blur-3xl"
            style={{ backgroundColor: "rgba(34, 211, 238, 0.05)" }}
          />
          <div
            className="absolute bottom-20 right-10 w-96 h-96 rounded-full blur-3xl"
            style={{ backgroundColor: "rgba(20, 184, 166, 0.05)" }}
          />

          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
            <div className="grid lg:grid-cols-2 gap-12 lg:gap-20 items-center">
              {/* Texte - PREMIER sur mobile, second sur desktop */}
              <div className="lg:order-1 flex flex-col">
                <div
                  className="inline-flex items-center justify-center w-14 h-14 rounded-xl mb-4"
                  style={{ backgroundColor: "rgba(34, 211, 238, 0.15)" }}
                >
                  <Target className="w-7 h-7" style={{ color: "#0891b2" }} />
                </div>

                <h3 className="text-3xl sm:text-4xl font-bold text-foreground mb-3">
                  Ne travaille plus au hasard.
                  <br />
                  <span className="text-primary">Siimply cible ce qu'il faut travailler.</span>
                </h3>

                <p className="text-base text-muted-foreground mb-4">
                  Pourquoi refaire des exercices que tu maîtrises déjà ? Siimply analyse chaque réponse pour
                  construire ta carte de compétences.
                </p>

                <div className="space-y-2 mb-6">
                  {[
                    "Code couleur intuitif (Rouge à Vert)",
                    "Identification précise des chapitres à revoir",
                    "Mise à jour en temps réel après chaque exercice",
                  ].map((item, index) => (
                    <div key={index} className="flex items-center gap-3 text-foreground">
                      <span
                        className="flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold"
                        style={{ backgroundColor: "rgba(34, 197, 94, 0.1)", color: "#16a34a" }}
                      >
                        ✓
                      </span>
                      <span className="text-sm">{item}</span>
                    </div>
                  ))}
                </div>

              </div>

              {/* COLONNE IMAGES - SECOND sur mobile, premier sur desktop */}
              <div className="lg:order-2 relative w-full">
                {/* Mobile: images chevauchées cliquables */}
                <div className="relative h-[350px] lg:hidden">
                  {/* Carte 1 - Radar (derrière, légèrement décalée) */}
                  <div 
                    onClick={() => setSelectedImage("/images/radarcompetences.png")}
                    className="absolute top-0 left-0 w-[80%] h-[180px] bg-white rounded-2xl shadow-xl border border-slate-200 overflow-hidden cursor-pointer hover:scale-[1.02] transition-transform z-10"
                  >
                    <img
                      src="/images/radarcompetences.png"
                      alt="Radar des compétences"
                      className="w-full h-full object-cover"
                    />
                  </div>
                  
                  {/* Carte 2 - Compétences (devant, décalée en bas à droite) */}
                  <div 
                    onClick={() => setSelectedImage("/images/competences-preview-2.png")}
                    className="absolute bottom-0 right-0 w-[80%] h-[180px] bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden cursor-pointer hover:scale-[1.02] transition-transform z-20"
                  >
                    <img
                      src="/images/competences-preview-2.png"
                      alt="Aperçu des compétences Siimply"
                      className="w-full h-full object-contain bg-white"
                    />
                  </div>
                </div>
                
                {/* Desktop: version avec positions absolues */}
                <div className="hidden lg:block relative h-[620px] max-w-[800px] mx-auto">
                  {/* Fond lumineux */}
                  <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-gradient-to-r from-orange-500/10 to-rose-500/10 rounded-full blur-3xl -z-10" />

                  {/* CARTE 1 (Haut Gauche) - LE RADAR */}
                  <div className="absolute top-[-75px] left-[-50px] w-[95%] h-[360px] bg-white rounded-2xl shadow-2xl border border-slate-200 z-10 overflow-hidden hover:z-30 hover:scale-[1.02] transition-all duration-300">
                    <img
                      src="/images/radarcompetences.png"
                      alt="Radar des compétences"
                      className="w-full h-full object-cover object-center"
                    />
                  </div>

                  {/* CARTE 2 (Bas Droite) - L'IMAGE */}
                  <div className="absolute bottom-[-40px] right-0 w-[95%] h-[390px] bg-white rounded-2xl shadow-[0_30px_60px_-10px_rgba(0,0,0,0.2)] border border-slate-200 z-20 overflow-hidden hover:scale-[1.02] transition-all duration-300">
                    <img
                      src="/images/competences-preview-2.png"
                      alt="Aperçu des compétences Siimply"
                      className="w-full h-full object-contain object-center bg-white"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* 3. SECTION HISTORIQUE : Le suivi */}
        <div className="relative py-20 lg:py-32">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
            <div className="grid lg:grid-cols-2 gap-12 lg:gap-20 items-center">
              {/* IMAGE 3 : HISTORIQUE (À Gauche) */}
              <div className="relative">
                <div
                  className="absolute -inset-4 rounded-3xl blur-2xl"
                  style={{
                    background: "linear-gradient(to right, rgba(20, 184, 166, 0.2), rgba(59, 130, 246, 0.2))",
                  }}
                />

                <div className="relative rounded-2xl overflow-hidden shadow-2xl border border-border/50">
                  {/* PLACEHOLDER POUR TON IMAGE HISTORIQUE */}
                  <div className="aspect-video bg-gradient-to-br from-muted to-muted/50 flex items-center justify-center">
                    <span className="text-muted-foreground text-lg">Image Historique</span>
                  </div>
                </div>
              </div>

              {/* Texte à Droite */}
              <div>
                <div className="inline-flex items-center justify-center w-14 h-14 rounded-xl bg-teal/10 text-teal mb-6">
                  <History className="w-7 h-7" />
                </div>

                <h3 className="text-3xl sm:text-4xl font-bold text-foreground mb-4">
                  Une mémoire infaillible de
                  <br />
                  <span className="text-teal">tous tes entraînements.</span>
                </h3>

                <p className="text-lg text-muted-foreground mb-8">
                  Retrouve instantanément n'importe quel exercice passé, une explication de cours ou une
                  correction. C'est comme avoir un cahier de classeur parfaitement organisé, automatiquement.
                </p>

                <Link to="/exercise">
                  <Button className="bg-gradient-to-r from-teal to-blue-500 hover:from-teal/90 hover:to-blue-500/90 text-white text-lg px-8 py-6 h-auto rounded-xl font-bold shadow-xl hover:shadow-teal/30 transition-all hover:scale-105 group">
                    Commencer un exercice
                    <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </div>

        {/* Footer Section - Derrière Siimply */}
        <div className="py-20 bg-muted/30">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 className="text-3xl sm:text-4xl font-bold mb-6">L'offre</h2>
            <p className="text-lg text-muted-foreground max-w-3xl mx-auto mb-8">
              Une équipe passionnée par la pédagogie et la technologie.
            </p>
            <div className="grid md:grid-cols-3 gap-6">
              <div className="p-6 rounded-2xl bg-card border border-border">
                <div className="text-4xl mb-3">🎓</div>
                <h3 className="text-lg font-bold mb-2">Notre mission</h3>
                <p className="text-muted-foreground text-sm">Rendre les maths accessibles à tous les élèves.</p>
              </div>
              <div className="p-6 rounded-2xl bg-card border border-border">
                <div className="text-4xl mb-3">👥</div>
                <h3 className="text-lg font-bold mb-2">L'équipe</h3>
                <p className="text-muted-foreground text-sm">Des passionnés de pédagogie et de technologie.</p>
              </div>
              <div className="p-6 rounded-2xl bg-card border border-border">
                <div className="text-4xl mb-3">💡</div>
                <h3 className="text-lg font-bold mb-2">Nos valeurs</h3>
                <p className="text-muted-foreground text-sm">Bienveillance, personnalisation, excellence.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Modal pour image agrandie */}
      {selectedImage && (
        <div 
          className="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4"
          onClick={() => setSelectedImage(null)}
        >
          <img 
            src={selectedImage} 
            alt="Image agrandie" 
            className="max-w-full max-h-full object-contain rounded-lg"
          />
        </div>
      )}
    </div>
  );
};

export default PresentationCache;
