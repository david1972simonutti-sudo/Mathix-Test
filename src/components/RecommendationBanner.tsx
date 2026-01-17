import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { Target } from "lucide-react";

interface RecommendationBannerProps {
  chapitre: string;
  sousNotion: string;
  details?: string;
}

const RecommendationBanner = ({ chapitre, sousNotion, details }: RecommendationBannerProps) => {
  const navigate = useNavigate();
  const chapitreAffiche = (chapitre || "").trim() || "ce chapitre";

  const handleStartExercise = () => {
    const params = new URLSearchParams();
    params.set("chapitre", chapitre);
    if (sousNotion) params.set("sous_notion", sousNotion);
    params.set("from", "competences");
    navigate(`/exercise?${params.toString()}`);
  };

  return (
    <div 
      className="relative overflow-hidden rounded-2xl p-8 mb-8 shadow-2xl"
      style={{
        background: 'linear-gradient(135deg, hsl(25, 95%, 58%) 0%, hsl(330, 85%, 60%) 50%, hsl(0, 84%, 60%) 100%)',
      }}
    >
      <div className="relative z-10">
        <div className="flex items-start gap-6">
          <div className="rounded-full bg-white/20 backdrop-blur-sm p-4 shadow-lg">
            <Target className="h-10 w-10 text-white" />
          </div>
          <div className="flex-1">
            <h2 className="text-3xl font-bold mb-3 text-white">
              🎯 Priorité : travailler{" "}
              <span className="font-extrabold">
                {chapitreAffiche}
              </span>
            </h2>
            <p className="text-white/95 mb-5 text-lg">
              {details || "Continue de t'entraîner sur ce chapitre !"}
            </p>
            <Button 
              onClick={handleStartExercise} 
              size="lg" 
              className="gap-2 bg-white text-pink hover:bg-white/90 shadow-lg text-lg px-8 py-6 font-semibold"
            >
              Commencer un exercice
            </Button>
          </div>
        </div>
      </div>
      <div className="pointer-events-none absolute -top-10 -right-10 w-80 h-80 bg-white/10 rounded-full blur-3xl" />
      <div className="pointer-events-none absolute -bottom-10 -left-10 w-64 h-64 bg-white/10 rounded-full blur-2xl" />
    </div>
  );
};

export default RecommendationBanner;
